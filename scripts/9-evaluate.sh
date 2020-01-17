#! /bin/bash
MTTOOLSDIR="$HOME/extSW/mt-tools" #Direct to where mt-tools is stored (https://github.com/translatorswb/mt-tools)

#INITIALIZATIONS (Do not edit)
FS="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
CORPORADIR="$FS/../corpora"
TESTDIR="$FS/../onmt/test"
EVALDIR="$FS/../onmt/eval"

#PROCEDURES
function do_evaluate() {
	GROUNDTRUTH="$CORPUSTEST.$TGT"
	INFERENCE="$TESTDIR/$(basename $CORPUSTEST).$BPEID.$SRC.inf-$MODELTYPE-$MODELID.unBPE.$TGT"
	EVALOUT="$EVALDIR/$(basename $CORPUSTEST).$BPEID.$SRC.inf-$MODELTYPE-$MODELID.$TGT"

	echo "======================================="
	echo ">>> RESULTS FOR: $(basename $INFERENCE)" 

	$MTTOOLSDIR/eval/eval_bleu.sh $GROUNDTRUTH $INFERENCE  | tee $EVALOUT.bleu
	python $MTTOOLSDIR/eval/eval_chrf.py $GROUNDTRUTH $INFERENCE  | tee $EVALOUT.chrf
	$MTTOOLSDIR/eval/eval_meteor.sh $GROUNDTRUTH $INFERENCE  | tee $EVALOUT.meteor
	
	echo "======================================="
}

#CALLS
MODELPREFIX="ti-en"
MODELTYPE="indomain"
MODELID="m016-u001-i001"
BPEID="BPE-Tatoeba-100"
CORPUSTEST="$CORPORADIR/test-corpus/test.norm.fixel.tok.low"
SRC="ti"
TGT="en"
do_evaluate
