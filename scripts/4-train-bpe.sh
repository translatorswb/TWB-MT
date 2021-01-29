#! /bin/bash

#INITIALIZATIONS (Do not edit)
FS="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
CORPORADIR="$FS/../corpora"
BPEDIR="$FS/../onmt/bpe"

#PROCEDURES
function train_bpe() {
	mkdir -p $BPEDIR
	INDIR=$CORPORADIR/$CORPUS
	echo Training BPE on $INDIR/$C.$SRC
	
	subword-nmt learn-joint-bpe-and-vocab --input $INDIR/$C.$SRC $INDIR/$C.$TGT -s $OPS \
		-o $BPEDIR/$BPEID-$OPS.codes --write-vocabulary $BPEDIR/$BPEID-$OPS.$SRC.vocab $BPEDIR/$BPEID-$OPS.$TGT.vocab
	
	#bpe on src only
	#subword-nmt learn-joint-bpe-and-vocab --input $INDIR/$C.$SRC -s $OPS \
#		        -o $BPEDIR/$BPEID-$OPS.codes --write-vocabulary $BPEDIR/$BPEID-$OPS.$SRC.vocab
}

#CALLS
CORPUS="mix.mted"
C="mtedmix.train.norm.fixel.masprep.tok.low"
SRC="sw"
TGT="fr"
BPEID="BPE-fullmix"
OPS=6000
train_bpe

#Ending alert
echo -en "\007"
