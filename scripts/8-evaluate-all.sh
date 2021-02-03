BPEID=BPE-fixmix-6000

TRAINID=A
printf "===== Evaluating setup $TRAINID =====\n"

CORPUS=test.swc.old
C=test-old
SRC=swc
TGT=fra
printf "TEST SET: $CORPUS\n"

MODELTAG=generic-s001
printf "MODEL: $TRAINID-$MODELTAG\n"

printf "$SRC->$TGT\n"
bash 8a-inference.sh $TRAINID $MODELTAG $BPEID $CORPUS $C $SRC $TGT
bash 8b-evaluate.sh $TRAINID $MODELTAG $CORPUS $C $SRC $TGT

printf "\n$TGT->$SRC\n"
bash 8a-inference.sh $TRAINID $MODELTAG $BPEID $CORPUS $C $TGT $SRC
bash 8b-evaluate.sh $TRAINID $MODELTAG $CORPUS $C $TGT $SRC
