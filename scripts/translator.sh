# Script for translating a file
# Usage: ./translator.sh <input_file>
# Outputs translation to a file named output

# Set the following variables 
MDIR="" # Directory where mosesdecoder is 

MODELFILE="" 	#Path to OpenNMT-py model (.pt)
BPE="" 		#Path to BPE codes
VOCAB=""	#Path to BPE vocabulary file

python2 normalize-chars.py -l en < $1 > input.norm
python2 fix-ellipsis.py  < input.norm > input.norm.fixel

perl $MDIR/scripts/tokenizer/tokenizer.perl -q < input.norm.fixel > input.norm.fixel.tok
perl $MDIR/scripts/tokenizer/lowercase.perl -q < input.norm.fixel.tok > input.norm.fixel.tok.low

subword-nmt apply-bpe -c $BPE --vocabulary $VOCAB < input.norm.fixel.tok.low > input.norm.fixel.tok.low.bpe

onmt_translate -model $MODELFILE -src input.norm.fixel.tok.low.bpe -output input.norm.fixel.tok.low.bpe.inf -replace_unk
cat input.norm.fixel.tok.low.bpe.inf | sed -r 's/(@@ )|(@@ ?$)//g' > input.norm.fixel.tok.low.bpe.inf.unbpe

perl $MDIR/scripts/tokenizer/detokenizer.perl < input.norm.fixel.tok.low.bpe.inf.unbpe > input.norm.fixel.tok.low.bpe.inf.unbpe.detok

python3 recase.py input.norm.fixel.tok.low.bpe.inf.unbpe.detok

cp input.norm.fixel.tok.low.bpe.inf.unbpe.detok.cap output

rm input*

