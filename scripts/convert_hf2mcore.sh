#!/bin/bash

MCORE_MODEL_NAME=$MODEL_NAME-hf-to-mcore-te-tp$NPROC_PER_NODE-pp$NNODES

if [ "$MODEL_NAME" = "Qwen2-0.5B" ] || \
    [ "$MODEL_NAME" = "Qwen2-0.5B-Instruct" ] || \
    [ "$MODEL_NAME" = "Qwen2-1.5B" ] || \
    [ "$MODEL_NAME" = "Qwen2-1.5B-Instruct" ] || \
    [ "$MODEL_NAME" = "Qwen2-7B" ] || \
    [ "$MODEL_NAME" = "Qwen2-7B-Instruct" ] || \
    [ "$MODEL_NAME" = "Qwen2-72B" ] || \
    [ "$MODEL_NAME" = "Qwen2-72B-Instruct" ]; then
    template="qwen"
    file_convert="hf2mcore_qwen2_convertor.sh"
    convert_args="
            1.5B \
            /app/models/$MODEL_NAME/ \
            /app/models/$MCORE_MODEL_NAME  \
            2 \
            1 \
            1 \
            fp16 \
            true \
            false 
    "
    
elif [ "$MODEL_NAME" = "Meta-Llama-3-8B" ] || \
    [ "$MODEL_NAME" = "Meta-Llama-3-8B-Instruct" ] || \
    [ "$MODEL_NAME" = "Meta-Llama-3-70B" ] || \
    [ "$MODEL_NAME" = "Meta-Llama-3-70B-Instruct" ]; then
    template="llama"
fi
    

/bin/bash /app/Pai-Megatron-Patch/toolkits/model_checkpoints_convertor/$template/$file_convert $convert_args

rm -rf /app/models/Qwen2-1.5B