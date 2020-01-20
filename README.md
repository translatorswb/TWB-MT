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

## Running the pipeline

The scripts to run are sorted under `scripts` directory with a number prefix. Scripts don't take any parameters themselves but need to be edited inside. To run a particular script just type:

`bash #-script-name.sh`

#### Script structure

INITIALIZATIONS, PROCEDURES, CALLS

#### `0-download-data.sh` - Download corpora

To be used for downloading parallel datasets. Download function is set to work with OPUS links by default. Parameters to edit for each call:

- `LINK`: URL to corpus
- `CORPUS`: subdirectory under `corpora` to store the dataset

This will place the parallel files in form of `<corpus-name>.lang1`, `<corpus-name>.lang2` under a directory with the name of the corpus under `corpora`. If you skip this step make sure you follow a similar pattern. 

#### `1-clean-chars.sh` - Text cleaning

Calls various text normalization scripts. For each call edit:

- `CORPUS`: subdirectory under `corpora` to store the dataset
- `C`: `<corpus-name>`
- `LANGS`: Language extensions of the parallel files (`lang1`, `lang2`)

#### `2-clean-and-split.sh` - Parallel sentence cleaning and train/dev splitting

...
