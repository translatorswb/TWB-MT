#!/usr/bin/env python3
import textwrap
from pprint import pprint
import nltk.data # $ pip install http://www.nltk.org/nltk3-alpha/nltk-3.0a3.tar.gz
import sys
# python -c "import nltk; nltk.download('punkt')"

in_file = sys.argv[1]
out_file = in_file + ".cap"

sent_tokenizer = nltk.data.load('tokenizers/punkt/english.pickle')
with open(in_file, 'r') as f:
    text = f.read()

sentences = sent_tokenizer.tokenize(text)
sentences = [sent.capitalize() for sent in sentences]

recased = ' '.join(sentences)
print(recased)

with open(out_file, 'w') as f:
    f.write(recased + "\n")
