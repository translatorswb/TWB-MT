#! /bin/bash

#INITIALIZATIONS (Do not edit)
FS="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
CORPORADIR="$FS/../corpora"

#PROCEDURES
function clean_and_split() {
	python $FS/data_prep.py $C $CORPORADIR/$CORPUS/$C.$SUFFIX.$SRC $CORPORADIR/$CORPUS/$C.$SUFFIX.$TGT $DEVSIZE $EXCLUDESET $EXCLUDEFROM
}

#CALLS
CORPUS="tigmix"
C="tigmix"
SRC="en"
TGT="ti"
SUFFIX="norm.fixel"
DEVSIZE=1000
EXCLUDESET="$CORPORADIR/jw300-test/test.en"
EXCLUDEFROM="src"
clean_and_split

#CORPUS="twbtm"
#C="twb.train"
#SRC="ti"
#TGT="en"
#SUFFIX="norm.fixel"
#DEVSIZE=200
#EXCLUDESET=""
#EXCLUDEFROM=""
#clean_and_split

#ending alert 
echo -en "\007"
