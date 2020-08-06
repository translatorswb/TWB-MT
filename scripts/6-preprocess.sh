#! /bin/bash
#INITIALIZATIONS (Do not edit)
FS="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
CORPORADIR="$FS/../corpora"
DATADIR="$FS/../onmt/data"

#PROCEDURES
function preprocess() {
	mkdir -p $DATADIR
	
	#echo onmt_preprocess -overwrite -train_src $CORPUSTRAIN.$BPEIDSUFFIX.$SRCTRAIN -train_tgt $CORPUSTRAIN.$BPEIDSUFFIX.$TGTTRAIN -valid_src $CORPUSDEV.$BPEIDSUFFIX.$SRCDEV -valid_tgt $CORPUSDEV.$BPEIDSUFFIX.$TGTDEV -save_data $DATADIR/$DATASET.$BPEIDSUFFIX

	onmt_preprocess -overwrite -train_src $CORPUSTRAIN.$BPEIDSUFFIX.$SRCTRAIN -train_tgt $CORPUSTRAIN.$BPEIDSUFFIX.$TGTTRAIN -valid_src $CORPUSDEV.$BPEIDSUFFIX.$SRCDEV -valid_tgt $CORPUSDEV.$BPEIDSUFFIX.$TGTDEV -save_data $DATADIR/$DATASET.$BPEIDSUFFIX
}

#CALLS
BPEIDSUFFIX="BPE-enti-tigmix-5000"

#Tigmix
CORPUSTRAIN="$CORPORADIR/tigmix/tigmix.train.norm.fixel.masprep.tok.low"
CORPUSDEV="$CORPORADIR/tigmix/tigmix.dev.norm.fixel.masprep.tok.low"
SRCTRAIN="en"
TGTTRAIN="ti"
SRCDEV="en"
TGTDEV="ti"
DATASET="tigmix"
preprocess

#In-domain dataset
CORPUSTRAIN="$CORPORADIR/twbtm/twb.train.norm.fixel.tok.low"
CORPUSDEV="$CORPORADIR/twbtm/twb.dev.norm.fixel.tok.low"
SRCTRAIN="en"
TGTTRAIN="ti"
SRCDEV="en"
TGTDEV="ti"
DATASET="twbtm"
preprocess

#ending alert 
echo -en "\007"

