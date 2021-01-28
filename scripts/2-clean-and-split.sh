#! /bin/bash

#INITIALIZATIONS (Do not edit)
FS="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
CORPORADIR="$FS/../corpora"

#PROCEDURES
function clean_and_split() {
	python $FS/data_prep.py $C $CORPORADIR/$CORPUS/$C.$SUFFIX.$SRC $CORPORADIR/$CORPUS/$C.$SUFFIX.$TGT $DEVSIZE $EXCLUDESET $EXCLUDEFROM
}

#CALLS
CORPUS="mix.twb"
C="twbmix"
SRC="swc"
TGT="fra"
SUFFIX="norm.fixel"
DEVSIZE=500
EXCLUDESET="$CORPORADIR/test.swc/test.norm.fixel.swc"
EXCLUDEFROM="src"
clean_and_split

CORPUS="mix.swc"
C="swcmix"
SRC="swc"
TGT="fra"
SUFFIX="norm.fixel"
DEVSIZE=1000
EXCLUDESET="$CORPORADIR/test.swc/test.norm.fixel.swc"
EXCLUDEFROM="src"
clean_and_split

CORPUS="mix.mted"
C="mtedmix"
SRC="sw"
TGT="fr"
SUFFIX="norm.fixel"
DEVSIZE=0
EXCLUDESET="$CORPORADIR/test.swc/test.norm.fixel.swc"
EXCLUDEFROM="src"
clean_and_split
rm $CORPORADIR/$CORPUS/$C.dev.*

CORPUS="mix.mono"
C="monomix"
SRC="sw"
TGT="fr"
SUFFIX="norm.fixel"
DEVSIZE=0
EXCLUDESET="$CORPORADIR/test.swc/test.norm.fixel.swc"
EXCLUDEFROM="src"
clean_and_split
rm $CORPORADIR/$CORPUS/$C.dev.*

#ending alert 
echo -en "\007"
