TRAINID="TOY"
BPEID="BPE-mymtedmix-6000"
echo Training setup $TRAINID
bash 7a-train-step1.sh $TRAINID BPE-mymtedmix-6000 toy swc fra 5 5
echo 
bash 7b-train-step2.sh $TRAINID BPE-mymtedmix-6000 toy swc fra 5 5 $TRAINID-swc-fra-generic-s001
echo

# TRAINID="A"
# BPEID="BPE-mymtedmix-6000"
# echo Training setup $TRAINID
# bash 7a-train-step1.sh $TRAINID BPE-mymtedmix-6000 swcmix 2048 1500
# echo 
# bash 7b-train-step2.sh $TRAINID BPE-mymtedmix-6000 twbmix 40 40
# echo 

# TRAINID="B"
# echo Training setup $TRAINID
# bash 7a-train-step1.sh $TRAINID BPE-mymtedmix-6000 swmix 2048 5300
# echo 
# bash 7b-train-step2.sh $TRAINID BPE-mymtedmix-6000 swcmix 2048 1500
# echo 
# bash 7c-train-step3.sh $TRAINID BPE-mymtedmix-6000 twbmix 40 40
# echo 

# TRAINID="C"
# echo Training setup $TRAINID
# bash 7a-train-step1.sh $TRAINID BPE-mymtedmix-6000 mtedmix 2048 5300
# echo 
# bash 7b-train-step2.sh $TRAINID BPE-mymtedmix-6000 swcmix 2048 1500
# echo 
# bash 7c-train-step3.sh $TRAINID BPE-mymtedmix-6000 twbmix 40 40
# echo 

# TRAINID="D"
# echo Training setup $TRAINID
# bash 7a-train-step1.sh $TRAINID BPE-mymtedmix-6000 monomix 2048 5300
# echo 
# bash 7b-train-step2.sh $TRAINID BPE-mymtedmix-6000 swcmix 2048 1500
# echo 
# bash 7c-train-step3.sh $TRAINID BPE-mymtedmix-6000 twbmix 40 40
# echo 
