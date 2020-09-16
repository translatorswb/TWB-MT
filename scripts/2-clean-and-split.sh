#! /bin/bash

#INITIALIZATIONS (Do not edit)
FS="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
CORPORADIR="$FS/../corpora"

#PROCEDURES
function clean_and_split() {
	python $FS/data_prep.py $C $CORPORADIR/$CORPUS/$C.$SUFFIX.$SRC $CORPORADIR/$CORPUS/$C.$SUFFIX.$TGT $DEVSIZE $EXCLUDESET $EXCLUDEFROM
}

#CALLS
#CORPUS="mix.swc"
#C="swcmix"
#SRC="swc"
#TGT="fra"
#SUFFIX="norm.fixel"
#DEVSIZE=500
#EXCLUDESET="$CORPORADIR/$CORPUS/$C.test.$SUFFIX.masprep.$SRC"
#EXCLUDEFROM="src"
#clean_and_split

#CORPUS="mix.swfr"
#C="swfrmix"
#SRC="sw"
#TGT="fr"
#SUFFIX="norm.fixel"
#DEVSIZE=1000
#EXCLUDESET="$CORPORADIR/mix.swc/swcmix.test.norm.fixel.masprep.swc"
#EXCLUDEFROM="src"
#clean_and_split

#CORPUS="mix.mted"
#C="mtedmix"
#SRC="sw"
#TGT="fr"
#SUFFIX="norm.fixel"
#DEVSIZE=0
#EXCLUDESET="$CORPORADIR/mix.swc/swcmix.test.norm.fixel.masprep.swc"
#EXCLUDEFROM="src"
#clean_and_split

CORPUS="mix.mono"
C="monomix"
SRC="sw"
TGT="fr"
SUFFIX="norm.fixel"
DEVSIZE=0
EXCLUDESET="$CORPORADIR/mix.swc/swcmix.test.norm.fixel.masprep.swc"
EXCLUDEFROM="src"
clean_and_split

#ending alert 
echo -en "\007"
