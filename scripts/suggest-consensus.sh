#!/usr/bin/env bash
# Suggest running /consensus after significant analysis or decision-making
# Triggered by PostToolUse on Write|Edit

TOOL_INPUT="${1:-}"

# Check if the written content contains decision-related keywords
if echo "$TOOL_INPUT" | grep -qiE 'decision|conclusion|root cause|recommend|should use|better than|the issue is|the problem is'; then
  echo "additionalContext: Consider running /consensus to validate this conclusion with 3 independent models."
fi
