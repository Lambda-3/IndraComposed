# Indra Composed

A set of utilities to launch __Indra__ and its dependencies with docker-compose.
The main goal here is to get a running instance quickly then you can go directly to the API usage section. 

## Requirements

Please __ensure__ you have the following requirements:

 * Docker (1.9+) and Docker Compose
 * Python (2.7+)
 
## For the Impatient: Starting a local instance with Word2Vec and GloVe for English.

Assuming you have already cloned this repository do the following.

 1. Download the desired Models.
 
 ```$ python downloader.py --dumps w2v-en-wiki-2014 --dumps glove-en-wiki-2014```
 
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

# Models

Currently we store the models in [MongoDB 3.0](https://docs.mongodb.com/manual/release-notes/3.0/). We are making the MongoDB databases available for download [here](http://data.lambda3.org/indra).

## Building Models

We're planning to increasing the models available and in parallel we will release the code required to build your own models with your corpus.  

## downloader.py

To keep the deployment simple we advise to use the __downloader.py__ command line tool in order to fetch the desired models in sync with the supported Indra version.

# Programmatically Usage

### Python. 

This code snippet relies on the beatiful library [requests](https://github.com/kennethreitz/requests).

```python

import requests
import json

pairs = [
    {'t1': 'house', 't2': 'beer'},
    {'t1': 'car', 't2': 'engine'}]

data = {'corpus': 'wiki-2014',
        'model': 'W2V',
        'language': 'EN',
        'scoreFunction': 'COSINE', 'pairs': pairs}

headers = {
    'content-type': "application/json"
}

res = requests.post("http://example.com:8916/relatedness", data=json.dumps(data), headers=headers)
res.raise_for_status()
print(res.json())
```

# Issues

We'd love to hear you. Use our Issue tracker to give feedback!

---
