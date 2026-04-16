#!/bin/bash
set -e
echo "Upgrading transformers to 5.x..."
pip install -q --upgrade "transformers>=5.0.0"
echo "Transformers version: $(python3 -c 'import transformers; print(transformers.__version__)')"
