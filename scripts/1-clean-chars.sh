#! /bin/bash

#INITIALIZATIONS (Do not edit)
FS="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
CORPORADIR="$FS/../corpora"

#PROCEDURE
function clean_text() {
	for LANG in $LANGS; do
		python2 $FS/normalize-chars.py -l $LANG < $CORPORADIR/$CORPUS/$C.$LANG > $CORPORADIR/$CORPUS/$C.norm.$LANG
		python2 $FS/fix-ellipsis.py  < $CORPORADIR/$CORPUS/$C.norm.$LANG > $CORPORADIR/$CORPUS/$C.norm.fixel.$LANG
	done
}

#CALLS
CORPUS="tigmix"
C="tigmix"
LANGS="en ti"
clean_text

CORPUS="twbtm"
C="twb.train"
LANGS="en ti"
clean_text
C="twb.dev"
LANGS="en ti"
clean_text
C="twb.test"
LANGS="en ti"
clean_text

CORPUS="jw300-test"
C="test"
LANGS="en ti"
clean_text

#ending alert 
echo -en "\007"
