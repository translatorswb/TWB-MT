#! /bin/bash

#INITIALIZATIONS (Do not edit)
FS="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
CORPORADIR="$FS/../corpora"

#PROCEDURE
function clean_text() {
	echo Cleaning $CORPORADIR/$CORPUS
	for LANG in $LANGS; do
		python2 $FS/normalize-chars.py -l $LANG < $CORPORADIR/$CORPUS/$C.$LANG > $CORPORADIR/$CORPUS/$C.norm.$LANG
		python2 $FS/fix-ellipsis.py  < $CORPORADIR/$CORPUS/$C.norm.$LANG > $CORPORADIR/$CORPUS/$C.norm.fixel.$LANG
	done
}

#CALLS
CORPUS="mix.twb"
C="twbmix"
LANGS="swc fra"
clean_text

CORPUS="mix.swc"
C="swcmix"
LANGS="swc fra"
clean_text

CORPUS="mix.sw"
C="swmix"
LANGS="sw fr"
clean_text

CORPUS="mix.mted"
C="mtedmix"
LANGS="sw fr"
clean_text

CORPUS="mix.mono"
C="monomix"
LANGS="sw fr"
clean_text

#old test set
CORPUS="test.swc.old"
C="test-old"
LANGS="swc fra"
clean_text

#tico19 test set
CORPUS="test.tico19"
C="test-tico19"
LANGS="swc fra"
clean_text

#Masakhane's JW300 test set
CORPUS="test.jw300"
C="test-jw300"
LANGS="swc fra"
clean_text

#Gamayun test kit
CORPUS="test.twbkit"
C="test-twbkit"
LANGS="swc fra"
clean_text

#ending alert 
echo -en "\007"
