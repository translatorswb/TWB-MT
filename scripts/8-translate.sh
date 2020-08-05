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
MODELPREFIX="enti-srctgtbpe"
MODELTYPE="generic"
MODELID="m001"
BPEID="BPE-enti-tigmix-4000"
CORPUSTEST="$CORPORADIR/tigmix/tigmix.dev.norm.fixel.masprep.tok.low"
SRC="en"
TGT="ti"
do_test

#alert 
echo -en "\007"
