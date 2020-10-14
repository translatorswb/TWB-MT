#! /bin/bash
#INITIALIZATIONS (Do not edit)
FS="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
CORPORADIR="$FS/../corpora"
DATADIR="$FS/../onmt/data"
MODELDIR="$FS/../onmt/models"
LOGDIR="$FS/../onmt/logs"
MODELTYPE="inswc"

#PROCEDURES
function do_train() {
	BASEMODELNAME=$MODELPREFIX-$MODELSRC-$MODELTGT-$BASEMODELTYPE-$BASEMODELID
	MODELNAME=$MODELPREFIX-$MODELSRC-$MODELTGT-$MODELTYPE-$BASEMODELID-$MODELID
	mkdir -p $MODELDIR/$MODELNAME
	mkdir -p $LOGDIR

	onmt_train -data $DATADIR/$DATASET.$BPEID -train_from $MODELDIR/$BASEMODELNAME/${BASEMODELNAME}_best.pt \
	       	-save_model $MODELDIR/$MODELNAME/$MODELNAME \
          	-layers 6 -rnn_size 512 -word_vec_size 512 -transformer_ff 2048 -heads 8  \
     	  	-encoder_type transformer -decoder_type transformer -position_encoding \
	  	-max_generator_batches 2 -dropout 0.2 \
	  	-batch_size $BATCHSIZE -batch_type tokens -normalization tokens  -accum_count 2 \
	  	-optim adam -adam_beta2 0.998 -decay_method noam -warmup_steps 4000 -learning_rate 2 \
	  	-max_grad_norm 0 -param_init 0  -param_init_glorot -label_smoothing 0.1 \
	  	-train_steps 1000000 -early_stopping 5 -early_stopping_criteria ppl \
	  	-valid_steps $VALIDSAVE -save_checkpoint_steps $VALIDSAVE -report_every $REPORT \
	  	-world_size 2 -gpu_ranks 0 1 2>&1 | tee $LOGDIR/train-$MODELNAME.log
	
	#Make a symlink to best model
	BESTSTEP=`cat $LOGDIR/train-$MODELNAME.log | grep "Best model found at step" | rev | cut -d' ' -f1 | rev`
	BESTMODEL=$MODELDIR/$MODELNAME/${MODELNAME}_step_${BESTSTEP}.pt
	echo $BESTMODEL
	ln -sf $BESTMODEL $MODELDIR/$MODELNAME/${MODELNAME}_best.pt
}

#CALLS
MODELPREFIX="monomix"
BPEID="BPE-monomix-6000"
MODELSRC="fr"
MODELTGT="sw"
BASEMODELTYPE="generic"
BASEMODELID="s001"
MODELID="i001"
DATASET="swcmix.fra-swc"
BATCHSIZE=2048
VALIDSAVE=1500
REPORT=50
do_train

MODELSRC="sw"
MODELTGT="fr"
BASEMODELTYPE="generic"
BASEMODELID="s001"
MODELID="i001"
DATASET="swcmix.swc-fra"
do_train

#ending alert 
echo -en "\007"
