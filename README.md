# Indra Composed

A set of utilities to launch __Indra__ and its dependencies with docker-compose.
The main goal here is to get a running instance quickly then you can go directly to the API usage section. 

## Requirements

Please __ensure__ you have the following requirements:

 * Docker (1.9+) and Docker Compose
 * Python (2.7+ or 3.0+)
 
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

# Citing Indra in papers

Please cite Indra in your paper, if you use it in your experiments.
```latex
@inproceedings{Barzegar:2015:DOS:2766462.2767870,
 author = {Barzegar, Siamak and Sales, Juliano Efson and Freitas, Andre and Handschuh, Siegfried and Davis, Brian},
 title = {DINFRA: A One Stop Shop for Computing Multilingual Semantic Relatedness},
 booktitle = {Proceedings of the 38th International ACM SIGIR Conference on Research and Development in Information Retrieval},
 series = {SIGIR '15},
 year = {2015},
 isbn = {978-1-4503-3621-5},
 location = {Santiago, Chile},
 pages = {1027--1028},
 numpages = {2},
 url = {http://doi.acm.org/10.1145/2766462.2767870},
 doi = {10.1145/2766462.2767870},
 acmid = {2767870},
 publisher = {ACM},
 address = {New York, NY, USA},
 keywords = {distirbutional infrastructure, distributional semantic models, multilingual semantic relatedness},
}
```

# Issues

We'd love to hear you. Use our Issue tracker to give feedback!

---
