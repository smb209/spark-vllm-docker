#!/bin/bash
set -e

SERVING_CHAT="/usr/local/lib/python3.12/dist-packages/vllm/entrypoints/openai/serving_chat.py"

echo "Patching harmony_parser.process() error handling in serving_chat.py..."

if grep -q "HarmonyError" "$SERVING_CHAT"; then
    echo "Already patched, skipping."
    exit 0
fi

python3 << 'PYEOF'
path = "/usr/local/lib/python3.12/dist-packages/vllm/entrypoints/openai/serving_chat.py"

with open(path, "r") as f:
    lines = f.readlines()

new_lines = []
i = 0
patched = False
while i < len(lines):
    line = lines[i]
    stripped = line.rstrip()
    # Find the exact line
    if not patched and stripped.endswith("harmony_parser.process(token_id)"):
        indent = len(line) - len(line.lstrip())
        pad = " " * indent
        new_lines.append(pad + "try:\n")
        new_lines.append(pad + "    harmony_parser.process(token_id)\n")
        new_lines.append(pad + "except Exception as _harmony_err:\n")
        new_lines.append(pad + "    import logging as _log\n")
        new_lines.append(pad + "    _log.getLogger(__name__).warning(\n")
        new_lines.append(pad + "        'HarmonyError on token %s, reinitializing parser: %s',\n")
        new_lines.append(pad + "        token_id, _harmony_err)\n")
        new_lines.append(pad + "    from openai_harmony import StreamableParser as _SP\n")
        new_lines.append(pad + "    harmony_parser = _SP(harmony_parser._encoding, harmony_parser._role)\n")
        patched = True
        i += 1
        continue
    new_lines.append(line)
    i += 1

if not patched:
    print("ERROR: Could not find target line. Check vLLM version.")
    exit(1)

with open(path, "w") as f:
    f.writelines(new_lines)

print("Patch applied successfully.")
PYEOF