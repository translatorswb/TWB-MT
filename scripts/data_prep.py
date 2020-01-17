#MT data preparation script. Work in collaboration with masakhane (https://github.com/masakhane-io/masakhane/).

import sys
import os
from math import floor
import random
import numpy as np
import csv
import pandas as pd

#Script arguments
DATASET_NAME = sys.argv[1]
ALL_SRC_PATH = sys.argv[2]
ALL_TGT_PATH = sys.argv[3]

#Script arguments for optional test set to exclude
if len(sys.argv) > 4:
    EXCLUDE_TEST = True
    TEST_PATH = sys.argv[4]
    TEST_SIDE = sys.argv[5] #'src' or 'tgt'
else:
    EXCLUDE_TEST = False

#Other variables
DROP_CONFLICTING = False
LOWERCASE = False    #To convert all text to lowercase 
ALLOCATE_DEV = True        #To allocate a development set
DEV_SIZE = 10
SEED = 42
OUTPUT_SUFFIX = "masprep"

#Variables to derive from arguments
DATADIR = os.path.dirname(ALL_SRC_PATH)
SRC_LANG = os.path.basename(ALL_SRC_PATH).split(".")[-1]
TGT_LANG = os.path.basename(ALL_TGT_PATH).split(".")[-1]
TRAILING_SUFFIX = ".".join(os.path.basename(ALL_SRC_PATH)[len(DATASET_NAME)+1:].split(".")[:-1])
if TRAILING_SUFFIX:
    TRAILING_SUFFIX += "."

print("Trailing suffix", TRAILING_SUFFIX)

#Load test sentences
if EXCLUDE_TEST:
    test_sents = set()
    j = 0
    with open(TEST_PATH) as f:
        for line in f:
            test_sents.add(line.strip())
            j += 1
    print('Loaded {} global test sentences to filter from the training/dev data.'.format(j))

#Load data while skipping empty and test sentences
source = []
target = []
skip_test = 0
skip_empty = 0 
raw_count = 0
with open(ALL_SRC_PATH) as src, open(ALL_TGT_PATH) as tgt:
    for line_src, line_tgt in zip(src,tgt):
        raw_count += 1
        # Skip sentences that are contained in the test set.
        if line_src.strip() and line_tgt.strip():
            if EXCLUDE_TEST:
                if TEST_SIDE == 'src':
                    check_sent = line_src.strip()
                elif TEST_SIDE == 'tgt':
                    check_sent = line_tgt.strip()
                if check_sent not in test_sents:
                    source.append(line_src.strip())
                    target.append(line_tgt.strip())
                else:
                    skip_test += 1
            else:
                source.append(line_src.strip())
                target.append(line_tgt.strip())
        else:
            skip_empty += 1             
                      
print('Loaded data. Raw size: %i'%raw_count)
print('%i contained in test set'%skip_test)
print('%i empty'%skip_empty)

df = pd.DataFrame(list(zip(source, target)), columns=['source_sentence', 'target_sentence'])
print("After test & empty skipping: %i"%len(df))

# drop duplicate translations
df_pp = df.drop_duplicates()
print("After drop duplicates: %i"%len(df_pp))

#drop non-geez lines from source
df_pp = df_pp[df_pp.source_sentence.str.contains('[\u1200-\u137f|\u1380-\u1394|\u2d80-\u2ddf|\uab00-\uab2f]',case=False)]
print("After drop non-geez: %i"%len(df_pp))

# drop conflicting translations
if DROP_CONFLICTING:
    df_pp.drop_duplicates(subset='source_sentence', inplace=True)
    df_pp.drop_duplicates(subset='target_sentence', inplace=True)
    print("After drop conflicts: %i"%len(df_pp))

# Shuffle the data to remove bias in dev set selection.
df_pp = df_pp.sample(frac=1, random_state=SEED).reset_index(drop=True)

# Lowercase
if LOWERCASE:
    df_pp["source_sentence"] = df_pp["source_sentence"].str.lower()
    df_pp["target_sentence"] = df_pp["target_sentence"].str.lower()

# Allocate development set
if ALLOCATE_DEV:
    dev = df_pp.tail(DEV_SIZE) # Herman: Error in original
    stripped = df_pp.drop(df_pp.tail(DEV_SIZE).index)
else:
    stripped = df_pp

print("After dev strip: %i"%len(stripped))

# Report
print("Training set size: %i"%len(stripped))
if ALLOCATE_DEV:
    print("Dev set size: %i"%len(dev))

# Write to file
print("Writing to file...")
train_file = DATASET_NAME + ".train." + TRAILING_SUFFIX +  OUTPUT_SUFFIX    
with open(os.path.join(DATADIR, train_file + "." + SRC_LANG), "w") as src_file, open(os.path.join(DATADIR, train_file + "." + TGT_LANG), "w") as tgt_file:
    for index, row in stripped.iterrows():
        src_file.write(row["source_sentence"] + "\n")
        tgt_file.write(row["target_sentence"] + "\n")
    print("Training set written to %s"%train_file)

if ALLOCATE_DEV:
    dev_file = DATASET_NAME + ".dev." + TRAILING_SUFFIX + OUTPUT_SUFFIX
    with open(os.path.join(DATADIR, dev_file + "." + SRC_LANG), "w") as src_file, open(os.path.join(DATADIR, dev_file + "." + TGT_LANG), "w") as tgt_file:
        for index, row in dev.iterrows():
            src_file.write(row["source_sentence"]+"\n")
            tgt_file.write(row["target_sentence"]+"\n")
        print("Validation set written to %s"%dev_file)

