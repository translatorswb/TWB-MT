#! /bin/bash

#INITIALIZATIONS (Do not edit)
FS="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
CORPORADIR="$FS/../corpora"

#PROCEDURES
function download_corpus() {
	mkdir -p $CORPORADIR/$CORPUS
	cd $CORPORADIR/$CORPUS

	wget $LINK
	unzip *.zip
	rm *.zip LICENSE README *.xml
}

#DOWNLOAD CALLS
CORPUS="OPUS" 
LINK="https://object.pouta.csc.fi/OPUS-Tatoeba/v20190709/moses/en-ti.txt.zip"
download_corpus

LINK="https://object.pouta.csc.fi/OPUS-Tatoeba/v20190709/moses/am-en.txt.zip"
download_corpus

#Merge multilingual data
cat $CORPORADIR/$CORPUS/Tatoeba.am-en.am $CORPORADIR/$CORPUS/Tatoeba.en-ti.ti > $CORPORADIR/$CORPUS/Tatoeba.amti-en.amti
cat $CORPORADIR/$CORPUS/Tatoeba.am-en.en $CORPORADIR/$CORPUS/Tatoeba.en-ti.en > $CORPORADIR/$CORPUS/Tatoeba.amti-en.en

#Make toy text corpus
CORPUS="test-corpus"
mkdir -p $CORPORADIR/$CORPUS
head -n10 $CORPORADIR/OPUS/Tatoeba.en-ti.ti > $CORPORADIR/$CORPUS/test.ti
head -n10 $CORPORADIR/OPUS/Tatoeba.en-ti.en > $CORPORADIR/$CORPUS/test.en

