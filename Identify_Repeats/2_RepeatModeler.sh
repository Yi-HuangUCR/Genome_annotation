#!/bin/bash -l
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=10
#SBATCH --mem-per-cpu=7G
#SBATCH --nodes=1
#SBATCH --time=2-00:00:00
#SBATCH --mail-user=yhuan073@ucr.edu
#SBATCH --mail-type=ALL
#SBATCH --output=1_repeatmodeler.stdout
set -e

module load RepeatModeler/1.0.11
module load RepeatMasker/4-0-7
module load BBMap
module load ncbi-blast/2.2.30+
module load hmmer/3.1b2

# Download some tools to help parse
if [ ! -d Custom-Repeat-Library ]; then
    git clone https://github.com/megbowman/Custom-Repeat-Library.git
fi

# Remove short contigs in the assembly. I don't know if this is wise, but it might reduce runtime a bit and I can always include them later if this has the effect I want
if [ ! -e manzanita.fa ]; then
    reformat.sh in=/bigdata/littlab/shared/Manzanita/Dovetail_final_assembly/second_delivered/arctostaphylos_sp_29Aug2019_kc8ay.fasta out=manzanita.fa minlength=250
fi

# Build Repeat Database
if [ ! -e manzanita.nsq ]; then
    BuildDatabase -name manzanita -engine ncbi manzanita.fa
fi

# Classify them if possilbe
if [ ! -e RM_16304.WedApr291637132020 ]; then
    RepeatModeler \
	-database manzanita \
	-engine ncbi \
	-pa $SLURM_CPUS_PER_TASK 
fi

# Separate out unknown repeats
if [ !- e RepeatModeler_unknowns.fasta ]; then
    perl Custom-Repeat-Library/repeatmodeler_parse.pl \
	--fastafile RM_16304.WedApr291637132020/consensi.fa.classified \
	--unknowns RepeatModeler_unknowns.fasta \
	--identities RepeatModeler_identities.fasta
fi

# Download and make database of known transposases for classification of unknowns
if [ ! -e Tpases020812.psq ]; then
    wget http://www.hrt.msu.edu/uploads/535/78637/Tpases020812.gz
    gunzip Tpases020812.gz
    makeblastdb -in Tpases020812  -dbtype prot
fi

# Attempt to classify unknown elements
if [ ! -e ModelerID.lib ]; then
    blastx -query RepeatModeler_unknowns.fasta -db Tpases020812  -evalue 1e-10 -num_descriptions 10 -out RepeatModeler_unknown_blast_results.txt
    perl Custom-Repeat-Library/transposon_blast_parse.pl --blastx RepeatModeler_unknown_blast_results.txt --modelerunknown RepeatModeler_unknowns.fasta
    mv  unknown_elements.txt  ModelerUnknown.lib
    cat identified_elements.txt  RepeatModeler_identities.fasta  > ModelerID.lib
fi

# Exclude hits that match a known (non-TE) protein
if [ ! -e ModelerUnknown.lib_blast_results.txt ]; then
    wget http://www.hrt.msu.edu/uploads/535/78637/alluniRefprexp070416.gz
    gunzip alluniRefprexp070416.gz
    makeblastdb -in alluniRefprexp070416  -dbtype prot
    blastx -query ModelerUnknown.lib -db alluniRefprexp070416  -evalue 1e-10 -num_descriptions 10 -out ModelerUnknown.lib_blast_results.txt
fi

# Install ProtExcluder
if [ ! -d ProtExcluder1.2 ]; then
    wget http://www.hrt.msu.edu/uploads/535/78637/ProtExcluder1.2.tar.gz
    tar -xf ProtExcluder1.2.tar.gz
    cd ProtExcluder1.2
    ./Installer.pl  -m  /opt/linux/centos/7.x/x86_64/pkgs/hmmer/3.1b2/bin/  -p /bigdata/littlab/shared/Manzanita/Dovetail_final_assembly/second_delivered/Mask_repetitive_element/ProtExcluder1.2/
    echo You need to manually edit the mspesl-sfetch.pl hmmer path to say "bin" instead of "binaries"
fi

# Actually Run ProtExcluder on the BLAST results
if [ ! -e ModelerUnknown.libnoProtFinal ]; then
    ./ProtExcluder1.2/ProtExcluder.pl  ModelerUnknown.lib_blast_results.txt  ModelerUnknown.lib
fi

# Get all the repeats 
if [ ! -e FinalRepeats.fa ]; then
    queryRepeatDatabase.pl -species all > repeatmasker.all.fa
    cat ModelerUnknown.libnoProtFinal ModelerID.lib repeatmasker.all.fa > FinalRepeats.fa
fi
