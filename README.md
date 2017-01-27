# Indra Composed
A set of utilities to launch __Indra__ and its dependencies with docker-compose.
The main goal here is to get a running instance quickly then you can go directly to the API usage section. 

## Requirements

Please __ensure__ you have the following requirements:

 * Docker (1.9+) and Docker Compose
 * Python (2.7+)
 
## For the Impatients: Starting a local instance with Word2Vec for English.

Assuming you have already cloned this repository do the following.

 1. Download the data.
 
 ```$ python downloader.py --dumps w2v-en-wiki-2014```
 
 2. ..after a few minutes. 
 
 ```$ docker-compose up```
 
 3. Test It!
 
 ```
 $ curl -X POST -H "Content-Type: application/json" -d '{
	"corpus": "wiki-2014",
	"model": "W2V",
	"language": "EN",
	"scoreFunction": "COSINE",
	"pairs": [{
		"t2": "car",
		"t1": "engine"
	},
	{
		"t2": "car",
		"t1": "flowers"
	}]
}' "http://localhost:8916/relatedness"
```

## Issues

We'd love to hear you. Use our Issue tracker to give feedback!

---
