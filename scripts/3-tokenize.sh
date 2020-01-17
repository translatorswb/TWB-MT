#! /bin/bash
MOSESDIR="$HOME/extSW/mosesdecoder" #Directory where moses is installed (for English tokenization)
SRCTOKENIZER="$HOME/extSW/mt-tools/languages/tigrinya/tigrinya-tokenizer.py" #Tokenizer for source language (https://github.com/translatorswb/mt-tools)

#INITIALIZATIONS (Do not edit)
FS="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
CORPORADIR="$FS/../corpora"

#PROCEDURES
function tokenize_sets() {
	INDIR=$CORPORADIR/$CORPUS
	for SET in $SETS; do
		perl $MOSESDIR/scripts/tokenizer/tokenizer.perl -q < $INDIR/$C.$SET.$SUFFIX.$TGT > $INDIR/$C.$SET.$SUFFIX.tok.$TGT
		perl $MOSESDIR/scripts/tokenizer/lowercase.perl -q < $INDIR/$C.$SET.$SUFFIX.tok.$TGT > $INDIR/$C.$SET.$SUFFIX.tok.low.$TGT

		python $SRCTOKENIZER $INDIR/$C.$SET.$SUFFIX.$SRC $INDIR/$C.$SET.$SUFFIX.tok.$SRC
		cp $INDIR/$C.$SET.$SUFFIX.tok.$SRC $INDIR/$C.$SET.$SUFFIX.tok.low.$SRC   #(if src language is uncased)
	done
}

function tokenize() {
	INDIR=$CORPORADIR/$CORPUS
	perl $MOSESDIR/scripts/tokenizer/tokenizer.perl -q < $INDIR/$C.$SUFFIX.$TGT > $INDIR/$C.$SUFFIX.tok.$TGT
	perl $MOSESDIR/scripts/tokenizer/lowercase.perl -q < $INDIR/$C.$SUFFIX.tok.$TGT > $INDIR/$C.$SUFFIX.tok.low.$TGT

	python $SRCTOKENIZER $INDIR/$C.$SUFFIX.$SRC $INDIR/$C.$SUFFIX.tok.$SRC
	cp $INDIR/$C.$SUFFIX.tok.$SRC $INDIR/$C.$SUFFIX.tok.low.$SRC #(if src language is uncased)
}

#CALLS
CORPUS="OPUS"
C="Tatoeba.amti-en"
SETS="train dev"
SUFFIX="norm.fixel.masprep"
SRC="amti"
TGT="en"
tokenize_sets

CORPUS="OPUS"
C="Tatoeba.en-ti"
SETS="train dev"
SUFFIX="norm.fixel.masprep"
SRC="ti"
TGT="en"
tokenize_sets

CORPUS="OPUS"
C="Tatoeba.am-en"
SUFFIX="norm.fixel"
SRC="am"
TGT="en"
tokenize

CORPUS="test-corpus"
C="test"
SUFFIX="norm.fixel"
SRC="ti"
TGT="en"
tokenize

#ending alert
echo -en "\007"
