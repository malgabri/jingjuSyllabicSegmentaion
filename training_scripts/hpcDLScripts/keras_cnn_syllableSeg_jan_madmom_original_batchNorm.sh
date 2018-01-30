#!/bin/bash

# change python version
#module load cuda/8.0
#module load theano/0.8.2

# two variables you need to set
#device=gpu0  # the device to be used. set it to "cpu" if you don't have GPUs

# export environment variables
#
export PATH=/homedtic/rgong/anaconda2/bin:$PATH
#export THEANO_FLAGS=mode=FAST_RUN,device=$device,floatX=float32,lib.cnmem=0.475
#export PATH=/usr/local/cuda/bin/:$PATH
#export LD_LIBRARY_PATH=/usr/local/cuda/lib64/:$LD_LIBRARY_PATH
#export LD_LIBRARY_PATH=/soft/cuda/cudnn/cuda/lib64:$LD_LIBRARY_PATH
#export CPATH=/soft/cuda/cudnn/cuda/include:$CPATH
#export LIBRARY_PATH=/soft/cuda/cudnn/cuda/lib64:$LD_LIBRARY_PATH

source activate keras_env

printf "Removing local scratch directories if exist...\n"
if [ -d /scratch/rgongcnnSyllableSeg_jan_madmom_original_batchNorm ]; then
        rm -Rf /scratch/rgongcnnSyllableSeg_jan_madmom_original_batchNorm
fi

# Second, replicate the structure of the experiment's folder:
# -----------------------------------------------------------
mkdir /scratch/rgongcnnSyllableSeg_jan_madmom_original_batchNorm
mkdir /scratch/rgongcnnSyllableSeg_jan_madmom_original_batchNorm/syllableSeg


printf "Copying feature files into scratch directory...\n"
# Third, copy the experiment's data:
# ----------------------------------
start=`date +%s`
cp -rp /homedtic/rgong/cnnSyllableSeg/syllableSeg/feature_all_ismir_madmom.h5 /scratch/rgongcnnSyllableSeg_jan_madmom_original_batchNorm/syllableSeg/
end=`date +%s`

printf "Finish copying feature files into scratch directory...\n"
printf $((end-start))


#$ -N jan_batchNorm
#$ -q default.q
#$ -l h=node05

# Output/Error Text
# ----------------
#$ -o /homedtic/rgong/cnnSyllableSeg/out/cnn_jan_batchNorm.$JOB_ID.out
#$ -e /homedtic/rgong/cnnSyllableSeg/error/cnn_jan_batchNorm.$JOB_ID.err

python /homedtic/rgong/cnnSyllableSeg/jingjuSyllabicSegmentation/training_scripts/hpcDLScripts/keras_cnn_syllableSeg_jan_madmom_original_batchNorm.py

# Clean the crap:
# ---------------
printf "Removing local scratch directories...\n"
if [ -d /scratch/rgongcnnSyllableSeg_jan_madmom_original_batchNorm ]; then
        rm -Rf /scratch/rgongcnnSyllableSeg_jan_madmom_original_batchNorm
fi
printf "Job done. Ending at `date`\n"