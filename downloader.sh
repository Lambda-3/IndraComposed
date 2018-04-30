#!/bin/bash

set -e

BASEURL="http://data.lambda3.org/indra/dumps"

if [ ! $1 ]; then
	echo ".........................................................."
	echo "Load Indra models from $BASEURL."
	echo "Usage: downloader.sh <name_of_the_model>"
	echo "Example to load the public Word2Vec model of Google News"
	echo " downloader.sh w2v-en-googlenews300neg"
	echo ".........................................................."
	exit 0
fi

if [[ $1 != esa* ]] ; then
	MODELFILE="$1.annoy.tar.gz"
	MD5FILE="$1.annoy.tar.gz.md5"
	TARGETDIR="data/annoy"

else
	MODELFILE="$1.lucene.tar.gz"
	MD5FILE="$1.lucene.tar.gz.md5"
	TARGETDIR="data/lucene"
fi

mkdir -p $TARGETDIR
cd $TARGETDIR

MODELURL="$BASEURL/$MODELFILE"
MD5URL="$BASEURL/$MD5FILE"

if [ ! -d "./$1" ]; then
	echo "Downloading $MODELURL .."
	wget -nc $MODELURL && wget -nc $MD5URL && md5sum -c $MD5FILE 
	echo "Extracting $MODELFILE"
	tar -C . -xf $MODELFILE --totals
	rm $MODELFILE $MD5FILE
else
	echo "Model '$1' is already available."
fi

echo "Finished."
