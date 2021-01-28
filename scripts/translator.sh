# Script for translating a file
# Usage: ./translator.sh <input_file>
# Outputs translation to a file named output

FS="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Set the following variables 
MDIR="$HOME/extSW/mosesdecoder" # Directory where mosesdecoder is 

#MODELFILE="$FS/../onmt/models/monomix-fr-sw-inswc-s001-i001/monomix-fr-sw-inswc-s001-i001_best.pt" #Path to OpenNMT-py model (.pt)
#BPE="$FS/../onmt/bpe/BPE-monomix-6000.codes" 		#Path to BPE codes
#VOCAB="$FS/../onmt/bpe/BPE-monomix-6000.fr.vocab"	#Path to source BPE vocabulary file

MODELFILE="$FS/../onmt/models/mtedmix-sw-fr-intwb-s001-i001-t001/mtedmix-sw-fr-intwb-s001-i001-t001_best.pt" #Path to OpenNMT-py model (.pt)
BPE="$FS/../onmt/bpe/BPE-mtedmix-6000.codes"            #Path to BPE codes
VOCAB="$FS/../onmt/bpe/BPE-mtedmix-6000.sw.vocab"       #Path to source BPE vocabulary file

python2 $FS/normalize-chars.py -l en < $1 > input.norm
python2 $FS/fix-ellipsis.py  < input.norm > input.norm.fixel

perl $MDIR/scripts/tokenizer/tokenizer.perl -q < input.norm.fixel > input.norm.fixel.tok
perl $MDIR/scripts/tokenizer/lowercase.perl -q < input.norm.fixel.tok > input.norm.fixel.tok.low

subword-nmt apply-bpe -c $BPE --vocabulary $VOCAB < input.norm.fixel.tok.low > input.norm.fixel.tok.low.bpe

onmt_translate -model $MODELFILE -src input.norm.fixel.tok.low.bpe -output input.norm.fixel.tok.low.bpe.inf -replace_unk -gpu 1
cat input.norm.fixel.tok.low.bpe.inf | sed -r 's/(@@ )|(@@ ?$)//g' > input.norm.fixel.tok.low.bpe.inf.unbpe

perl $MDIR/scripts/tokenizer/detokenizer.perl < input.norm.fixel.tok.low.bpe.inf.unbpe > input.norm.fixel.tok.low.bpe.inf.unbpe.detok

python3 $FS/recase2.py input.norm.fixel.tok.low.bpe.inf.unbpe.detok

cp input.norm.fixel.tok.low.bpe.inf.unbpe.detok.cap $2

rm input*

