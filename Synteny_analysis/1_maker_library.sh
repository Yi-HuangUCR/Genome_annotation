#!/bin/bash -l

#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=10
#SBATCH --mem-per-cpu=10G
#SBATCH --time=03-00:00:00     # 1 day and 15 minutes
#SBATCH --output=query.stdout
#SBATCH --mail-user
#SBATCH --mail-type=ALL
#SBATCH --job-name="protein_only_query"
#SBATCH -p intel # This is the default partition, you can use any of the following; intel, batch, highmem, gpu

module load ncbi-blast
#makeblastdb -in ../Arctostaphylos_glauca.cds-transcripts.fa -dbtype prot -parse_seqids -out arc.db/arc_ptr
#blastp -query ../Arctostaphylos_glauca.cds-transcripts.fa -out arc_ptr.blast -db arc.db/arc_ptr -outfmt 6 -evalue 1e-5 -num_threads 62


makeblastdb -in ../Arctostaphylos_glauca.proteins.fa -dbtype prot -parse_seqids -out arc.db/arc_ptr
blastp -query ../Arctostaphylos_glauca.proteins.fa -out ag.blast -db arc.db/arc_ptr -outfmt 6 -evalue 1e-5 -num_threads 62


#makeblastdb -in ../ag_rw.fasta -dbtype prot -parse_seqids -out ag_rw.db/ag_rw
#blastp -query ../ag_rw.fasta -out ag_rw.blast -db ag_rw.db/ag_rw -outfmt 6 -evalue 1e-5 -num_threads 62
