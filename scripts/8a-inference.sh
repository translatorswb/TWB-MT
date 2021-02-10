#! /bin/bash
# Script for doing inference on a test corpus
# Call format: 
# bash 8a-inference.sh <experiment-prefix> <model-id> <bpe-id> <corpus-dir> <corpus-name> <corpus-lang-src> <corpus-lang-tgt>
# Example:
# bash 8a-inference.sh experiment-1 sw-fr-generic-s001 BPE-fixmix-6000 testset test swc fra

#INITIALIZATIONS (Do not edit)
FS="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
CORPORADIR="$FS/../corpora"
DATADIR="$FS/../onmt/data"
BPEDIR="$FS/../onmt/bpe"
MODELDIR="$FS/../onmt/models"

#PROCEDURES
function do_translate() {

	MODELNAME=$TRAINID-$MODELTAGS
	echo Translating $CORPUS/$C with model $MODELNAME

	MODELPATH=`ls $MODELDIR/$MODELNAME/${MODELNAME}_best_*`
	BPE=$BPEDIR/$BPEID.codes
	INFERENCEOUT=$C.$SRC.inf-$MODELNAME.$TGT
	EVALOUT=$INFERENCEOUT.results.txt

	bash $FS/translator.sh $CORPORADIR/$CORPUS/$C.$SRC $CORPORADIR/$CORPUS/$INFERENCEOUT $MODELPATH $BPE  2>/dev/null
}

#PARAMETERS
TRAINID=$1
MODELTAGS=$2
BPEID=$3
CORPUS=$4
C=$5
SRC=$6
TGT=$7

do_translate



