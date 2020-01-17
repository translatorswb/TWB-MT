#! /bin/bash
#INITIALIZATIONS (Do not edit)
FS="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
CORPORADIR="$FS/../corpora"
DATADIR="$FS/../onmt/data"
MODELDIR="$FS/../onmt/models"
TESTDIR="$FS/../onmt/test"

#PROCEDURES
function do_test() {
	MODELNAME=$MODELPREFIX-$MODELTYPE-$MODELID
	TOTEST=$CORPUSTEST.$BPEID.$SRC
	echo "Translating..."
	echo $TOTEST
	OUTINF=$(basename $TOTEST).inf-$MODELTYPE-$MODELID.$TGT
	OUTINFUNBPE=$(basename $TOTEST).inf-$MODELTYPE-$MODELID.unBPE.$TGT
	echo "to..."
	echo $OUTINFUNBPE
	onmt_translate -model $MODELDIR/$MODELNAME/${MODELNAME}_best.pt -src $TOTEST -output $TESTDIR/$OUTINF -replace_unk -gpu 1
	cat $TESTDIR/$OUTINF | sed -r 's/(@@ )|(@@ ?$)//g' > $TESTDIR/$OUTINFUNBPE
}

#CALLS
MODELPREFIX="ti-en"
MODELTYPE="indomain"
MODELID="m016-u001-i001"
BPEID="BPE-Tatoeba-100"
CORPUSTEST="$CORPORADIR/test-corpus/test.norm.fixel.tok.low"
SRC="ti"
TGT="en"
do_test

#alert 
echo -en "\007"
