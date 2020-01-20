# TWB-MT
TWB neural machine translation pipeline

This repository contains the necessary scripts for training and evaluating a neural machine translation system from scratch. It serves both as a template and a memory of experiments for various language pairs within TWB's [Gamayun initiative](https://translatorswithoutborders.org/gamayun/).

Master branch is kept as a template for training a toy model of Tigrinya to English. Make sure it works before building your own pipeline. 

Development for each language pair is kept in branches. 

### Current language pairs
- English -> Tigrinya

### Required libraries 
- [OpenNMT-py](https://github.com/OpenNMT/OpenNMT-py)
- [Moses](https://github.com/moses-smt/mosesdecoder)
- [subword-nmt](https://github.com/rsennrich/subword-nmt)
- [mt-tools](https://github.com/translatorswb/mt-tools)
- pandas 

### Directory structure

Three main directories are as follows:
- __*scripts*__ contains the scripts for preparing the data, training models and evaluation
- __*corpora*__ (created within scripts) is where datasets containing parallel sentences are downloaded and then processed (created within scripts)
- __*onmt*__ (created within scripts) contains the models, logs, Open-NMT specific datasets, inference results and evaluation scores
