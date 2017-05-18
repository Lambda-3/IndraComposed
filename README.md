
__NOTE: This documentation refers to the latest version of Indra. Look for the tags in this repository if you need to install older versions.__

Table of Contents
=================

   * [Indra Composed](#indra-composed)
      * [Requirements](#requirements)
      * [How to start a local instance with the Google News Word2Vec model](#how-to-start-a-local-instance-with-the-google-news-word2vec-model)
   * [Models](#models)
      * [Translations](#translations)
      * [Building Models](#building-models)
   * [Programmatically usage from Python](#programmatically-usage-from-python)
   * [Citing Indra](#citing-indra)
   * [Issues](#issues)


# Indra Composed

A set of utilities to launch __Indra__ and its dependencies with docker-compose. The main goal here is to get a running instance quickly.

## Requirements

Please __ensure__ you have the following requirements:

 * Docker (1.9+) and Docker Compose
 
## How to start a local instance with the Google News Word2Vec model

Assuming you have already cloned this repository do the following.

 1. Start the services.
 
 ```$ docker-compose up -d```


 2. Downloading the model.
 
 ```$ ./downloader.sh  w2v-en-googlenews300neg```
 
 
 3. Test It!
 
 ```
 $ curl -X POST -H "Content-Type: application/json" -d '{
	"corpus": "googlenews300neg",
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

More detailed documentation is [here](https://github.com/Lambda-3/Indra).

# Models

Currently we store the models in the MongoDB database. We are making models available for download [here](http://data.lambda3.org/indra/dumps).

## Translations

To activate the translated semantic relatedness and translated word embeddings the respective translation model must be downloaded. There are seven models (for seven different languages) available:

* de\_en-Europarl\_DGT\_OpenSubtitile - German
* fr\_en-Europarl\_DGT\_OpenSubtitile - French
* es\_en-Europarl\_DGT\_OpenSubtitile - Spanish
* it\_en-Europarl\_DGT\_OpenSubtitile - Italian
* nl\_en-Europarl\_DGT\_OpenSubtitile - Dutch
* sv\_en-Europarl\_DGT\_OpenSubtitile - Swedish
* pt\_en-Europarl\_DGT\_OpenSubtitile - Portuguese

## Building Models

We're planning to increasing the models available and in parallel we will release the code required to build your own models with your corpus.

# Programmatically usage from Python

This code snippet relies on the beatiful library [requests](https://github.com/kennethreitz/requests).

```python

import requests
import json

pairs = [
    {'t1': 'house', 't2': 'beer'},
    {'t1': 'car', 't2': 'engine'}]

data = {'corpus': 'googlenews300neg',
        'model': 'W2V',
        'language': 'EN',
        'scoreFunction': 'COSINE', 'pairs': pairs}

headers = {
    'content-type': "application/json"
}

res = requests.post("http://localhost:8916/relatedness", data=json.dumps(data), headers=headers)
res.raise_for_status()
print(res.json())
```

# Citing Indra

Please cite Indra, if you use it in your experiments or project.
```latex
@Inbook{Freitas2016,
author="Freitas, Andr{\'e}
and Barzegar, Siamak
and Sales, Juliano Efson
and Handschuh, Siegfried
and Davis, Brian",
editor="Blomqvist, Eva
and Ciancarini, Paolo
and Poggi, Francesco
and Vitali, Fabio",
title="Semantic Relatedness for All (Languages): A Comparative Analysis of Multilingual Semantic Relatedness Using Machine Translation",
bookTitle="Knowledge Engineering and Knowledge Management: 20th International Conference, EKAW 2016, Bologna, Italy, November 19-23, 2016, Proceedings",
year="2016",
publisher="Springer International Publishing",
address="Cham",
pages="212--222",
isbn="978-3-319-49004-5",
doi="10.1007/978-3-319-49004-5_14",
url="http://dx.doi.org/10.1007/978-3-319-49004-5_14"
}
```

# Issues

We'd love to hear you. Use our Issue tracker to give feedback!

---
