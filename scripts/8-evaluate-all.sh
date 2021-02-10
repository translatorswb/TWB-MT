# Batch evaluation script for paper. Does inference and evaluates in three stages.
# Example call
# $ bash 8-evaluate-all.sh D test.twbkit test-twbkit [> ../results/D-twbkit.txt]

BPEID=BPE-fixmix-6000

TRAINID=$1
printf "===== Evaluating setup $TRAINID =====\n"

CORPUS=$2
C=$3
SRC=swc
TGT=fra
printf "TEST SET: $CORPUS\n"

MODELTAG=generic-s001
MODELSRC=sw #swc for Procedure A
MODELTGT=fr #fra for Procedure A
printf "\nMODEL: $TRAINID-$MODELTAG\n"

printf "$SRC->$TGT\n"
bash 8a-inference.sh $TRAINID $MODELSRC-$MODELTGT-$MODELTAG $BPEID $CORPUS $C $SRC $TGT
bash 8b-evaluate.sh $TRAINID $MODELSRC-$MODELTGT-$MODELTAG $CORPUS $C $SRC $TGT

printf "\n$TGT->$SRC\n"
bash 8a-inference.sh $TRAINID $MODELTGT-$MODELSRC-$MODELTAG $BPEID $CORPUS $C $TGT $SRC
bash 8b-evaluate.sh $TRAINID $MODELTGT-$MODELSRC-$MODELTAG $CORPUS $C $TGT $SRC

MODELTAG=inswc-s001-i001
MODELSRC=swc
MODELTGT=fra
printf "\nMODEL: $TRAINID-$MODELTAG\n"

printf "$SRC->$TGT\n"
bash 8a-inference.sh $TRAINID $MODELSRC-$MODELTGT-$MODELTAG $BPEID $CORPUS $C $SRC $TGT
bash 8b-evaluate.sh $TRAINID $MODELSRC-$MODELTGT-$MODELTAG $CORPUS $C $SRC $TGT

printf "\n$TGT->$SRC\n"
bash 8a-inference.sh $TRAINID $MODELTGT-$MODELSRC-$MODELTAG $BPEID $CORPUS $C $TGT $SRC
bash 8b-evaluate.sh $TRAINID $MODELTGT-$MODELSRC-$MODELTAG $CORPUS $C $TGT $SRC

#Comment out from here for Procedure A
MODELTAG=intwb-s001-i001-t001
MODELSRC=swc
MODELTGT=fra
printf "\nMODEL: $TRAINID-$MODELTAG\n"

printf "$SRC->$TGT\n"
bash 8a-inference.sh $TRAINID $MODELSRC-$MODELTGT-$MODELTAG $BPEID $CORPUS $C $SRC $TGT
bash 8b-evaluate.sh $TRAINID $MODELSRC-$MODELTGT-$MODELTAG $CORPUS $C $SRC $TGT

printf "\n$TGT->$SRC\n"
bash 8a-inference.sh $TRAINID $MODELTGT-$MODELSRC-$MODELTAG $BPEID $CORPUS $C $TGT $SRC
bash 8b-evaluate.sh $TRAINID $MODELTGT-$MODELSRC-$MODELTAG $CORPUS $C $TGT $SRC


#alert 
echo -en "\007"
