#!/bin/bash
set -e
cp chat_template.jinja $WORKSPACE_DIR/qwen3.5-enhanced.jinja
chmod 644 $WORKSPACE_DIR/qwen3.5-enhanced.jinja
echo "=======> to apply chat template, use --chat-template qwen3.5-enhanced.jinja"
