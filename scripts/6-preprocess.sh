#! /bin/bash
#INITIALIZATIONS (Do not edit)
FS="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
CORPORADIR="$FS/../corpora"
DATADIR="$FS/../onmt/data"

BPEIDSUFFIX="BPE-Tatoeba-100"

#PROCEDURES
function preprocess() {
	mkdir -p $DATADIR
	onmt_preprocess -overwrite -train_src $CORPUSTRAIN.$BPEIDSUFFIX.$SRCTRAIN -train_tgt $CORPUSTRAIN.$BPEIDSUFFIX.$TGTTRAIN -valid_src $CORPUSDEV.$BPEIDSUFFIX.$SRCDEV -valid_tgt $CORPUSDEV.$BPEIDSUFFIX.$TGTDEV -save_data $DATADIR/$DATASET.$BPEIDSUFFIX
}

#CALLS
#Multilingual dataset
CORPUSTRAIN="$CORPORADIR/OPUS/Tatoeba.amti-en.train.norm.fixel.masprep.tok.low"
CORPUSDEV="$CORPORADIR/OPUS/Tatoeba.en-ti.dev.norm.fixel.masprep.tok.low"
SRCTRAIN="amti"
TGTTRAIN="en"
SRCDEV="ti"
TGTDEV="en"
DATASET="Tatoeba-multi"
preprocess

#Unilingual dataset
CORPUSTRAIN="$CORPORADIR/OPUS/Tatoeba.en-ti.train.norm.fixel.masprep.tok.low"
CORPUSDEV="$CORPORADIR/OPUS/Tatoeba.en-ti.dev.norm.fixel.masprep.tok.low"
SRCTRAIN="ti"
TGTTRAIN="en"
SRCDEV="ti"
TGTDEV="en"
DATASET="Tatoeba-uni"
preprocess

#In-domain dataset

#ending alert 
echo -en "\007"

