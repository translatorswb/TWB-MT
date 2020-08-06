#! /bin/bash
#INITIALIZATIONS (Do not edit)
FS="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
CORPORADIR="$FS/../corpora"
DATADIR="$FS/../onmt/data"
MODELDIR="$FS/../onmt/models"
LOGDIR="$FS/../onmt/logs"
MODELTYPE="generic"

#PROCEDURES
function do_train() {
	MODELNAME=$MODELPREFIX-$MODELTYPE-$MODELID
	mkdir -p $MODELDIR/$MODELNAME
	mkdir -p $LOGDIR

	onmt_train -data $DATADIR/$DATASET.$BPEID -save_model $MODELDIR/$MODELNAME/$MODELNAME \
		   -layers 6 -rnn_size 512 -word_vec_size 512 -transformer_ff 2048 -heads 8  \
		   -encoder_type transformer -decoder_type transformer -position_encoding \
		   -max_generator_batches 2 -dropout 0.2 \
	       	   -batch_size 2048 -batch_type tokens -normalization tokens -accum_count 2 \
	   	   -optim adam -adam_beta2 0.998 -decay_method noam -warmup_steps 8000 -learning_rate 2 \
		   -max_grad_norm 0 -param_init 0  -param_init_glorot -label_smoothing 0.1 \
		   -train_steps 100000 -early_stopping 5 -early_stopping_criteria ppl \
		   -valid_steps 1150 -save_checkpoint_steps 1150 \
		   -world_size 2 -gpu_ranks 0 1 2>&1 | tee $LOGDIR/train-$MODELNAME.log

	#Make a symlink to best model
	BESTSTEP=`cat $LOGDIR/train-$MODELNAME.log | grep "Best model found at step" | rev | cut -d' ' -f1 | rev`
	BESTMODEL=$MODELDIR/$MODELNAME/${MODELNAME}_step_${BESTSTEP}.pt
	echo $BESTMODEL
	ln -sf $BESTMODEL $MODELDIR/$MODELNAME/${MODELNAME}_best.pt
}

#CALLS
MODELPREFIX="enti-srctgtbpe"
BPEID="BPE-enti-tigmix-5000"
MODELID="g001"
DATASET="tigmix"
do_train

#ending alert 
echo -en "\007"
