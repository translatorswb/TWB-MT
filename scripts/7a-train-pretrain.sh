#! /bin/bash
# Script for bidirectional pre-training
# Example call: 
# bash 7a-train-pretrain.sh <experiment-prefix> <model-type> <model-id> <bpe-id> <dataset-id> <lang-1> <lang-2> <batch-size> <validation-save-steps>

#INITIALIZATIONS (Do not edit)
FS="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
CORPORADIR="$FS/../corpora"
DATADIR="$FS/../onmt/data"
MODELDIR="$FS/../onmt/models"
LOGDIR="$FS/../onmt/logs"

#In-script Options
SEED="42"
REMOVECHECKPOINTS="1"  #Make 0 if you want to keep non-best models at the end

#PROCEDURES
function do_train() {
    MODELNAME=$MODELPREFIX-$MODELSRC-$MODELTGT-$MODELTYPE-$MODELID
    echo Training $MODELNAME
    echo Using dataset: $DATASET.$BPEID

    mkdir -p $MODELDIR/$MODELNAME
    mkdir -p $LOGDIR

    onmt_train -data $DATADIR/$DATASET.$BPEID \
           -save_model $MODELDIR/$MODELNAME/$MODELNAME \
           -layers 6 -rnn_size 512 -word_vec_size 512 -transformer_ff 2048 -heads 8  \
           -encoder_type transformer -decoder_type transformer -position_encoding \
           -max_generator_batches 2 -dropout 0.2 -seed $SEED \
               -batch_size $BATCHSIZE -batch_type tokens -normalization tokens -accum_count 2 \
           -optim adam -adam_beta2 0.998 -decay_method noam -warmup_steps 8000 -learning_rate 2 \
           -max_grad_norm 0 -param_init 0  -param_init_glorot -label_smoothing 0.1 \
           -train_steps 1000000 -early_stopping 5 -early_stopping_criteria ppl \
           -valid_steps $VALIDSAVE -save_checkpoint_steps $VALIDSAVE  -report_every $REPORT \
           -world_size 2 -gpu_ranks 0 1 > $LOGDIR/train-$MODELNAME.log 2>&1

    #Mark best model
    BESTSTEP=`cat $LOGDIR/train-$MODELNAME.log | grep "Best model found at step" | rev | cut -d' ' -f1 | rev`
    BESTMODEL=$MODELDIR/$MODELNAME/${MODELNAME}_step_${BESTSTEP}.pt
    echo Best model: $BESTMODEL
    mv $BESTMODEL $MODELDIR/$MODELNAME/${MODELNAME}_best_step_${BESTSTEP}.pt

    if [ $REMOVECHECKPOINTS == 1 ]
    then
      rm $MODELDIR/$MODELNAME/${MODELNAME}_step_*
    fi
    
}

#PARAMETERS
MODELPREFIX=$1
MODELTYPE=$2
MODELID=$3
BPEID=$4
DATASETID=$5
LANGA=$6
LANGB=$7
BATCHSIZE=$8
VALIDSAVE=$9

#CALLS
MODELSRC=$LANGA
MODELTGT=$LANGB
DATASET="$DATASETID.$MODELSRC-$MODELTGT"
REPORT=50
do_train

MODELSRC=$LANGB
MODELTGT=$LANGA
DATASET="$DATASETID.$MODELSRC-$MODELTGT"
do_train

#ending alert 
echo -en "\007"
