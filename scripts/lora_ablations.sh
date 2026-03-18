#!/usr/bin/env bash
set -euo pipefail

EVAL_OUT=./eval_results
mkdir -p "$EVAL_OUT"

for R in 64 128 256 512 1024 2048; do
  echo "===== LoRA r=$R: Train ====="
  LORA_R=$R \
  TRAIN_JSONL=./data/tldr_prompts_unique/train.jsonl \
  VAL_JSONL=./data/tldr_prompts_unique/validation.jsonl \
  OUTPUT_DIR=./runs/lora_${R}_online_sdpo_tldr/ \
  bash scripts/train_online_sdpo_tldr.sh

  echo "===== LoRA r=$R: Eval ====="
  RUN_DIR=./runs/lora_${R}_online_sdpo_tldr/ \
  DATA_PATH=./data/tldr_prompts_unique/validation.jsonl \
  RUN_TAG=lora_r${R} \
  RUN_ID=eval-tldr-lora_r${R} \
  OUT_DIR=$EVAL_OUT \
  MODEL_NAME_OR_PATH=Qwen/Qwen3-4B \
  bash scripts/eval_checkpoints_tldr.sh
done