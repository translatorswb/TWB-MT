# #CALLS
# BPEID="BPE-fixmix-6000"
# SRC="swc"
# TGT="fra"
# CORPUS="toy"
# C="toy"
# MODELNAME="A-fra-swc-generic-s001"
# do_eval


BPEID=BPE-fixmix-6000

TRAINID=A
echo ------ Evaluating setup $TRAINID -------
CORPUS=test.swc.old
C=test-old
SRC=swc
TGT=fra
echo TEST SET: $CORPUS

bash 8a-inference.sh $TRAINID generic-s001 $BPEID test.swc.old test-old swc fra
bash 8b-evaluate.sh $TRAINID generic-s001 test.swc.old test-old swc fra

