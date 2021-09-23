#!/bin/bash -l

#SBATCH --nodes=1
#SBATCH --ntasks=20
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=20G
#SBATCH --time=03-00:00:00     # 7 day
#SBATCH --output=maker_round1.stdout
#SBATCH --mail-user=yhuan073@ucr.edu
#SBATCH --mail-type=ALL
#SBATCH --job-name="one_time_intel_maker"
#SBATCH -p intel # This is the default partition, you can use any of the following; intel, batch, highmem, gpu

#module unload mpich/3.2
#module load mpich/3.2.1
#module unload openmpi
#module load perl/5.24.0

module load maker/2.31.11
#module load RepeatModeler/1.0.11
#module load RepeatMasker/4-0-7

#Path to wu-last
export PATH=/bigdata/littlab/yhuan073/software/wu-blast/:$PATH

export WUBLASTFILTER=/bigdata/littlab/yhuan073/software/wu-blast/filter

export WUBLASTMAT=/bigdata/littlab/yhuan073/software/wu-blast/matrix

#Path to Exonerate
export PATH=/bigdata/littlab/yhuan073/software/exonerate/bin:$PATH

# Path to Augustus
export AUGUSTUS_CONFIG_PATH=/bigdata/littlab/yhuan073/software/augustus/config

export PATH=/bigdata/littlab/yhuan073/software/augustus/bin:$PATH

# Path to GeneMark-Es
export PATH=/bigdata/littlab/yhuan073/software/GeneMark-ES/current:$PATH

#Path to RepeatMasker
export PATH=/bigdata/littlab/yhuan073/software/RepeatMasker/RepeatMasker:$PATH

#Path to SNAP
export PATH=/bigdata/littlab/yhuan073/software/SNAP/bin:$PATH

#Path to maker
#export PATH=/bigdata/littlab/yhuan073/software/Maker/bin:$PATH
#export PATH=/bigdata/littlab/shared/Manzanita/Dovetail_final_assembly/second_delivered/MAKER/bin:$PATH
#maker -CTL

#Run parrallel
#./MPI/bin/mpiexec -n $SLURM_NTASKS maker maker_bopts.ctl  maker_exe.ctl  maker_opts.ctl
#mpirun maker -fix_nucleotides -base glauca_rnd2 -f maker_bopts.ctl maker_exe.ctl maker_opts.ctl 
mpirun maker maker_bopts.ctl  maker_exe.ctl  maker_opts.ctl
