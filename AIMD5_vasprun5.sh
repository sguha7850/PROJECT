#!/bin/sh
#SBATCH --job-name=serial_job_test     ## Job name
#SBATCH --ntasks=1                     ## Run on a single CPU can take upto 10
#SBATCH --time=72:00:00                ## Time limit hrs:min:sec, its specific to queue being used
#SBATCH --output=serial_test_job.out   ## Standard output
#SBATCH --error=serial_test_job.err    ## Error log
#SBATCH --gres=gpu:4                   ## GPUs needed, should be same as selected queue GPUs
#SBATCH --partition=q_3day-4G          ## Specific to queue being used, need to select from queues available
#SBATCH --mem=200GB                      ## Memory for computation process can go up to 100GB

# Set NVIDIA HPC environment variables
MANPATH=$MANPATH:/opt/nvidia/hpc_sdk/Linux_x86_64/23.7/compilers/man; export MANPATH
PATH=/opt/nvidia/hpc_sdk/Linux_x86_64/23.7/compilers/bin:$PATH; export PATH
export PATH=/opt/nvidia/hpc_sdk/Linux_x86_64/23.7/comm_libs/mpi/bin:$PATH
export MANPATH=$MANPATH:/opt/nvidia/hpc_sdk/Linux_x86_64/23.7/comm_libs/mpi/man
module load nvhpc

pwd; hostname; date |tee result
##example for above looks like( do not include these 2 highlighted lines in your script): 
#docker run -t --gpus '"device='$CUDA_VISIBLE_DEVICES'"' --name $SLURM_JOB_ID --ipc=host --shm-size=200GB -v /raid/cedsan/new_docker pymatgen_cuda bash -c "mkdir /home/test_hello1 && mkdir /home/test_bye" | tee -a vasprun_dis3_output.txt

# Commit the container changes to the image
#docker commit $SLURM_JOB_ID pymatgen_cuda

#docker run -t --gpus '"device='$CUDA_VISIBLE_DEVICES'"' --name $SLURM_JOB_ID --ipc=host --shm-size=200GB -v /raid/cedsan/new_docker pymatgen_cuda bash -c "mkdir /home/test_bye" | tee -a vasprun_dis4_output.txt



docker run -t --gpus '"device='$CUDA_VISIBLE_DEVICES'"' --name $SLURM_JOB_ID --ipc=host --shm-size=200GB -v /raid/esehai/mydocker parallel_processing bash -c "export PATH=/opt/nvidia/hpc_sdk/Linux_x86_64/23.7/compilers/bin:/opt/nvidia/hpc_sdk/Linux_x86_64/23.7/comm_libs/mpi/bin:\$PATH;
export MANPATH=\$MANPATH:/opt/nvidia/hpc_sdk/Linux_x86_64/23.7/compilers/man:/opt/nvidia/hpc_sdk/Linux_x86_64/23.7/comm_libs/mpi/man; export LD_LIBRARY_PATH=/opt/nvidia/hpc_sdk/Linux_x86_64/23.7/compilers/extras/qd/lib/:/usr/tools/lib:/opt/nvidia/hpc_sdk/Linux_x86_64/23.7/comm_libs/openmpi/openmpi-3.1.5/lib:$LD_LIBRARY_PATH; source ~/.bashrc && cd /home/ML_Distorted_3000K/ && python3 --version && mpirun --allow-run-as-root -np 4 /home/vasp.6.4.3/bin/vasp_std" | tee -a ML_Distorted_3000K.txt



# Commit the container changes to the image
docker commit $SLURM_JOB_ID parallel_processing

#'$CUDA_VISIBLE_DEVICES'