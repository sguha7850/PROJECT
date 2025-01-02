#!/bin/sh
#SBATCH --job-name=serial_job_test     ## Job name
#SBATCH --ntasks=1                     ## Run on a single CPU can take upto 10
#SBATCH --time=24:00:00                ## Time limit hrs:min:sec, its specific to queue being used
#SBATCH --output=serial_test_job.out   ## Standard output
#SBATCH --error=serial_test_job.err    ## Error log
#SBATCH --gres=gpu:1                   ## GPUs needed, should be same as selected queue GPUs
#SBATCH --partition=q_1day-1G          ## Specific to queue being used, need to select from queues available
#SBATCH --mem=20GB                      ## Memory for computation process can go up to 100GB

# Set NVIDIA HPC environment variables
MANPATH=$MANPATH:/opt/nvidia/hpc_sdk/Linux_x86_64/23.7/compilers/man; export MANPATH
PATH=/opt/nvidia/hpc_sdk/Linux_x86_64/23.7/compilers/bin:$PATH; export PATH
export PATH=/opt/nvidia/hpc_sdk/Linux_x86_64/23.7/comm_libs/mpi/bin:$PATH
export MANPATH=$MANPATH:/opt/nvidia/hpc_sdk/Linux_x86_64/23.7/comm_libs/mpi/man
module load nvhpc

pwd; hostname; date |tee result
##example for above looks like( do not include these 2 highlighted lines in your script): 
docker run -t --gpus '"device='$CUDA_VISIBLE_DEVICES'"' --name $SLURM_JOB_ID --ipc=host --shm-size=20GB -v /raid/esehai/mydocker parallel_processing bash -c "export PATH=/opt/nvidia/hpc_sdk/Linux_x86_64/23.7/compilers/bin:/opt/nvidia/hpc_sdk/Linux_x86_64/23.7/comm_libs/mpi/bin:\$PATH;
export MANPATH=\$MANPATH:/opt/nvidia/hpc_sdk/Linux_x86_64/23.7/compilers/man:/opt/nvidia/hpc_sdk/Linux_x86_64/23.7/comm_libs/mpi/man && cd /home/vasp.6.4.3/ && make veryclean && make DEPS=1 -j" | tee -a log_vasp.6.4.3_out.txt

#docker run -it pymatgen_cuda /bin/bash

docker commit $SLURM_JOB_ID parallel_processing

