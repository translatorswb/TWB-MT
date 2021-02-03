#! /bin/bash
#INITIALIZATIONS (Do not edit)
FS="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
CORPORADIR="$FS/../corpora"
DATADIR="$FS/../onmt/data"
BPEDIR="$FS/../onmt/bpe"
MODELDIR="$FS/../onmt/models"

#PROCEDURES
function do_translate() {

	MODELNAME=$TRAINID-$SRC-$TGT-$TRAINTAGS
	echo Translating $CORPUS/$C with model $MODELNAME

	MODELPATH=`ls $MODELDIR/$MODELNAME/${MODELNAME}_best_*`
	BPE=$BPEDIR/$BPEID.codes
	INFERENCEOUT=$C.$SRC.inf-$MODELNAME.$TGT
	EVALOUT=$INFERENCEOUT.results.txt

	#bash $FS/translator.sh $CORPORADIR/$CORPUS/$C.$SRC $CORPORADIR/$CORPUS/$INFERENCEOUT $MODELPATH $BPE
}

#PARAMETERS
TRAINID=$1
TRAINTAGS=$2
BPEID=$3
CORPUS=$4
C=$5
SRC=$6
TGT=$7

do_translate



