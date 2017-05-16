#!/bin/bash

set -e

loaded=`docker exec -it indramongo mongo $1 --quiet --eval "db.getCollectionNames().length"`
loaded=$(echo -n "${loaded//[[:space:]]/}")

if [ "$loaded" != "0" ] ; then
	echo "$1 already loaded."
	exit 0
fi

BASEURL="http://data.lambda3.org/indra/dumps"

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