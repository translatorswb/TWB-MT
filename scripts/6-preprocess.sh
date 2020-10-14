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
BPEIDSUFFIX="BPE-monomix-6000"

#twbmix fra-swc
CORPUSTRAIN="$CORPORADIR/mix.twb/twbmix.train.norm.fixel.masprep.tok.low"
CORPUSDEV="$CORPORADIR/mix.twb/twbmix.dev.norm.fixel.masprep.tok.low"
SRCTRAIN="fra"
TGTTRAIN="swc"
SRCDEV="fra"
TGTDEV="swc"
DATASET="twbmix"
preprocess

#twbmix swc-fra
CORPUSTRAIN="$CORPORADIR/mix.twb/twbmix.train.norm.fixel.masprep.tok.low"
CORPUSDEV="$CORPORADIR/mix.twb/twbmix.dev.norm.fixel.masprep.tok.low"
SRCTRAIN="swc"
TGTTRAIN="fra"
SRCDEV="swc"
TGTDEV="fra"
DATASET="twbmix"
preprocess

#swcmix fr-sw
CORPUSTRAIN="$CORPORADIR/mix.swc/swcmix.train.norm.fixel.masprep.tok.low"
CORPUSDEV="$CORPORADIR/mix.swc/swcmix.dev.norm.fixel.masprep.tok.low"
SRCTRAIN="fra"
TGTTRAIN="swc"
SRCDEV="fra"
TGTDEV="swc"
DATASET="swcmix"
preprocess

#swcmix sw-fr
CORPUSTRAIN="$CORPORADIR/mix.swc/swcmix.train.norm.fixel.masprep.tok.low"
CORPUSDEV="$CORPORADIR/mix.swc/swcmix.dev.norm.fixel.masprep.tok.low"
SRCTRAIN="swc"
TGTTRAIN="fra"
SRCDEV="swc"
TGTDEV="fra"
DATASET="swcmix"
preprocess

#mtedmix fr-sw
CORPUSTRAIN="$CORPORADIR/mix.mted/mtedmix.train.norm.fixel.masprep.tok.low"
CORPUSDEV="$CORPORADIR/mix.swc/swcmix.dev.norm.fixel.masprep.tok.low"
SRCTRAIN="fr"
TGTTRAIN="sw"
SRCDEV="fra"
TGTDEV="swc"
DATASET="mtedmix"
preprocess

#mtedmix sw-fr
CORPUSTRAIN="$CORPORADIR/mix.mted/mtedmix.train.norm.fixel.masprep.tok.low"
CORPUSDEV="$CORPORADIR/mix.swc/swcmix.dev.norm.fixel.masprep.tok.low"
SRCTRAIN="sw"
TGTTRAIN="fr"
SRCDEV="swc"
TGTDEV="fra"
DATASET="mtedmix"
preprocess

#monomix fr-sw
CORPUSTRAIN="$CORPORADIR/mix.mono/monomix.train.norm.fixel.masprep.tok.low"
CORPUSDEV="$CORPORADIR/mix.swc/swcmix.dev.norm.fixel.masprep.tok.low"
SRCTRAIN="fr"
TGTTRAIN="sw"
SRCDEV="fra"
TGTDEV="swc"
DATASET="monomix"
preprocess

#monomix sw-fr
CORPUSTRAIN="$CORPORADIR/mix.mono/monomix.train.norm.fixel.masprep.tok.low"
CORPUSDEV="$CORPORADIR/mix.swc/swcmix.dev.norm.fixel.masprep.tok.low"
SRCTRAIN="sw"
TGTTRAIN="fr"
SRCDEV="swc"
TGTDEV="fra"
DATASET="monomix"
preprocess

#ending alert 
echo -en "\007"

