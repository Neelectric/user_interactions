#!/usr/bin/env bash
set -euo pipefail

for R in 64 128 256 512; do
  echo "===== LoRA r=$R ====="
  LORA_R=$R \
  TRAIN_JSONL=./data/tldr_prompts_unique/train.jsonl \
  VAL_JSONL=./data/tldr_prompts_unique/validation.jsonl \
  OUTPUT_DIR=./runs/lora_${R}_online_sdpo_tldr/ \
  bash scripts/train_online_sdpo_tldr.sh
done

DATA_PATH=./data/tldr_prompts_unique/validation.jsonl

for R in 64 128 256 512; do
  if [[ "$R" -eq 0 ]]; then
    RUN_DIR=./runs/default_online_sdpo_tldr/
    TAG=vanilla
  else
    RUN_DIR=./runs/lora_${R}_online_sdpo_tldr/
    TAG=lora_r${R}
  fi

  echo "===== Eval: $TAG (RUN_DIR=$RUN_DIR) ====="

  RUN_DIR=$RUN_DIR \
  DATA_PATH=$DATA_PATH \
  RUN_TAG=$TAG \
  RUN_ID="eval-tldr-${TAG}" \
  MODEL_NAME_OR_PATH=Qwen/Qwen3-4B \
  bash scripts/eval_checkpoints_tldr.sh
done