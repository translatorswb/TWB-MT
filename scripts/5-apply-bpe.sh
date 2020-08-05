#! /bin/bash

#INITIALIZATIONS (Do not edit)
FS="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
CORPORADIR="$FS/../corpora"
BPEDIR="$FS/../onmt/bpe"

#PROCEDURES
function apply_bpe() {
	BPE=$BPEDIR/$BPEID.codes
	VOCABSRC=$BPEDIR/$BPEID.$BPESRC.vocab
	VOCABTGT=$BPEDIR/$BPEID.$BPETGT.vocab

	subword-nmt apply-bpe -c $BPE --vocabulary $VOCABSRC < $CORPORADIR/$CORPUS/$C.$SUFFIX.$SRC > $CORPORADIR/$CORPUS/$C.$SUFFIX.$BPEID.$SRC
	subword-nmt apply-bpe -c $BPE --vocabulary $VOCABTGT < $CORPORADIR/$CORPUS/$C.$SUFFIX.$TGT > $CORPORADIR/$CORPUS/$C.$SUFFIX.$BPEID.$TGT
}

function apply_bpe_to_sets() {
	BPE=$BPEDIR/$BPEID.codes
	VOCABSRC=$BPEDIR/$BPEID.$BPESRC.vocab
	VOCABTGT=$BPEDIR/$BPEID.$BPETGT.vocab

	for SET in $SETS; do
		subword-nmt apply-bpe -c $BPE --vocabulary $VOCABSRC < $CORPORADIR/$CORPUS/$C.$SET.$SUFFIX.$SRC > $CORPORADIR/$CORPUS/$C.$SET.$SUFFIX.$BPEID.$SRC
		subword-nmt apply-bpe -c $BPE --vocabulary $VOCABTGT < $CORPORADIR/$CORPUS/$C.$SET.$SUFFIX.$TGT > $CORPORADIR/$CORPUS/$C.$SET.$SUFFIX.$BPEID.$TGT
	done
}

#CALLS
BPEID="BPE-enti-tigmix-4000"
BPESRC="en"
BPETGT="ti"

#tigmix
CORPUS="tigmix"
C="tigmix"
SUFFIX="norm.fixel.masprep.tok.low"
SETS="train dev"
SRC="en"
TGT="ti"
apply_bpe_to_sets

#in-domain
CORPUS="twbtm"
C="twb"
SUFFIX="norm.fixel.tok.low"
SETS="train test dev"
SRC="en"
TGT="ti"
apply_bpe_to_sets

#Test
CORPUS="jw300-test"
C="test"
SUFFIX="norm.fixel.tok.low"
SRC="en"
TGT="ti"
apply_bpe

#ending alert 
echo -en "\007"
