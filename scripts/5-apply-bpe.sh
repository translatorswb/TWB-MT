#! /bin/bash

#INITIALIZATIONS (Do not edit)
FS="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
CORPORADIR="$FS/../corpora"
BPEDIR="$FS/../onmt/bpe"

#PROCEDURES
function apply_bpe() {
	subword-nmt apply-bpe -c $BPE --vocabulary $VOCABSRC < $CORPORADIR/$CORPUS/$C.$SUFFIX.$SRC > $CORPORADIR/$CORPUS/$C.$SUFFIX.$BPEID.$SRC
	subword-nmt apply-bpe -c $BPE --vocabulary $VOCABTGT < $CORPORADIR/$CORPUS/$C.$SUFFIX.$TGT > $CORPORADIR/$CORPUS/$C.$SUFFIX.$BPEID.$TGT
}

function apply_bpe_to_sets() {
	for SET in $SETS; do
		subword-nmt apply-bpe -c $BPE --vocabulary $VOCABSRC < $CORPORADIR/$CORPUS/$C.$SET.$SUFFIX.$SRC > $CORPORADIR/$CORPUS/$C.$SET.$SUFFIX.$BPEID.$SRC
		subword-nmt apply-bpe -c $BPE --vocabulary $VOCABTGT < $CORPORADIR/$CORPUS/$C.$SET.$SUFFIX.$TGT > $CORPORADIR/$CORPUS/$C.$SET.$SUFFIX.$BPEID.$TGT
	done
}

#CALLS
BPEID="BPE-Tatoeba-100"
BPESRC="amti"
BPETGT="en"
BPE=$BPEDIR/$BPEID.codes
VOCABSRC=$BPEDIR/$BPEID.$BPESRC.vocab
VOCABTGT=$BPEDIR/$BPEID.$BPETGT.vocab

#Multilingual
CORPUS="OPUS"
C="Tatoeba.amti-en"
SUFFIX="norm.fixel.masprep.tok.low"
SETS="train dev"
SRC="amti"
TGT="en"
apply_bpe_to_sets

#Single-lang (ti)
CORPUS="OPUS"
C="Tatoeba.en-ti"
SUFFIX="norm.fixel.masprep.tok.low"
SETS="train dev"
SRC="ti"
TGT="en"
apply_bpe_to_sets

#Single-lang (am)
CORPUS="OPUS"
C="Tatoeba.am-en"
SUFFIX="norm.fixel.tok.low"
SRC="am"
TGT="en"
apply_bpe

#Test
CORPUS="test-corpus"
C="test"
SUFFIX="norm.fixel.tok.low"
SRC="ti"
TGT="en"
apply_bpe

#ending alert 
echo -en "\007"
