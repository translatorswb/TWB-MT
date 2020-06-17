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

Three main directories used in the pipeline are as follows:
- __*scripts*__ contains the scripts for preparing the data, training models and evaluation
- __*corpora*__ (created within scripts) is where datasets containing parallel sentences are downloaded and then processed (created within scripts)
- __*onmt*__ (created within scripts) contains the models, logs, Open-NMT specific datasets, inference results and evaluation scores

### Dataset naming convention

The data processing is made visible with the use of suffixes. Each dataset obtains a suffix after a certain pipeline call. The naming convention while processing is as follows:

`/corpora/<corpus-name>/<dataset>.<set>.<process1>.<process2>...<processX>.<lang-code>`

For example: 

`/corpora/OPUS/Tatoeba.train.tok.low.en` contains the English sentences in the training portion of the Tatoeba set downloaded from OPUS, tokenized and then lowercased. 

### Script structure

Each script consists of three sections:
- `INITIALIZATIONS`: Sets the paths for later use. This needs not be edited if the directory structure is kept as it is
- `PROCEDURES`: Contains the necessary functions of the pipeline step
- `CALLS`: This is where the pipeline's procedure is called. Each call consists of a set of parameters being specified followed with a procedure call

## Running the pipeline

The scripts to run are sorted under `scripts` directory with a number prefix. Scripts don't take any parameters themselves but need to be edited inside. To run a particular script just type:

`bash #-<script-name>.sh`

#### `0-download-data.sh` - Download corpora

To be used for downloading parallel datasets. Download function is set to work with OPUS links by default. Parameters to specify for each call:

- `LINK`: URL to corpus
- `CORPUS`: Subdirectory where dataset is kept under `corpora`

This will place the parallel files in form of `<corpus-name>.<lang1>`, `<corpus-name>.<lang2>` under a directory with the name of the corpus under `corpora`. If you skip this step make sure you follow a similar pattern of filepath and naming.

#### `1-clean-chars.sh` - Text cleaning

Calls various text normalization scripts. For each call specify:

- `CORPUS`: Subdirectory where dataset is kept
- `C`: Corpus name
- `LANGS`: Language extensions of the parallel files (`lang1`, `lang2`)

#### `2-clean-and-split.sh` - Parallel sentence cleaning and train/dev splitting, test exclusion

Cleans empty and dirty samples, allocates a development set and also excludes test samples from a given dataset. Actual processing is done in `data_prep.py`. For each call specify:

- `CORPUS`: Subdirectory where dataset is kept
- `C`: Corpus name
- `SRC`: Source language code
- `TGT`: Target language code
- `SUFFIX`: Complete process suffix that the dataset to be processed has
- `EXCLUDESET`: Set of sentences that need to be taken out from the train/dev portion
- `EXCLUDEFROM`: side of the exclude set as `src` or `tgt`

Size of development set is specified in `data-prep.py`. 

#### `3-tokenize.sh` - Classic tokenization and lowercasing

Uses moses tokenizer or any other tokenization script for punctuation tokenization. Set `MOSESDIR` to where moses decoder is kept. If a special tokenizer is to be used then it's specified by `SRCTOKENIZER` or `TGTTOKENIZER`. 

For each dataset to be tokenized specify the following: 

- `CORPUS`: subdirectory where dataset is kept
- `C`: Corpus name
- `SETS`: Subsets (train/test/dev) (If this is used then `tokenize_set` procedure needs to be called)
- `SUFFIX`: Complete process suffix that the dataset to be processed has. 
- `SRC`: Source language code
- `TGT`: Target language code

#### `4-train-bpe.sh` - BPE training

Trains byte-pair-encoding (BPE) tokens from a given set and stores under `onmt/bpe`. Uses `subword-nmt` library. This should be done on one big set using the parameters:

- `CORPUS`: Subdirectory where dataset is kept
- `C`: Corpus name
- `SRC`: Source language code for BPE training
- `TGT`: Target language code for BPE training
- `BPEID`: ID of the BPE model
- `OPS`: Number of BPE operations. 

#### `5-apply-bpe.sh` - BPE training

Applies BPE tokenization to the datasets. This needs to be done to all train/dev/test sets. 

Parameters related to BPE model:

- `BPEID`: ID of the BPE model with #operations
- `BPESRC`: Source language code used for BPE training
- `BPETGT`: Target language code used for BPE training

For datasets to be bpe-ized:

- `CORPUS`: Subdirectory where dataset is kept
- `C`: Corpus name
- `SUFFIX`: Complete process suffix that the dataset to be processed has. 
- `SETS`: Subsets (train/test/dev) (If this is used then `apply_bpe_to_sets` procedure needs to be called)
- `SRC`: Source language code
- `TGT`: Target language code

#### `6-preprocess.sh` - Data preparation for OpenNMT

This converts the prepared training datasets into form that OpenNMT takes in. For each dataset both training and a development set needs to be specificed. 

- `CORPUSTRAIN`: Path to training set without language suffix
- `CORPUSDEV`: Path to development set without language suffix
- `SRCTRAIN`: Source language code for training set
- `TGTTRAIN`: Target language code for training set
- `SRCDEV`: Source language code for development set
- `TGTDEV`: Target language code for development set
- `DATASET`: Name for the training dataset

#### `7x-train.sh` - Training 

There are three training scripts: `7a-train-multilingual.sh`, `7b-train-unilingual.sh`, `7c-train-indomain.sh`. This is for three stage training in low-resource settings. 

- `MODELPREFIX`: A label for the model
- `MODELID`: An ID for the model 
- `DATASET`: Preprocessed training dataset name
- `BPEID`: ID of the BPE model with #operations

Scripts `7b` and `7c` continues training on the best scoring model from the previous step. These additional parameters need to be set:

- `BASEMODELTYPE`: Type of the base model (multilingual, unilingual or indomain)
- `BASEMODELID`: ID of the base model

Training parameters are specified in the `do_train` procedure while calling [OpenNMT-py's training script](https://opennmt.net/OpenNMT-py/options/train.html).

Once training is complete, best scoring model from each step can be found under: `onmt/models/<model-prefix>-<model-type>-<model-id>/<model-prefix>-<model-type>-<model-id>_best.pt`

#### `8-translate.sh` - Inference

This step is for translating test sets using the trained models. For each call specify the following parameters:

- `MODELPREFIX`: Label of the model to use for inference
- `MODELTYPE`: Type of the model to use for inference 
- `MODELID`: ID  of the model to use for inference 
- `BPEID`: ID of the BPE model with #operations
- `CORPUSTEST`: Path to testing set without the language suffix
- `SRC`: Source language code
- `TGT`: Target language code

Inference results (direct and _un-bpe'd_) are saved under the path `onmt/test`. 

#### `9-evaluation.sh` - Evaluation using MT metrics

This final steps calculates various MT evaluation metrics on the inferred translations. Evaluation scripts are accessed from [mt-tools](https://github.com/translatorswb/mt-tools).

For each call specify the following:
- `MODELPREFIX`: Label of the model to use for inference
- `MODELTYPE`: Type of the model to use for inference 
- `MODELID`: ID  of the model to use for inference 
- `BPEID`: ID of the BPE model used 
- `CORPUSTEST`: Path to testing set without the language suffix
- `SRC`: Source language code
- `TGT`: Target language code

Evaluation results are printed and also stored under the path `onmt/eval`. 
