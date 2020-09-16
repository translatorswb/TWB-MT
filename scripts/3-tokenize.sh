#! /bin/bash
MOSESDIR="$HOME/extSW/mosesdecoder" #Directory where moses is installed (for English tokenization)

#INITIALIZATIONS (Do not edit)
FS="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
CORPORADIR="$FS/../corpora"

#PROCEDURES
function tokenize_sets() {
	INDIR=$CORPORADIR/$CORPUS
	for SET in $SETS; do
		perl $MOSESDIR/scripts/tokenizer/tokenizer.perl -q < $INDIR/$C.$SET.$SUFFIX.$SRC > $INDIR/$C.$SET.$SUFFIX.tok.$SRC
		perl $MOSESDIR/scripts/tokenizer/lowercase.perl -q < $INDIR/$C.$SET.$SUFFIX.tok.$SRC > $INDIR/$C.$SET.$SUFFIX.tok.low.$SRC
		
		perl $MOSESDIR/scripts/tokenizer/tokenizer.perl -q < $INDIR/$C.$SET.$SUFFIX.$TGT > $INDIR/$C.$SET.$SUFFIX.tok.$TGT
                perl $MOSESDIR/scripts/tokenizer/lowercase.perl -q < $INDIR/$C.$SET.$SUFFIX.tok.$TGT > $INDIR/$C.$SET.$SUFFIX.tok.low.$TGT
	done
}

function tokenize() {
	INDIR=$CORPORADIR/$CORPUS
	perl $MOSESDIR/scripts/tokenizer/tokenizer.perl -q < $INDIR/$C.$SUFFIX.$SRC > $INDIR/$C.$SUFFIX.tok.$SRC
	perl $MOSESDIR/scripts/tokenizer/lowercase.perl -q < $INDIR/$C.$SUFFIX.tok.$SRC > $INDIR/$C.$SUFFIX.tok.low.$SRC
	perl $MOSESDIR/scripts/tokenizer/tokenizer.perl -q < $INDIR/$C.$SUFFIX.$TGT > $INDIR/$C.$SUFFIX.tok.$TGT
        perl $MOSESDIR/scripts/tokenizer/lowercase.perl -q < $INDIR/$C.$SUFFIX.tok.$TGT > $INDIR/$C.$SUFFIX.tok.low.$TGT
}

#CALLS
#CORPUS="mix.swc"
#C="swcmix"
#SETS="train dev test"
#SUFFIX="norm.fixel.masprep"
#SRC="swc"
#TGT="fra"
#tokenize_sets

#CORPUS="mix.swfr"
#C="swfrmix"
#SETS="train dev"
#SUFFIX="norm.fixel.masprep"
#SRC="sw"
#TGT="fr"
#tokenize_sets

#CORPUS="mix.mted"
#C="mtedmix"
#SETS="train"
#SUFFIX="norm.fixel.masprep"
#SRC="sw"
#TGT="fr"
#tokenize_sets

CORPUS="mix.mono"
C="monomix"
SETS="train"
SUFFIX="norm.fixel.masprep"
SRC="sw"
TGT="fr"
tokenize_sets

#ending alert
echo -en "\007"
