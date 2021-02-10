# Script that trains all experiments in the paper

BPEID="BPE-fixmix-6000"

TRAINID="A"
echo Training setup $TRAINID
echo
bash 7a-train-pretrain.sh $TRAINID generic s001 $BPEID swcmix swc fra 2048 1500
echo 
bash 7c-train-continue.sh $TRAINID intwb t001 $BPEID twbmix swc fra 512 200 generic-s001 swc fra
echo 

TRAINID="B"
echo Training setup $TRAINID
echo
bash 7a-train-pretrain.sh $TRAINID generic s001 $BPEID swmix sw fr 2048 5300
echo 
bash 7c-train-continue.sh $TRAINID inswc i001 $BPEID swcmix swc fra 512 200 generic-s001 sw fr
echo 
bash 7c-train-continue.sh $TRAINID intwb t001 $BPEID twbmix swc fra 512 200 inswc-s001-i001 swc fra
echo 

TRAINID="C"
echo Training setup $TRAINID
echo
bash 7a-train-pretrain.sh $TRAINID generic s001 $BPEID mtedmix sw fr 2048 5300
echo 
bash 7c-train-continue.sh $TRAINID inswc i001 $BPEID swcmix swc fra 512 200 generic-s001 sw fr
echo 
bash 7c-train-continue.sh $TRAINID intwb t001 $BPEID twbmix swc fra 512 200 inswc-s001-i001 swc fra
echo 

TRAINID="D"
echo Training setup $TRAINID
echo
bash 7a-train-pretrain.sh $TRAINID generic s001 $BPEID monomix sw fr 2048 5300
echo 
bash 7c-train-continue.sh $TRAINID inswc i001 $BPEID swcmix swc fra 512 200 generic-s001 sw fr
echo 
bash 7c-train-continue.sh $TRAINID intwb t001 $BPEID twbmix swc fra 512 200 inswc-s001-i001 swc fra
echo 
