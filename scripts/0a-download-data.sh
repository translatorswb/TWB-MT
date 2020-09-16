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
CORPUS="GlobalVoices"
LINK="https://object.pouta.csc.fi/OPUS-GlobalVoices/v2017q3/moses/fr-sw.txt.zip"
download_corpus


CORPUS="Tanzil"
LINK="https://object.pouta.csc.fi/OPUS-Tanzil/v1/moses/fr-sw.txt.zip"
download_corpus


