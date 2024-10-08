#!/bin/bash

huggingface-cli login --token $HUGGINGFACE_TOKEN

/bin/bash convert_hf2mcore.sh
ls models/

echo "Convert DONE"

if [ "${NNODES:-0}" -gt 1 ]; then
    running="dlc"
else
    running="dsw"
fi

MCORE_MODEL_NAME=$MODEL_NAME-hf-to-mcore-te-tp$NPROC_PER_NODE-pp$NNODES
TRAINED_CHECKPOINT=output/output_mcore_qwen2_pretrain

/bin/bash examples/qwen2/run_mcore_qwen.sh \
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
    data/${DATASET}_text_document \
    data/${DATASET}_text_document \
    models/$MCORE_MODEL_NAME \
    $TRAIN_TOKENS_OR_ITER \
    $WARMUP_TOKENS_OR_ITERS \
    $TRAINED_CHECKPOINT
    