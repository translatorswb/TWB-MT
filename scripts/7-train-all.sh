# TRAINID="TOY"
# BPEID="BPE-fullmix-6000"
# echo Training setup $TRAINID
# bash 7a-train-step1.sh $TRAINID BPE-fullmix-6000 toy sw fr 5 5
# echo 
# bash 7b-train-step2.sh $TRAINID BPE-fullmix-6000 toy swc fra 5 5 generic-s001 sw fr
# echo
# bash 7c-train-step3.sh $TRAINID BPE-fullmix-6000 toy swc fra 5 5 inswc-s001-i001 swc fra

# TRAINID="A"
# BPEID="BPE-fullmix-6000"
# echo Training setup $TRAINID
# echo
# bash 7a-train-step1.sh $TRAINID BPE-fullmix-6000 swcmix swc fra 2048 1500
# echo 
# bash 7b-train-step2.sh $TRAINID BPE-fullmix-6000 twbmix swc fra 40 40 generic-s001 swc fra
# echo 

# TRAINID="B"
# echo Training setup $TRAINID
# echo
# bash 7a-train-step1.sh $TRAINID BPE-fullmix-6000 swmix sw fr 2048 5300
# echo 
# bash 7b-train-step2.sh $TRAINID BPE-fullmix-6000 swcmix swc fra 2048 1500 generic-s001 sw fr
# echo 
# bash 7c-train-step3.sh $TRAINID BPE-fullmix-6000 twbmix swc fra 40 40 inswc-s001-i001 swc fra
# echo 

TRAINID="C"
echo Training setup $TRAINID
echo
bash 7a-train-step1.sh $TRAINID BPE-fullmix-6000 mtedmix sw fr 2048 5300
echo 
bash 7b-train-step2.sh $TRAINID BPE-fullmix-6000 swcmix swc fra 2048 1500 generic-s001 sw fr
echo 
bash 7c-train-step3.sh $TRAINID BPE-fullmix-6000 twbmix swc fra 40 40 inswc-s001-i001 swc fra
echo 

TRAINID="D"
echo Training setup $TRAINID
echo
bash 7a-train-step1.sh $TRAINID BPE-fullmix-6000 monomix sw fr 2048 5300
echo 
bash 7b-train-step2.sh $TRAINID BPE-fullmix-6000 swcmix swc fra 2048 1500 generic-s001 sw fr
echo 
bash 7c-train-step3.sh $TRAINID BPE-fullmix-6000 twbmix swc fra 40 40 inswc-s001-i001 swc fra
echo 
