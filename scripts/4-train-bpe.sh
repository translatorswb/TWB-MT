#! /bin/bash

#INITIALIZATIONS (Do not edit)
FS="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
CORPORADIR="$FS/../corpora"
BPEDIR="$FS/../onmt/bpe"

#PROCEDURES
function train_bpe() {
	mkdir -p $BPEDIR
	INDIR=$CORPORADIR/$CORPUS
	
	#subword-nmt learn-joint-bpe-and-vocab --input $INDIR/$C.$SRC $INDIR/$C.$TGT -s $OPS \
#		-o $BPEDIR/$BPEID-$OPS.codes --write-vocabulary $BPEDIR/$BPEID-$OPS.$SRC.vocab $BPEDIR/$BPEID-$OPS.$TGT.vocab
	
	#bpe on src only
	subword-nmt learn-joint-bpe-and-vocab --input $INDIR/$C.$SRC -s $OPS \
		        -o $BPEDIR/$BPEID-$OPS.codes --write-vocabulary $BPEDIR/$BPEID-$OPS.$SRC.vocab
}

#CALLS
CORPUS="tigmix"
C="tigmix.train.norm.fixel.masprep.tok.low"
SRC="en"
TGT="ti"
BPEID="BPE-tigmix"
OPS=4000
train_bpe

#Ending alert
echo -en "\007"
