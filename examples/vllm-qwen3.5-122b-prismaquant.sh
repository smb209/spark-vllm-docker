#!/bin/bash
# PROFILE: Qwen3.5-122B-A10B-PrismaQuant
# DESCRIPTION: vLLM serving Qwen3.5 PrismaQuant

vllm serve /models/rdtand-Qwen3.5-122B-A10B-PrismaQuant-4.75bit-vllm \
  --served-model-name qwen3.5-122b-prisma \
  --port 8000 \
  --host 0.0.0.0 \
  --gpu-memory-utilization-gb 96 \
  -tp 1 \
  --distributed-executor-backend ray \
  --max-model-len 131072 \
  --load-format instanttensor \
  --enable-prefix-caching \
  --enable-auto-tool-choice \
  --tool-call-parser qwen3_coder \
  --reasoning-parser qwen3 \
  --max-num-batched-tokens 16384 \
  --trust-remote-code \
  --chat-template qwen3.5-enhanced.jinja \
  --override-generation-config '{"temperature": 1.0, "top_p": 0.95, "top_k": 20, "presence_penalty": 1.5}' \
  --speculative-config '{"method": "mtp", "num_speculative_tokens": 1}'