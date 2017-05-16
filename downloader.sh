#!/bin/bash

set -e

BASEURL="http://data.lambda3.org/indra/dumps"

if [ ! $1 ]; then
	echo ".........................................................."
	echo "Load Indra models from $BASEURL."
	echo "Usage: downloader.sh <name_of_the_model>"
	echo "Example to load the public Word2Vec model of Google News"
	echo " downloader.sh w2v-en-GoogleNews300neg"
	echo ".........................................................."
	exit 0
fi

loaded=`docker exec -it indramongo mongo $1 --quiet --eval "db.getCollectionNames().length"`
loaded=$(echo -n "${loaded//[[:space:]]/}")

if [ "$loaded" != "0" ] ; then
	echo "$1 already loaded."
	exit 0
fi



MODELFILE="$1.tar.gz"
MD5FILE="$1.tar.gz.md5"
MODELURL="$BASEURL/$MODELFILE"
MD5URL="$BASEURL/$MD5FILE"

mkdir -p dumps/data 
cd dumps

if [ ! -d "./data/$1" ]; then
	echo "Downloading $MODELURL .."
	wget -nc $MODELURL && wget -nc $MD5URL && md5sum -c $MD5FILE 
	echo "Extracting $MODELFILE"
	tar -C ./data -xf $MODELFILE --totals
	rm $MODELFILE $MD5FILE
fi

docker exec -it indramongo mongorestore /dumps/data --stopOnError

echo "Finished."