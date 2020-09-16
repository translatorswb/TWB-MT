#! /bin/bash
#INITIALIZATIONS (Do not edit)
FS="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
CORPORADIR="$FS/../corpora"
DATADIR="$FS/../onmt/data"

#PROCEDURES
function preprocess() {
	mkdir -p $DATADIR
	
	onmt_preprocess -overwrite -train_src $CORPUSTRAIN.$BPEIDSUFFIX.$SRCTRAIN -train_tgt $CORPUSTRAIN.$BPEIDSUFFIX.$TGTTRAIN -valid_src $CORPUSDEV.$BPEIDSUFFIX.$SRCDEV -valid_tgt $CORPUSDEV.$BPEIDSUFFIX.$TGTDEV -save_data $DATADIR/$DATASET.$SRCTRAIN-$TGTTRAIN.$BPEIDSUFFIX
}

#CALLS
BPEIDSUFFIX="BPE-mtedmix-5000"

#swcmix
CORPUSTRAIN="$CORPORADIR/mix.swc/swcmix.train.norm.fixel.masprep.tok.low"
CORPUSDEV="$CORPORADIR/mix.swc/swcmix.dev.norm.fixel.masprep.tok.low"
SRCTRAIN="fra"
TGTTRAIN="swc"
SRCDEV="fra"
TGTDEV="swc"
DATASET="swcmix"
preprocess

#swfrmix
#CORPUSTRAIN="$CORPORADIR/mix.swfr/swfrmix.train.norm.fixel.masprep.tok.low"
#CORPUSDEV="$CORPORADIR/mix.swfr/swfrmix.dev.norm.fixel.masprep.tok.low"
#SRCTRAIN="sw"
#TGTTRAIN="fr"
#SRCDEV="sw"
#TGTDEV="fr"
#DATASET="swfrmix"
#preprocess

#mtedmix
CORPUSTRAIN="$CORPORADIR/mix.mted/mtedmix.train.norm.fixel.masprep.tok.low"
CORPUSDEV="$CORPORADIR/mix.swfr/swfrmix.dev.norm.fixel.masprep.tok.low"
SRCTRAIN="fr"
TGTTRAIN="sw"
SRCDEV="fr"
TGTDEV="sw"
DATASET="mtedmix"
#preprocess

#monomix
CORPUSTRAIN="$CORPORADIR/mix.mono/monomix.train.norm.fixel.masprep.tok.low"
CORPUSDEV="$CORPORADIR/mix.swfr/swfrmix.dev.norm.fixel.masprep.tok.low"
SRCTRAIN="fr"
TGTTRAIN="sw"
SRCDEV="fr"
TGTDEV="sw"
DATASET="monomix"
preprocess

#ending alert 
echo -en "\007"

