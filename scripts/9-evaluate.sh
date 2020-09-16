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
	INFERENCE="$TESTDIR/$(basename $CORPUSTEST).$BPEID.$SRC.inf-$MODELPREFIX-$MODELTYPE-$MODELID.unBPE.$TGT"
	EVALOUT="$EVALDIR/$(basename $CORPUSTEST).$BPEID.$SRC.inf-$MODELPREFIX-$MODELTYPE-$MODELID.$TGT"

	echo "======================================="
	echo ">>> RESULTS FOR: $(basename $INFERENCE)" 

	$MTTOOLSDIR/eval/eval_bleu.sh $GROUNDTRUTH $INFERENCE  | tee $EVALOUT.bleu
	#python $MTTOOLSDIR/eval/eval_chrf.py $GROUNDTRUTH $INFERENCE  | tee $EVALOUT.chrf
	#$MTTOOLSDIR/eval/eval_meteor.sh $GROUNDTRUTH $INFERENCE  | tee $EVALOUT.meteor
	
	echo "======================================="
}

#CALLS
MODELPREFIX="monomix"
MODELTYPE="inswc"
MODELID="s001-i001"
BPEID="BPE-mtedmix-5000"
CORPUSTEST="$CORPORADIR/mix.swc/swcmix.test.norm.fixel.masprep.tok.low"
SRC="fra"
TGT="swc"
do_evaluate


