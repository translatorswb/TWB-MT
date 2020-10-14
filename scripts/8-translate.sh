#! /bin/bash
#INITIALIZATIONS (Do not edit)
FS="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
CORPORADIR="$FS/../corpora"
DATADIR="$FS/../onmt/data"
MODELDIR="$FS/../onmt/models"
TESTDIR="$FS/../onmt/test"

#PROCEDURES
function do_test() {
	mkdir -p $TESTDIR

	MODELNAME=$MODELPREFIX-$MODELSRC-$MODELTGT-$MODELTYPE-$MODELID
	TOTEST=$CORPUSTEST.$BPEID.$SRC
	echo "Translating..."
	echo $TOTEST
	OUTINF=$(basename $TOTEST).inf-$MODELPREFIX-$MODELTYPE-$MODELID.$TGT
	OUTINFUNBPE=$(basename $TOTEST).inf-$MODELPREFIX-$MODELTYPE-$MODELID.unBPE.$TGT
	echo "to..."
	echo $OUTINFUNBPE
	onmt_translate -model $MODELDIR/$MODELNAME/${MODELNAME}_best.pt -src $TOTEST -output $TESTDIR/$OUTINF -replace_unk -gpu 1
	cat $TESTDIR/$OUTINF | sed -r 's/(@@ )|(@@ ?$)//g' > $TESTDIR/$OUTINFUNBPE
}

#CALLS
MODELPREFIX="monomix"
BPEID="BPE-monomix-6000"
MODELSRC="fr"
MODELTGT="sw"
MODELTYPE="intwb"
MODELID="s001-i001-t001"
CORPUSTEST="$CORPORADIR/test.swc/test.norm.fixel.tok.low"
SRC="fra"
TGT="swc"
do_test

MODELSRC="sw"
MODELTGT="fr"
SRC="swc"
TGT="fra"
do_test

#alert 
echo -en "\007"
