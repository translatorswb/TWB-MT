# TRAINID="TOY"
# BPEID="$BPEID"
# echo Training setup $TRAINID
# bash 7a-train-step1.sh $TRAINID $BPEID toy sw fr 5 5
# echo 
# bash 7c-train-step3.sh $TRAINID inswc i001 $BPEID toy swc fra 512 200 generic-s001 sw fr
# echo
# bash 7c-train-step3.sh $TRAINID $BPEID toy swc fra 5 5 inswc-s001-i001 swc fra

BPEID="BPE-fixmix-6000"

# TRAINID="A"
# echo Training setup $TRAINID
# echo
# bash 7a-train-step1.sh $TRAINID $BPEID swcmix swc fra 2048 1500
# echo 
# bash 7c-train-step3.sh $TRAINID intwb t001 $BPEID twbmix swc fra 512 200 generic-s001 swc fra
# echo 

# TRAINID="B"
# echo Training setup $TRAINID
# echo
# bash 7a-train-step1.sh $TRAINID $BPEID swmix sw fr 2048 5300
# echo 
# bash 7c-train-step3.sh $TRAINID inswc i001 $BPEID swcmix swc fra 512 200 generic-s001 sw fr
# echo 
# bash 7c-train-step3.sh $TRAINID intwb t001 $BPEID twbmix swc fra 512 200 inswc-s001-i001 swc fra
# echo 

TRAINID="Cfix"
echo Training setup $TRAINID
echo
bash 7a-train-step1.sh $TRAINID $BPEID mtedmix sw fr 2048 5300
echo 
bash 7c-train-step3.sh $TRAINID inswc i001 $BPEID swcmix swc fra 512 200 generic-s001 sw fr
echo 
bash 7c-train-step3.sh $TRAINID intwb t001 $BPEID twbmix swc fra 512 200 inswc-s001-i001 swc fra
echo 

TRAINID="Dfix"
echo Training setup $TRAINID
echo
bash 7a-train-step1.sh $TRAINID $BPEID monomix sw fr 2048 5300
echo 
bash 7c-train-step3.sh $TRAINID inswc i001 $BPEID swcmix swc fra 512 200 generic-s001 sw fr
echo 
bash 7c-train-step3.sh $TRAINID intwb t001 $BPEID twbmix swc fra 512 200 inswc-s001-i001 swc fra
echo 
