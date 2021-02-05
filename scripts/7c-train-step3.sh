#! /bin/bash
#INITIALIZATIONS (Do not edit)
FS="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
CORPORADIR="$FS/../corpora"
DATADIR="$FS/../onmt/data"
MODELDIR="$FS/../onmt/models"
LOGDIR="$FS/../onmt/logs"
SEED="42"

#PROCEDURES
function do_train() {
    # BASEMODELNAME=$MODELPREFIX-$BASEMODELSRC-$BASEMODELTGT-$BASEMODELTYPE-$BASEMODELID
    BASEMODELID=`echo $BASEMODELTAGS | cut -d'-' -f2-`
    MODELNAME=$MODELPREFIX-$MODELSRC-$MODELTGT-$MODELTYPE-$BASEMODELID-$MODELID

    echo Training $MODELNAME on $BASEMODELNAME
    echo Using dataset: $DATASET.$BPEID

    BASEMODELPATH=`ls $MODELDIR/$BASEMODELNAME/${BASEMODELNAME}_best_*`
    if test -f "$BASEMODELPATH"; then
        echo "Basemodel: $BASEMODELPATH"
    else 
        echo "Basemodel NOT FOUND! $BASEMODELPATH"
        exit 0
    fi

    mkdir -p $MODELDIR/$MODELNAME
    mkdir -p $LOGDIR

    onmt_train -data $DATADIR/$DATASET.$BPEID -train_from $BASEMODELPATH \
            -save_model $MODELDIR/$MODELNAME/$MODELNAME \
            -layers 6 -rnn_size 512 -word_vec_size 512 -transformer_ff 2048 -heads 8  \
            -encoder_type transformer -decoder_type transformer -position_encoding \
        -max_generator_batches 2 -dropout 0.3 -seed $SEED \
        -batch_size $BATCHSIZE  -batch_type tokens -normalization tokens  -accum_count 2 \
        -optim adam -adam_beta2 0.998 -decay_method noam -warmup_steps 4000 -learning_rate 2 \
        -max_grad_norm 0 -param_init 0  -param_init_glorot -label_smoothing 0.1 \
        -train_steps 1000000 -early_stopping 5 -early_stopping_criteria ppl \
        -valid_steps $VALIDSAVE -save_checkpoint_steps $VALIDSAVE -report_every $REPORT \
        -world_size 2 -gpu_ranks 0 1 > $LOGDIR/train-$MODELNAME.log 2>&1
    
    #Mark best model
    BESTSTEP=`cat $LOGDIR/train-$MODELNAME.log | grep "Best model found at step" | rev | cut -d' ' -f1 | rev`
    BESTMODEL=$MODELDIR/$MODELNAME/${MODELNAME}_step_${BESTSTEP}.pt
    echo Best model: $BESTMODEL
    mv $BESTMODEL $MODELDIR/$MODELNAME/${MODELNAME}_best_step_${BESTSTEP}.pt
    rm $MODELDIR/$MODELNAME/${MODELNAME}_step_* #Comment out if you want to keep non-best models

    #For debug
    # touch $MODELDIR/$MODELNAME/${MODELNAME}_best.pt
}

#PARAMETERS
MODELPREFIX=$1
MODELTYPE=$2   #"intwb" #TODO
MODELID=$3  #"t001"
BPEID=$4
DATASETID=$5
LANGA=$6
LANGB=$7
BATCHSIZE=$8
VALIDSAVE=$9
BASEMODELTAGS=${10}
BASEMODELLANGA=${11}
BASEMODELLANGB=${12}

#CALLS
MODELSRC=$LANGA
MODELTGT=$LANGB
BASEMODELSRC=$BASEMODELLANGA
BASEMODELTGT=$BASEMODELLANGB

DATASET="$DATASETID.$MODELSRC-$MODELTGT"
BASEMODELNAME=$MODELPREFIX-$BASEMODELSRC-$BASEMODELTGT-$BASEMODELTAGS
REPORT=10
do_train

MODELSRC=$LANGB
MODELTGT=$LANGA
BASEMODELSRC=$BASEMODELLANGB
BASEMODELTGT=$BASEMODELLANGA

DATASET="$DATASETID.$MODELSRC-$MODELTGT"
BASEMODELNAME=$MODELPREFIX-$BASEMODELSRC-$BASEMODELTGT-$BASEMODELTAGS
do_train

#ending alert 
echo -en "\007"
