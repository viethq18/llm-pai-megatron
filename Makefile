build:
	docker build -t tn_ge_qwen1b5:v0.0.1 .

run:
	docker run --rm -it \
		--name=pretrain_megatron_llm \
		--network host \
		--shm-size="18g" \
		--ipc host \
		--gpus '"device=0,1,2,3,4,5,6,7"' \
		-e MASTER_ADDR=127.0.0.1 \
		-e MASTER_PORT=29480 \
		-e NNODES=1 \
		-e NPROC_PER_NODE=8 \
		-e MODEL_NAME=Qwen2-1.5B \
		-e OUTPUT_MODEL_NAME=Qwen2-1.5B_viethq5 \
		-e DATASET=vi_zh_novels-HuggingFaceTokenizer \
		-e BATCH_SIZE=4 \
		-e GLOBAL_BATCH_SIZE=128 \
		-e LR=1e-4 \
		-e MIN_LR=3e-6 \
		-e SEQ_LEN=4096 \
		-e PAD_LEN=0 \
		-e SAVE_INTERVAL=10000 \
		-e TRAIN_TOKENS_OR_ITER=50000000000 \
		-e WARMUP_TOKENS_OR_ITERS=500000000 \
		-e EPOCHS=3 \
		-e WANDB_API_KEY='' \
		-e WANDB_PROJECT='' \
		-e HUGGINGFACE_TOKEN='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' \
		-v ./output:/app/output \
		viethq188/ge_tn_qwen1b5:v0.0.1 \
		bash


run_base:
	docker run --rm -it \
	-v /data/viethq5/training-pipeline:/app/training-pipeline \
	nvcr.io/nvidia/pytorch:24.02-py3 \
	bash


export NNODES=2 && export HUGGINGFACE_TOKEN=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 && export NPROC_PER_NODE=2 && export MODEL_NAME=Qwen2-1.5B && export OUTPUT_MODEL_NAME=Qwen2-1.5B_viethq5 && export DATASET=vi_zh_novels-HuggingFaceTokenizer && export BATCH_SIZE=2 && export GLOBAL_BATCH_SIZE=128 && export EPOCHS=3 && export LR=1e-4 && export MIN_LR=3e-6 && export SEQ_LEN=4096 && export PAD_LEN=0 && export SAVE_INTERVAL=10000 && export TRAIN_TOKENS_OR_ITER=50000000000 && export WARMUP_TOKENS_OR_ITERS=500000000 &&  export WANDB_API_KEY='' && export WANDB_PROJECT='' && /bin/bash run_train.sh