#! /bin/bash
#INITIALIZATIONS (Do not edit)
FS="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
CORPORADIR="$FS/../corpora"
DATADIR="$FS/../onmt/data"
MODELDIR="$FS/../onmt/models"
LOGDIR="$FS/../onmt/logs"
MODELTYPE="intwb"
SEED="42"

#PROCEDURES
function do_train() {
    # BASEMODELNAME=$MODELPREFIX-$BASEMODELSRC-$BASEMODELTGT-$BASEMODELTYPE-$BASEMODELID
    BASEMODELID=`echo $BASEMODELNAME | cut -d'-' -f5-`
    MODELNAME=$MODELPREFIX-$MODELSRC-$MODELTGT-$MODELTYPE-$BASEMODELID-$MODELID

    echo Training $MODELNAME on $BASEMODELNAME
    echo using dataset: $DATASET.$BPEID

    mkdir -p $MODELDIR/$MODELNAME
    mkdir -p $LOGDIR

    #For debug
    # echo "BASE: $BASEMODELNAME/${BASEMODELNAME}_best.pt"
    if test -f "$MODELDIR/$BASEMODELNAME/${BASEMODELNAME}_best.pt"; then
        echo "Basemodel in its place"
    else 
        echo "Basemodel NOT FOUND!"
        exit 0
    fi

    onmt_train -data $DATADIR/$DATASET.$BPEID -train_from $MODELDIR/$BASEMODELNAME/${BASEMODELNAME}_best.pt \
            -save_model $MODELDIR/$MODELNAME/$MODELNAME \
            -layers 6 -rnn_size 512 -word_vec_size 512 -transformer_ff 2048 -heads 8  \
            -encoder_type transformer -decoder_type transformer -position_encoding \
        -max_generator_batches 2 -dropout 0.3 -seed $SEED \
        -batch_size $BATCHSIZE  -accum_count 2 \
        -optim adam -adam_beta2 0.998 -decay_method noam -warmup_steps 4000 -learning_rate 2 \
        -max_grad_norm 0 -param_init 0  -param_init_glorot -label_smoothing 0.1 \
        -train_steps 1000000 -early_stopping 5 -early_stopping_criteria ppl \
        -valid_steps $VALIDSAVE -save_checkpoint_steps $VALIDSAVE -report_every $REPORT \
        -world_size 2 -gpu_ranks 0 1 > $LOGDIR/train-$MODELNAME.log 2>&1
    
    #Make a symlink to best model
    BESTSTEP=`cat $LOGDIR/train-$MODELNAME.log | grep "Best model found at step" | rev | cut -d' ' -f1 | rev`
    BESTMODEL=$MODELDIR/$MODELNAME/${MODELNAME}_step_${BESTSTEP}.pt
    echo Best model: $BESTMODEL
    ln -sf $BESTMODEL $MODELDIR/$MODELNAME/${MODELNAME}_best.pt

    #For debug
    # touch $MODELDIR/$MODELNAME/${MODELNAME}_best.pt
}

#PARAMETERS
MODELPREFIX=$1
BPEID=$2
DATASETID=$3
LANGA=$4
LANGB=$5
BATCHSIZE=$6
VALIDSAVE=$7
BASEMODELTAGS=$8
BASEMODELLANGA=$9
BASEMODELLANGB=${10}

#CALLS
MODELSRC=$LANGA
MODELTGT=$LANGB
BASEMODELSRC=$BASEMODELLANGA
BASEMODELTGT=$BASEMODELLANGB
MODELID="t001"
DATASET="$DATASETID.$MODELSRC-$MODELTGT"
BASEMODELNAME=$MODELPREFIX-$BASEMODELSRC-$BASEMODELTGT-$BASEMODELTAGS
REPORT=10
do_train

MODELSRC=$LANGB
MODELTGT=$LANGA
BASEMODELSRC=$BASEMODELLANGB
BASEMODELTGT=$BASEMODELLANGA
BASEMODELTYPE="inswc"
BASEMODELID="s001-i001"
MODELID="t001"
DATASET="$DATASETID.$MODELSRC-$MODELTGT"
BASEMODELNAME=$MODELPREFIX-$BASEMODELSRC-$BASEMODELTGT-$BASEMODELTAGS
do_train

#ending alert 
echo -en "\007"
