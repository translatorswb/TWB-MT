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
#CORPUS="mix.swc"
#C="swcmix"
#LANGS="swc fra"
#clean_text

#CORPUS="mix.swfr"
#C="swfrmix"
#LANGS="sw fr"
#clean_text

#CORPUS="mix.mted"
#C="mtedmix"
#LANGS="sw fr"
#clean_text

CORPUS="mix.mono"
C="monomix"
LANGS="sw fr"
clean_text

#ending alert 
echo -en "\007"
