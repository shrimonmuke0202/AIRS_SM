#!/bin/sh

gpu=(3 3 3)

PDE='diff-react'
field_dim=2
scale_factor=8

HR_resolution=128
LR_resolution=$((HR_resolution / scale_factor))

sw=7

suffix_list=(
    "${PDE}_LRinput_supervised_SRCNN_bicubic_init_s_${LR_resolution}to${HR_resolution}_sw_${sw}"
)

data_frac_list=(
    "1/20"
)


for ((i=0; i<1; i++)); do
    (
        CUDA_VISIBLE_DEVICES=${gpu[i]} \
        python ../src/main.py \
        --model='SRCNN' \
        --batch_size=32 \
        --scale_factor=${scale_factor} \
        --epochs=200 \
        --suffix=${suffix_list[i]} \
        --experiment='Supervised' \
        --upsample='bicubic' \
        --freq_center_size=28 \
        --freeze_size=8 \
        --domain_size='2pi' \
        --emb_dim=32 \
        --subset \
        --data_frac=${data_frac_list[i]} \
        --supervised_loss='mse' \
        --residual \
        --sw=${sw} \
        --PDE=${PDE} \
        --field_dim=${field_dim} \
        --seperate_prediction \
        --LR_resolution=${LR_resolution} \
        --HR_resolution=${HR_resolution} \
    ) #&
done