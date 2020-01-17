#! /bin/bash

#INITIALIZATIONS (Do not edit)
FS="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
CORPORADIR="$FS/../corpora"

#PROCEDURES
function clean_and_split() {
	python $FS/data_prep.py $C $CORPORADIR/$CORPUS/$C.$SUFFIX.$SRC $CORPORADIR/$CORPUS/$C.$SUFFIX.$TGT $EXCLUDESET tgt
}

#CALLS
CORPUS="OPUS"
C="Tatoeba.amti-en"
SRC="amti"
TGT="en"
SUFFIX="norm.fixel"
EXCLUDESET="$CORPORADIR/test-corpus/test.en"
clean_and_split

CORPUS="OPUS"
C="Tatoeba.en-ti"
SRC="ti"
TGT="en"
SUFFIX="norm.fixel"
EXCLUDESET="$CORPORADIR/test-corpus/test.en"
clean_and_split

#ending alert 
echo -en "\007"
