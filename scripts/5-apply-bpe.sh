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

#BPE mtedmix
BPEID="BPE-mymtedmix-6000"
BPESRC="sw"
BPETGT="fr"

CORPUS="mix.twb"
C="twbmix"
SUFFIX="norm.fixel.masprep.tok.low"
SETS="train dev"
SRC="swc"
TGT="fra"
#apply_bpe_to_sets

# CORPUS="test.swc"
# C="test"
# SUFFIX="norm.fixel.tok.low"
# SRC="swc"
# TGT="fra"
# apply_bpe

CORPUS="mix.swc"
C="swcmix"
SUFFIX="norm.fixel.masprep.tok.low"
SETS="train dev"
SRC="swc"
TGT="fra"
#apply_bpe_to_sets

CORPUS="mix.sw"
C="swmix"
SUFFIX="norm.fixel.masprep.tok.low"
SETS="train"
SRC="sw"
TGT="fr"
#apply_bpe_to_sets

CORPUS="mix.mted"
C="mtedmix"
SUFFIX="norm.fixel.masprep.tok.low"
SETS="train"
SRC="sw"
TGT="fr"
#apply_bpe_to_sets

CORPUS="mix.mono"
C="monomix"
SUFFIX="norm.fixel.masprep.tok.low"
SETS="train"
SRC="sw"
TGT="fr"
#apply_bpe_to_sets

CORPUS="toy"
C="toy"
SUFFIX="norm.fixel.masprep.tok.low"
SETS="train dev"
SRC="swc"
TGT="fra"
apply_bpe_to_sets

#ending alert 
echo -en "\007"
