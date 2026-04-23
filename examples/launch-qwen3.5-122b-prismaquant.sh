#!/bin/bash
# PROFILE: Qwen3.5-122B-A10B-PrismaQuant Launcher
# DESCRIPTION: launch-cluster wrapper using --launch-script in daemon mode

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LAUNCH_SCRIPT="$SCRIPT_DIR/examples/vllm-qwen3.5-122b-prismaquant.sh"

"$SCRIPT_DIR/launch-cluster.sh" \
  -t vllm-node \
  --apply-mod "$SCRIPT_DIR/mods/drop-caches" \
  --apply-mod "$SCRIPT_DIR/mods/fix-qwen3.5-chat-template-enhanced" \
  --apply-mod "$SCRIPT_DIR/mods/gpu-mem-util-gb" \
  --launch-script "$LAUNCH_SCRIPT" \
  -d \
  "$@"
