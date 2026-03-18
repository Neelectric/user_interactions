#!/usr/bin/env bash
set -euo pipefail

DATA_PATH=./data/tldr_prompts_unique/validation.jsonl

for R in 0 8 16 32; do
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