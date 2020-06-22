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

function download_opus() {
	mkdir -p $CORPORADIR/$CORPUS
	cd $CORPORADIR/$CORPUS

	opus_read -d $CORPUS -s $SRC -t $TGT -wm moses -w $CORPUS.$src $CORPUS.$tgt -q
	gunzip $CORPUS_latest_xml_$SRC-$TGT.xml.gz
}

#DOWNLOAD CALLS
CORPUS="Tatoeba" 
#LINK="https://object.pouta.csc.fi/OPUS-Tatoeba/v20190709/moses/en-ti.txt.zip"
#download_corpus
SRC="en"
TGT="ti"
download_opus


CORPUS="JW300"
SRC="en"
TGT="ti"
download_opus


