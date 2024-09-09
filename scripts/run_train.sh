#!/bin/bash

huggingface-cli login --token $HUGGINGFACE_TOKEN

/bin/bash convert_hf2mcore.sh
ls /app/models

echo "Convert DONE"

if [ "${NNODES:-0}" -gt 1 ]; then
    running="dlc"
else
    running="dsw"
fi

MCORE_MODEL_NAME=$MODEL_NAME-hf-to-mcore-te-tp$NPROC_PER_NODE-pp$NNODES
TRAINED_CHECKPOINT=/app/output/output_mcore_qwen2_pretrain

/bin/bash /app/Pai-Megatron-Patch/examples/qwen2/run_mcore_qwen.sh \
    $running \
    1.5B \
    $BATCH_SIZE \
    $GLOBAL_BATCH_SIZE \
    $LR \
    $MIN_LR \
    $SEQ_LEN \
    $PAD_LEN \
    bf16 \
    2 \
    1 \
    1 \
    1 \
    true \
    true   \
    true \
    false \
    false   \
    false \
    $SAVE_INTERVAL \
    /app/data/${DATASET}_text_document \
    /app/data/${DATASET}_text_document \
    /app/models/$MCORE_MODEL_NAME \
    $TRAIN_TOKENS_OR_ITER \
    $WARMUP_TOKENS_OR_ITERS \
    $TRAINED_CHECKPOINT
    

huggingface-cli upload viethq5/ge-tn-qwen-1.5b /app/output/output_mcore_qwen2_pretrain .