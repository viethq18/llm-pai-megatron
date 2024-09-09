FROM nvcr.io/nvidia/pytorch:24.02-py3

WORKDIR /app

#Install flash-attention
RUN git clone -b v2.6.3 https://github.com/Dao-AILab/flash-attention.git 
RUN cd flash-attention && python setup.py install
# RUN cd flash-attention/hopper && python setup.py install

COPY ./data /app/data
COPY ./models /app/models

COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

RUN pip install git+https://github.com/NVIDIA/TransformerEngine.git@stable # Install Transformers-Engine

COPY ./Pai-Megatron-Patch /app/Pai-Megatron-Patch
COPY scripts/* /app/Pai-Megatron-Patch/

WORKDIR /app/Pai-Megatron-Patch

VOLUME [ "/app/data", "/app/models", "/app/output" ]

# Distributed training
ENV NNODES=$NNODES
ENV NPROC_PER_NODE=$NPROC_PER_NODE

# Model params
ENV MODEL_NAME=$MODEL_NAME
ENV OUTPUT_MODEL_NAME=$OUTPUT_MODEL_NAME

# Dataset
ENV DATASET=$DATASET

# Hyper parameter
ENV BATCH_SIZE=$BATCH_SIZE
ENV EPOCHS=$EPOCHS

# Logging
ENV WANDB_API_KEY=$WANDB_API_KEY
ENV WANDB_PROJECT=$WANDB_PROJECT

RUN chmod +x run_train.sh

ENTRYPOINT ["/bin/bash", "run_train.sh"]

export NNODES=2 && export NPROC_PER_NODE=1 && export MODEL_NAME=Qwen2-1.5B && export OUTPUT_MODEL_NAME=Qwen2-1.5B_viethq5 && export DATASET=imdb_data && export BATCH_SIZE=4 && export GLOBAL_BATCH_SIZE=128 && export LR=1e-4 && export MIN_LR=3e-6 && export SEQ_LEN=4096 && export PAD_LEN=0 && export SAVE_INTERVAL=10000 && export TRAIN_TOKENS_OR_ITER=50000000000 && export WARMUP_TOKENS_OR_ITERS=500000000 && export EPOCHS=3 && export WANDB_API_KEY='' && export WANDB_PROJECT='' && export HUGGINGFACE_TOKEN='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' && /bin/bash run_train.sh