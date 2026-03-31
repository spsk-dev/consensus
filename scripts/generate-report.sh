#!/usr/bin/env bash
set -uo pipefail

# SpSk Consensus — HTML Report Generator
# Reads consensus-state.json, produces self-contained HTML.
# Zero npm dependencies. Requires: jq.

if ! command -v jq &>/dev/null; then
  echo "ERROR: jq required. Install: brew install jq (macOS) or apt install jq (Linux)" >&2
  exit 1
fi

# --- Args ---
if [[ "${1:-}" == "--help" || "${1:-}" == "-h" || -z "${1:-}" ]]; then
  echo "Usage: generate-report.sh <consensus-state.json> [output.html]"
  exit 0
fi

STATE_FILE="$1"
[[ -f "$STATE_FILE" ]] || { echo "ERROR: File not found: $STATE_FILE" >&2; exit 1; }
jq empty "$STATE_FILE" 2>/dev/null || { echo "ERROR: Invalid JSON: $STATE_FILE" >&2; exit 1; }

if [[ -n "${2:-}" ]]; then
  OUTPUT_HTML="$2"
else
  INPUT_DIR="$(cd "$(dirname "$STATE_FILE")" && pwd)"
  OUTPUT_HTML="${INPUT_DIR}/consensus-report.html"
fi

# --- Extract data ---
CONCLUSION=$(jq -r '.conclusion // "N/A"' "$STATE_FILE")
TYPE=$(jq -r '.type // "general"' "$STATE_FILE")
MODEL_CONFIG=$(jq -r '.model_config // "unknown"' "$STATE_FILE")
CONFIDENCE=$(jq -r '.consensus_confidence // 0' "$STATE_FILE")
VERDICT=$(jq -r '.verdict // "N/A"' "$STATE_FILE")
RECOMMENDATION=$(jq -r '.recommendation // ""' "$STATE_FILE")
DISAGREEMENT=$(jq -r '.disagreement_flag // false' "$STATE_FILE")
VALIDATOR_COUNT=$(jq '.validators | length' "$STATE_FILE")

# Verdict CSS class
case "$VERDICT" in
  HIGH_CONFIDENCE) V_CLASS="verdict-high" ;;
  MODERATE_CONFIDENCE) V_CLASS="verdict-moderate" ;;
  LOW_CONFIDENCE) V_CLASS="verdict-low" ;;
  NO_CONSENSUS) V_CLASS="verdict-none" ;;
  *) V_CLASS="" ;;
esac

# Confidence bar (10 blocks)
FILLED=$(echo "$CONFIDENCE" | awk '{printf "%d", $1 + 0.5}')
BAR=""
for ((k=0; k<10; k++)); do
  if [[ $k -lt $FILLED ]]; then BAR="${BAR}█"; else BAR="${BAR}░"; fi
done

# --- Generate HTML ---
{
cat <<'HTML_HEAD'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
HTML_HEAD

echo "  <title>SpSk Consensus — ${TYPE^} Validation</title>"

cat <<'STYLE'
  <style>
    :root {
      --bg: #18181b; --surface: #27272a; --border: #3f3f46;
      --text: #fafafa; --text-muted: #a1a1aa;
      --high: #22c55e; --moderate: #eab308; --low: #f97316; --none: #ef4444;
      --accent: #3b82f6;
    }
    @media (prefers-color-scheme: light) {
      :root {
        --bg: #fafafa; --surface: #ffffff; --border: #e4e4e7;
        --text: #18181b; --text-muted: #71717a;
      }
    }
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; background: var(--bg); color: var(--text); line-height: 1.6; max-width: 800px; margin: 0 auto; padding: 2rem 1rem; }
    .header { text-align: center; margin-bottom: 2rem; }
    .signature { font-family: monospace; font-size: 0.85rem; color: var(--text-muted); margin-bottom: 0.5rem; }
    .conclusion { font-size: 1.2rem; font-style: italic; margin: 1rem 0; padding: 1rem 1.5rem; border-left: 3px solid var(--accent); background: var(--surface); border-radius: 6px; }
    .verdict-badge { display: inline-block; padding: 4px 16px; border-radius: 4px; font-weight: 700; font-size: 0.9rem; margin: 0.5rem 0; }
    .verdict-high { background: var(--high); color: #000; }
    .verdict-moderate { background: var(--moderate); color: #000; }
    .verdict-low { background: var(--low); color: #000; }
    .verdict-none { background: var(--none); color: #fff; }
    .score-display { font-family: monospace; font-size: 1.5rem; margin: 1rem 0; }
    .score-bar { letter-spacing: 2px; }
    section { margin: 1.5rem 0; }
    h2 { font-size: 1.1rem; color: var(--text-muted); text-transform: uppercase; letter-spacing: 0.05em; border-bottom: 1px solid var(--border); padding-bottom: 0.5rem; margin-bottom: 1rem; }
    .validator-card { background: var(--surface); border: 1px solid var(--border); border-radius: 8px; padding: 1rem; margin-bottom: 0.75rem; }
    .validator-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.5rem; }
    .validator-name { font-weight: 600; }
    .validator-model { font-size: 0.8rem; color: var(--text-muted); }
    .validator-confidence { font-family: monospace; font-size: 1.1rem; }
    .validator-finding { font-size: 0.9rem; color: var(--text-muted); }
    details { margin-bottom: 0.5rem; }
    details summary { cursor: pointer; padding: 0.5rem; background: var(--surface); border: 1px solid var(--border); border-radius: 6px; font-size: 0.9rem; list-style: none; }
    details summary::-webkit-details-marker { display: none; }
    details summary::before { content: "▸ "; }
    details[open] summary::before { content: "▾ "; }
    details .detail-body { padding: 0.75rem; font-size: 0.9rem; }
    ul { padding-left: 1.5rem; }
    li { margin-bottom: 0.5rem; font-size: 0.9rem; }
    .recommendation { padding: 1rem; background: var(--surface); border: 1px solid var(--border); border-radius: 8px; font-size: 0.95rem; }
    .disagreement-flag { color: var(--low); font-weight: 600; font-size: 0.85rem; }
    .footer { text-align: center; margin-top: 2rem; padding-top: 1rem; border-top: 1px solid var(--border); font-size: 0.85rem; color: var(--text-muted); }
    .footer a { color: var(--text-muted); text-decoration: none; }
    @media print {
      body { max-width: 100%; padding: 1rem; }
      .verdict-badge { -webkit-print-color-adjust: exact; print-color-adjust: exact; }
    }
  </style>
</head>
<body>
STYLE

# Header
echo '  <div class="header">'
echo "    <div class=\"signature\">SpSk  consensus  v2.1.0  ───  ${TYPE^}  ·  ${MODEL_CONFIG}</div>"
echo "    <div class=\"score-display\"><span class=\"score-bar\">${BAR}</span> ${CONFIDENCE}/10</div>"
echo "    <span class=\"verdict-badge ${V_CLASS}\">${VERDICT//_/ }</span>"
if [[ "$DISAGREEMENT" == "true" ]]; then
  echo '    <div class="disagreement-flag">⚠ Validators disagree by >3 points</div>'
fi
echo '  </div>'

# Conclusion
echo '  <div class="conclusion">'
echo "    ${CONCLUSION}"
echo '  </div>'

# Validator verdicts
echo '  <section>'
echo '    <h2>Validator Verdicts</h2>'
for ((i=0; i<VALIDATOR_COUNT; i++)); do
  V_NAME=$(jq -r ".validators[$i].validator // \"unknown\"" "$STATE_FILE")
  V_MODEL=$(jq -r ".validators[$i].model // \"unknown\"" "$STATE_FILE")
  V_CONF=$(jq -r ".validators[$i].confidence // 0" "$STATE_FILE")
  V_FINDING=$(jq -r ".validators[$i].key_finding // \"\"" "$STATE_FILE")
  V_JUSTIFY=$(jq -r ".validators[$i].confidence_justification // \"\"" "$STATE_FILE")
  CLAIMS_COUNT=$(jq ".validators[$i].claims | length" "$STATE_FILE")
  COUNTER_COUNT=$(jq ".validators[$i].counter_arguments | length // 0" "$STATE_FILE" 2>/dev/null || echo 0)
  GAPS_COUNT=$(jq ".validators[$i].gaps | length // 0" "$STATE_FILE" 2>/dev/null || echo 0)

  # Label
  case "$V_NAME" in
    deep_verifier) LABEL="Deep Verifier" ;;
    devils_advocate) LABEL="Devil's Advocate" ;;
    scope_analyst) LABEL="Scope Analyst" ;;
    *) LABEL="$V_NAME" ;;
  esac

  # Confidence bar for validator
  VF=$(echo "$V_CONF" | awk '{printf "%d", $1 + 0.5}')
  VBAR=""
  for ((k=0; k<10; k++)); do
    if [[ $k -lt $VF ]]; then VBAR="${VBAR}█"; else VBAR="${VBAR}░"; fi
  done

  echo "    <div class=\"validator-card\">"
  echo "      <div class=\"validator-header\">"
  echo "        <span class=\"validator-name\">${LABEL}</span>"
  echo "        <span class=\"validator-model\">${V_MODEL}</span>"
  echo "      </div>"
  echo "      <div class=\"validator-confidence\">${VBAR} ${V_CONF}/10</div>"
  echo "      <div class=\"validator-finding\">${V_FINDING}</div>"

  # Expandable details
  if [[ -n "$V_JUSTIFY" && "$V_JUSTIFY" != "null" ]]; then
    echo "      <details>"
    echo "        <summary>Justification &amp; Claims (${CLAIMS_COUNT})</summary>"
    echo "        <div class=\"detail-body\">"
    echo "          <p>${V_JUSTIFY}</p>"
    if [[ "$CLAIMS_COUNT" -gt 0 ]]; then
      echo "          <ul>"
      for ((j=0; j<CLAIMS_COUNT; j++)); do
        CLAIM=$(jq -r ".validators[$i].claims[$j].claim" "$STATE_FILE")
        STATUS=$(jq -r ".validators[$i].claims[$j].status" "$STATE_FILE")
        echo "            <li><strong>[${STATUS}]</strong> ${CLAIM}</li>"
      done
      echo "          </ul>"
    fi
    echo "        </div>"
    echo "      </details>"
  fi
  echo "    </div>"
done
echo '  </section>'

# Confirmed
CONFIRMED_COUNT=$(jq '.confirmed | length' "$STATE_FILE")
if [[ "$CONFIRMED_COUNT" -gt 0 ]]; then
  echo '  <section>'
  echo '    <h2>Confirmed by All</h2>'
  echo '    <ul>'
  for ((i=0; i<CONFIRMED_COUNT; i++)); do
    ITEM=$(jq -r ".confirmed[$i]" "$STATE_FILE")
    echo "      <li>✓ ${ITEM}</li>"
  done
  echo '    </ul>'
  echo '  </section>'
fi

# Disputed
DISPUTED_COUNT=$(jq '.disputed | length' "$STATE_FILE")
if [[ "$DISPUTED_COUNT" -gt 0 ]]; then
  echo '  <section>'
  echo '    <h2>Disputed or Unconfirmed</h2>'
  echo '    <ul>'
  for ((i=0; i<DISPUTED_COUNT; i++)); do
    CLAIM=$(jq -r ".disputed[$i].claim // .disputed[$i]" "$STATE_FILE")
    echo "      <li>⚠ ${CLAIM}</li>"
  done
  echo '    </ul>'
  echo '  </section>'
fi

# New findings
NF_COUNT=$(jq '.new_findings | length' "$STATE_FILE")
if [[ "$NF_COUNT" -gt 0 ]]; then
  echo '  <section>'
  echo '    <h2>New Findings</h2>'
  echo '    <ul>'
  for ((i=0; i<NF_COUNT; i++)); do
    ITEM=$(jq -r ".new_findings[$i]" "$STATE_FILE")
    echo "      <li>${ITEM}</li>"
  done
  echo '    </ul>'
  echo '  </section>'
fi

# Gaps
GAPS_COUNT=$(jq '.gaps | length' "$STATE_FILE")
if [[ "$GAPS_COUNT" -gt 0 ]]; then
  echo '  <section>'
  echo '    <h2>Gaps Requiring Investigation</h2>'
  echo '    <ul>'
  for ((i=0; i<GAPS_COUNT; i++)); do
    ITEM=$(jq -r ".gaps[$i]" "$STATE_FILE")
    echo "      <li>${ITEM}</li>"
  done
  echo '    </ul>'
  echo '  </section>'
fi

# Recommendation
if [[ -n "$RECOMMENDATION" && "$RECOMMENDATION" != "null" ]]; then
  echo '  <section>'
  echo '    <h2>Recommendation</h2>'
  echo "    <div class=\"recommendation\">${RECOMMENDATION}</div>"
  echo '  </section>'
fi

# Footer
echo '  <div class="footer">'
echo '    <a href="https://github.com/spsk-dev/consensus">github.com/spsk-dev/consensus</a>'
echo '  </div>'

echo '</body>'
echo '</html>'
} > "$OUTPUT_HTML"

FILE_SIZE=$(wc -c < "$OUTPUT_HTML" | tr -d ' ')
FILE_SIZE_KB=$((FILE_SIZE / 1024))
echo ""
echo "SpSk  generate-report  v2.1.0"
echo "Report generated: ${OUTPUT_HTML}"
echo "Size: ${FILE_SIZE_KB}KB"
echo ""
