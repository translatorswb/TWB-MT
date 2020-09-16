#! /bin/bash

#INITIALIZATIONS (Do not edit)
FS="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
CORPORADIR="$FS/../corpora"

#PROCEDURES
function mix_sets() {
	mkdir -p $CORPORADIR/$CORPUS
	> $CORPORADIR/$CORPUS/$C.$SRC; > $CORPORADIR/$CORPUS/$C.$TGT
	echo "source"
	for SET in $SRCSETS; do
		echo $SET
		cat $CORPORADIR/$SET >> $CORPORADIR/$CORPUS/$C.$SRC
		wc -l $CORPORADIR/$CORPUS/$C.$SRC
	done

	for SET in $TGTSETS; do
		echo $SET
		cat $CORPORADIR/$SET >> $CORPORADIR/$CORPUS/$C.$TGT
		wc -l $CORPORADIR/$CORPUS/$C.$TGT
	done

	echo Corpus mixed $CORPUS/$C
	wc -l $CORPORADIR/$CORPUS/$C.$SRC
	wc -l $CORPORADIR/$CORPUS/$C.$TGT
}


#CALLS
#CORPUS="mix.swc"
#C="swcmix"
#SRC="swc"
#TGT="fra"
#SRCSETS="twbtm.swc/twb_swc-fr_nontico_swc.txt tico19/swc-CD.all.txt"
#TGTSETS="twbtm.swc/twb_swc-fr_nontico_fra.txt tico19/fr-FR.all.txt"
#mix_sets

#CORPUS="mix.swfr"
#C="swfrmix"
#SRC="sw"
#TGT="fr"
#SRCSETS="GlobalVoices/GlobalVoices.fr-sw.sw jw300/jw300.sw mix.swc/swcmix.train.norm.fixel.masprep.swc Tanzil/Tanzil.fr-sw.sw twbtm.sw/twb_sw-fr_sw.txt"
#TGTSETS="GlobalVoices/GlobalVoices.fr-sw.fr jw300/jw300.fr mix.swc/swcmix.train.norm.fixel.masprep.fra Tanzil/Tanzil.fr-sw.fr twbtm.sw/twb_sw-fr_fr.txt"
#mix_sets

#CORPUS="mix.mted"
#C="mtedmix"
#SRC="sw"
#TGT="fr"
#SRCSETS="mix.swfr/swfrmix.train.norm.fixel.masprep.sw mix.swc/swcmix.train.norm.fixel.masprep.swc mted.elrc/ELRC_2922.fr-sw.sw mted.gamayun/gamayun.fr-sw.sw mted.gourmet/GoURMET-crawled.fr-sw.sw"
#TGTSETS="mix.swfr/swfrmix.train.norm.fixel.masprep.fr mix.swc/swcmix.train.norm.fixel.masprep.fra mted.elrc/ELRC_2922.fr-sw.fr mted.gamayun/gamayun.fr-sw.fr mted.gourmet/GoURMET-crawled.fr-sw.fr"
#mix_sets

CORPUS="mix.mono"
C="monomix"
SRC="sw"
TGT="fr"
SRCSETS="mix.swfr/swfrmix.train.norm.fixel.masprep.sw mix.swc/swcmix.train.norm.fixel.masprep.swc monosw/monosw.sw"
TGTSETS="mix.swfr/swfrmix.train.norm.fixel.masprep.fr mix.swc/swcmix.train.norm.fixel.masprep.fra monosw/monosw.fr"
mix_sets

