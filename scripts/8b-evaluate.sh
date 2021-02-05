#! /bin/bash
#INITIALIZATIONS (Do not edit)
FS="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
CORPORADIR="$FS/../corpora"
DATADIR="$FS/../onmt/data"
BPEDIR="$FS/../onmt/bpe"
MODELDIR="$FS/../onmt/models"
TESTDIR="$FS/../onmt/test"
EVALDIR="$FS/../onmt/eval"

#PROCEDURES
function do_evaluate() {
	mkdir -p $EVALDIR

	MODELNAME=$TRAINID-$SRC-$TGT-$TRAINTAGS
	MODELPATH=`ls $MODELDIR/$MODELNAME/${MODELNAME}_best_*`
	BPE=$BPEDIR/$BPEID.codes
	INFERENCEOUT=$C.$SRC.inf-$MODELNAME.$TGT
	EVALOUT=$INFERENCEOUT.results.txt

	#bash $FS/translator.sh $CORPORADIR/$CORPUS/$C.$SRC $CORPORADIR/$CORPUS/$INFERENCEOUT $MODELPATH $BPE
	
	cat $CORPORADIR/$CORPUS/$INFERENCEOUT | sacrebleu $CORPORADIR/$CORPUS/$C.$TGT -tok none --metrics {bleu,chrf} | tee $EVALDIR/$INFERENCEOUT.results.tok-none.txt
	cat $CORPORADIR/$CORPUS/$INFERENCEOUT | sacrebleu $CORPORADIR/$CORPUS/$C.$TGT -tok intl --metrics {bleu,chrf} | tee $EVALDIR/$INFERENCEOUT.results.tok-intl.txt
}

#PARAMETERS
TRAINID=$1
TRAINTAGS=$2
CORPUS=$3
C=$4
SRC=$5
TGT=$6

do_evaluate

# #CALLS
# BPEID="BPE-fixmix-6000"
# SRC="swc"
# TGT="fra"
# CORPUS="toy"
# C="toy"
# MODELNAME="A-fra-swc-generic-s001"
# do_eval
