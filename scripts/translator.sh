# Script for translating a file
# Usage: ./translator.sh <input-file> <output-file> <model-file> <bpe-codes> 

FS="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Set the following variables 
MDIR="$HOME/extSW/mosesdecoder" # Directory where mosesdecoder is 
MOSESLANG="fr"

#Read arguments
INPUTFILE=$1
OUTPUTFILE=$2
MODELFILE=$3
BPECODES=$4

python $FS/normalize-chars.py -l en < $INPUTFILE > input.norm
python $FS/fix-ellipsis.py  < input.norm > input.norm.fixel

perl $MDIR/scripts/tokenizer/tokenizer.perl -q -l $MOSESLANG< input.norm.fixel > input.norm.fixel.tok
perl $MDIR/scripts/tokenizer/lowercase.perl -q -l $MOSESLANG < input.norm.fixel.tok > input.norm.fixel.tok.low

subword-nmt apply-bpe -c $BPECODES < input.norm.fixel.tok.low > input.norm.fixel.tok.low.bpe

onmt_translate -model $MODELFILE -src input.norm.fixel.tok.low.bpe -output input.norm.fixel.tok.low.bpe.inf -replace_unk -gpu 1
cat input.norm.fixel.tok.low.bpe.inf | sed -r 's/(@@ )|(@@ ?$)//g' > input.norm.fixel.tok.low.bpe.inf.unbpe

perl $MDIR/scripts/tokenizer/detokenizer.perl -l $MOSESLANG < input.norm.fixel.tok.low.bpe.inf.unbpe > input.norm.fixel.tok.low.bpe.inf.unbpe.detok

python $FS/recase.py input.norm.fixel.tok.low.bpe.inf.unbpe.detok

cp input.norm.fixel.tok.low.bpe.inf.unbpe.detok.cap $OUTPUTFILE

rm input*

