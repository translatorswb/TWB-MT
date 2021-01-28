#! /bin/bash

#INITIALIZATIONS (Do not edit)
FS="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
CORPORADIR="$FS/../corpora"

#PROCEDURES
function clean_and_split() {
	python $FS/data_prep.py $C $CORPORADIR/$CORPUS/$C.$SUFFIX.$SRC $CORPORADIR/$CORPUS/$C.$SUFFIX.$TGT $DEVSIZE $EXCLUDEFROM $EXCLUDESETS
}

#CALLS
CORPUS="mix.twb"
C="twbmix"
SRC="swc"
TGT="fra"
SUFFIX="norm.fixel"
DEVSIZE=500
EXCLUDESETS="$CORPORADIR/test.swc.old/test-old.norm.fixel.swc $CORPORADIR/test.tico19/test-tico19.norm.fixel.swc"
EXCLUDEFROM="src"
clean_and_split

CORPUS="mix.swc"
C="swcmix"
SRC="swc"
TGT="fra"
SUFFIX="norm.fixel"
DEVSIZE=1000
EXCLUDESETS="$CORPORADIR/test.swc.old/test-old.norm.fixel.swc $CORPORADIR/test.tico19/test-tico19.norm.fixel.swc $CORPORADIR/mix.twb/twbmix.dev.norm.fixel.masprep.swc $CORPORADIR/test.jw300/test-jw300.swc"
EXCLUDEFROM="src"
clean_and_split

CORPUS="mix.sw"
C="swmix"
SRC="sw"
TGT="fr"
SUFFIX="norm.fixel"
DEVSIZE=0
EXCLUDESETS="$CORPORADIR/test.swc.old/test-old.norm.fixel.swc $CORPORADIR/test.tico19/test-tico19.norm.fixel.swc $CORPORADIR/mix.twb/twbmix.dev.norm.fixel.masprep.swc $CORPORADIR/test.jw300/test-jw300.swc $CORPORADIR/mix.swc/swcmix.dev.norm.fixel.masprep.swc"
EXCLUDEFROM="src"
clean_and_split
rm $CORPORADIR/$CORPUS/$C.dev.*

CORPUS="mix.mted"
C="mtedmix"
SRC="sw"
TGT="fr"
SUFFIX="norm.fixel"
DEVSIZE=0
EXCLUDESETS="$CORPORADIR/test.swc.old/test-old.norm.fixel.swc $CORPORADIR/test.tico19/test-tico19.norm.fixel.swc $CORPORADIR/mix.twb/twbmix.dev.norm.fixel.masprep.swc $CORPORADIR/test.jw300/test-jw300.swc $CORPORADIR/mix.swc/swcmix.dev.norm.fixel.masprep.swc"
EXCLUDEFROM="src"
clean_and_split
rm $CORPORADIR/$CORPUS/$C.dev.*

CORPUS="mix.mono"
C="monomix"
SRC="sw"
TGT="fr"
SUFFIX="norm.fixel"
DEVSIZE=0
EXCLUDESETS="$CORPORADIR/test.swc.old/test-old.norm.fixel.swc $CORPORADIR/test.tico19/test-tico19.norm.fixel.swc $CORPORADIR/mix.twb/twbmix.dev.norm.fixel.masprep.swc $CORPORADIR/test.jw300/test-jw300.swc $CORPORADIR/mix.swc/swcmix.dev.norm.fixel.masprep.swc"
EXCLUDEFROM="src"
clean_and_split
rm $CORPORADIR/$CORPUS/$C.dev.*

CORPUS="toy"
C="toy"
SRC="swc"
TGT="fra"
SUFFIX="norm.fixel"
DEVSIZE=10
EXCLUDESETS="$CORPORADIR/test.swc.old/test-old.norm.fixel.swc"
EXCLUDEFROM="src"
clean_and_split
rm $CORPORADIR/$CORPUS/$C.dev.*


#ending alert 
echo -en "\007"
