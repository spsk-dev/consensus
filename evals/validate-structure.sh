#!/usr/bin/env bash
set -uo pipefail

# SpSk Consensus — Structural Validator
# Validates plugin structure without requiring Claude Code.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$REPO_ROOT"

PASS=0
FAIL=0

check() {
  local label="$1"
  shift
  if "$@" >/dev/null 2>&1; then
    echo "[PASS] $label"
    PASS=$((PASS + 1))
  else
    echo "[FAIL] $label"
    FAIL=$((FAIL + 1))
  fi
}

# Plugin manifest
check "plugin.json exists" test -f .claude-plugin/plugin.json
check "plugin.json is valid JSON" jq empty .claude-plugin/plugin.json
check "plugin.json has name field" jq -e '.name' .claude-plugin/plugin.json
check "plugin.json has version field" jq -e '.version' .claude-plugin/plugin.json
check "plugin.json name is consensus" bash -c "jq -r '.name' .claude-plugin/plugin.json | grep -q '^consensus$'"

# Command file
check "commands/consensus.md exists" test -f commands/consensus.md
check "commands/consensus.md has frontmatter" bash -c "head -1 commands/consensus.md | grep -q '^---'"
check "commands/consensus.md has description" grep -q '^description:' commands/consensus.md

# Consensus command structure
check "consensus.md has Phase 0 (Parse Input)" grep -q "Phase 0" commands/consensus.md
check "consensus.md has Phase 1 (Pre-flight)" grep -q "Phase 1" commands/consensus.md
check "consensus.md has Phase 2 (Dispatch)" grep -q "Phase 2" commands/consensus.md
check "consensus.md has Phase 3 (Synthesize)" grep -q "Phase 3" commands/consensus.md
check "consensus.md references 3 validators" grep -q "Deep Verifier" commands/consensus.md
check "consensus.md references Devil's Advocate" grep -q "Devil's Advocate" commands/consensus.md
check "consensus.md references Scope Analyst" grep -q "Scope Analyst" commands/consensus.md
check "consensus.md has confidence scoring" grep -q "1-10" commands/consensus.md
check "consensus.md references shared/output.md" grep -q "shared/output.md" commands/consensus.md

# Shared output
check "shared/output.md exists" test -f shared/output.md
check "shared/output.md contains SpSk" grep -q "SpSk" shared/output.md
check "shared/output.md contains footer" grep -q "github.com/spsk-dev/consensus" shared/output.md
check "shared/output.md has score display" grep -q "/10" shared/output.md

# Config
check "config/scoring.json is valid JSON" jq empty config/scoring.json
check "scoring.json has scale" jq -e '.scale' config/scoring.json
check "scoring.json has verdicts" jq -e '.verdicts' config/scoring.json
check "scoring.json has 4 verdict levels" bash -c "jq '.verdicts | length' config/scoring.json | grep -q '^4$'"
check "scoring.json scale max is 10" bash -c "jq '.scale.max' config/scoring.json | grep -q '^10$'"
check "scoring.json has validators" jq -e '.validators' config/scoring.json
check "scoring.json has 3 validators" bash -c "jq '.validators | length' config/scoring.json | grep -q '^3$'"

# Skill
check "skills/consensus/SKILL.md exists" test -f skills/consensus/SKILL.md
check "skills/consensus/SKILL.md has frontmatter" bash -c "head -1 skills/consensus/SKILL.md | grep -q '^---'"

# References
check "validation-patterns.md exists" test -f skills/consensus/references/validation-patterns.md
check "validation-patterns.md covers architecture" grep -q "Architecture" skills/consensus/references/validation-patterns.md
check "validation-patterns.md covers code" grep -q "Code" skills/consensus/references/validation-patterns.md
check "validation-patterns.md covers design" grep -q "Design" skills/consensus/references/validation-patterns.md
check "validation-patterns.md covers strategy" grep -q "Strategy" skills/consensus/references/validation-patterns.md
check "validation-patterns.md covers incident" grep -q "Incident" skills/consensus/references/validation-patterns.md

# Hooks
check "hooks/hooks.json is valid JSON" jq empty hooks/hooks.json
check "hooks/hooks.json has PostToolUse" jq -e '.hooks.PostToolUse' hooks/hooks.json

# Scripts
check "scripts/suggest-consensus.sh is executable" test -x scripts/suggest-consensus.sh

# VERSION
check "VERSION file exists" test -f VERSION
check "VERSION matches semver" bash -c "grep -qE '^[0-9]+\.[0-9]+\.[0-9]+$' VERSION"

# Root files
for f in README.md CLAUDE.md LICENSE; do
  check "$f exists" test -f "$f"
done

# ARCHITECTURE.md
check "ARCHITECTURE.md exists" test -f ARCHITECTURE.md
check "ARCHITECTURE.md covers 3 validators" grep -q "Three Validators" ARCHITECTURE.md
check "ARCHITECTURE.md has file map" grep -q "File Map" ARCHITECTURE.md
check "ARCHITECTURE.md has design decisions" grep -q "Design Decisions" ARCHITECTURE.md

# Eval fixtures
check "strong-conclusion fixture exists" test -f evals/fixtures/strong-conclusion.md
check "weak-conclusion fixture exists" test -f evals/fixtures/weak-conclusion.md
check "gray-area-conclusion fixture exists" test -f evals/fixtures/gray-area-conclusion.md
check "assertions.json exists" test -f evals/assertions.json
check "assertions.json is valid JSON" jq empty evals/assertions.json
ASSERTION_COUNT=$(jq '.assertions | length' evals/assertions.json)
check "assertions.json has 10 assertions" test "$ASSERTION_COUNT" -eq 10
check "assertions.json has verdict type" jq -e '[.assertions[] | select(.type == "verdict")] | length > 0' evals/assertions.json
check "assertions.json has score type" jq -e '[.assertions[] | select(.type == "score")] | length > 0' evals/assertions.json
check "assertions.json has ranking type" jq -e '[.assertions[] | select(.type == "ranking")] | length > 0' evals/assertions.json

# Output schema
check "output-schema.json has validator_output" jq -e '.validator_output' config/output-schema.json
check "output-schema.json has consensus_report" jq -e '.consensus_report' config/output-schema.json

# Install script
check "install.sh is executable" test -x install.sh

# No hardcoded paths
HARDCODED=$(grep -rn "/Users/" --include='*.md' --include='*.json' --include='*.sh' --exclude-dir=.git --exclude-dir=.planning --exclude-dir=evals . 2>/dev/null || true)
check "No hardcoded user paths" test -z "$HARDCODED"

echo ""
TOTAL=$((PASS + FAIL))
echo "$PASS/$TOTAL checks passed"

if [ "$FAIL" -gt 0 ]; then
  exit 1
fi
exit 0
