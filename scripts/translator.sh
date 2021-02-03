# Script for translating a file
# Usage: ./translator.sh <input-file> <output-file> <model-file> <bpe-codes> 

FS="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Set the following variables 
MDIR="$HOME/extSW/mosesdecoder" # Directory where mosesdecoder is 

#Read arguments
INPUTFILE=$1
OUTPUTFILE=$2
MODELFILE=$3
BPECODES=$4

# MODELFILE="$FS/../onmt/models/mtedmix-sw-fr-intwb-s001-i001-t001/mtedmix-sw-fr-intwb-s001-i001-t001_best.pt" #Path to OpenNMT-py model (.pt)
# BPE="$FS/../onmt/bpe/BPE-mtedmix-6000.codes"            #Path to BPE codes
# VOCAB="$FS/../onmt/bpe/BPE-mtedmix-6000.sw.vocab"       #Path to source BPE vocabulary file

python $FS/normalize-chars.py -l en < $INPUTFILE > input.norm
python $FS/fix-ellipsis.py  < input.norm > input.norm.fixel

# python2 $FS/normalize-chars.py -l en < $INPUTFILE > input.norm
# python2 $FS/fix-ellipsis.py  < input.norm > input.norm.fixel

perl $MDIR/scripts/tokenizer/tokenizer.perl -q -l fr < input.norm.fixel > input.norm.fixel.tok
perl $MDIR/scripts/tokenizer/lowercase.perl -q -l fr < input.norm.fixel.tok > input.norm.fixel.tok.low

subword-nmt apply-bpe -c $BPECODES < input.norm.fixel.tok.low > input.norm.fixel.tok.low.bpe

onmt_translate -model $MODELFILE -src input.norm.fixel.tok.low.bpe -output input.norm.fixel.tok.low.bpe.inf -replace_unk -gpu 1
cat input.norm.fixel.tok.low.bpe.inf | sed -r 's/(@@ )|(@@ ?$)//g' > input.norm.fixel.tok.low.bpe.inf.unbpe

perl $MDIR/scripts/tokenizer/detokenizer.perl -l fr < input.norm.fixel.tok.low.bpe.inf.unbpe > input.norm.fixel.tok.low.bpe.inf.unbpe.detok

python $FS/recase2.py input.norm.fixel.tok.low.bpe.inf.unbpe.detok

cp input.norm.fixel.tok.low.bpe.inf.unbpe.detok.cap $OUTPUTFILE

rm input*

