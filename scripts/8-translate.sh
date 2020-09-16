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
MODELSRC="fr"
MODELTGT="sw"
MODELTYPE="inswc"
MODELID="s001-i001"
BPEID="BPE-mtedmix-5000"
CORPUSTEST="$CORPORADIR/mix.swc/swcmix.test.norm.fixel.masprep.tok.low"
SRC="fra"
TGT="swc"
do_test


#alert 
echo -en "\007"
