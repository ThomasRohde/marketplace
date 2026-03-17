#!/usr/bin/env python3
"""Grade an EAROS rubric YAML file against the standard assertions."""

import sys
import json
import yaml
from pathlib import Path


def grade(yaml_path: str, eval_name: str) -> dict:
    results = []
    data = None
    valid_yaml = False

    # 1. Valid YAML
    try:
        with open(yaml_path, 'r', encoding='utf-8') as f:
            data = yaml.safe_load(f)
        valid_yaml = data is not None and isinstance(data, dict)
        results.append({"text": "Output is valid YAML", "passed": valid_yaml, "evidence": "Parsed successfully" if valid_yaml else "Failed to parse"})
    except Exception as e:
        results.append({"text": "Output is valid YAML", "passed": False, "evidence": str(e)})
        # Can't check anything else
        for i in range(14):
            results.append({"text": f"Assertion {i+2}", "passed": False, "evidence": "YAML parse failed"})
        return {"expectations": results}

    # 2. Has rubric_id
    has_id = "rubric_id" in data
    results.append({"text": "Contains rubric_id field", "passed": has_id, "evidence": f"rubric_id: {data.get('rubric_id', 'MISSING')}"})

    # 3. Has version
    has_ver = "version" in data
    results.append({"text": "Contains version field", "passed": has_ver, "evidence": f"version: {data.get('version', 'MISSING')}"})

    # 4. Has kind
    kind = data.get("kind", "")
    has_kind = kind in ("profile", "overlay", "core_rubric")
    results.append({"text": "Contains kind field set to 'profile' or 'overlay'", "passed": has_kind, "evidence": f"kind: {kind or 'MISSING'}"})

    # 5. Correct kind for eval
    if eval_name == "regulatory-overlay":
        correct_kind = kind == "overlay"
        expected = "overlay"
    else:
        correct_kind = kind == "profile"
        expected = "profile"
    results.append({"text": f"kind is '{expected}'", "passed": correct_kind, "evidence": f"kind: {kind}, expected: {expected}"})

    # 6. Inherits from EAROS-CORE-001
    inherits = data.get("inherits", [])
    if isinstance(inherits, list):
        has_inherit = any("EAROS-CORE" in str(i) for i in inherits)
    else:
        has_inherit = "EAROS-CORE" in str(inherits)
    results.append({"text": "Inherits from EAROS-CORE-001", "passed": has_inherit, "evidence": f"inherits: {inherits}"})

    # 7. Has dimensions
    dims = data.get("dimensions", [])
    has_dims = isinstance(dims, list) and len(dims) >= 1
    results.append({"text": "Contains dimensions array with >= 1 entry", "passed": has_dims, "evidence": f"{len(dims) if isinstance(dims, list) else 0} dimensions found"})

    # Collect all criteria
    all_criteria = []
    if isinstance(dims, list):
        for dim in dims:
            if isinstance(dim, dict):
                for c in dim.get("criteria", []):
                    if isinstance(c, dict):
                        all_criteria.append(c)

    # 8. Every criterion has question
    if all_criteria:
        has_q = all(("question" in c) for c in all_criteria)
        missing = [c.get("id", "?") for c in all_criteria if "question" not in c]
    else:
        has_q = False
        missing = ["no criteria found"]
    results.append({"text": "Every criterion has 'question' field", "passed": has_q, "evidence": f"Missing in: {missing}" if not has_q else f"All {len(all_criteria)} criteria have questions"})

    # 9. Every criterion has required_evidence
    if all_criteria:
        has_ev = all(("required_evidence" in c) for c in all_criteria)
        missing = [c.get("id", "?") for c in all_criteria if "required_evidence" not in c]
    else:
        has_ev = False
        missing = ["no criteria found"]
    results.append({"text": "Every criterion has 'required_evidence'", "passed": has_ev, "evidence": f"Missing in: {missing}" if not has_ev else f"All {len(all_criteria)} criteria have required_evidence"})

    # 10. Every criterion has scoring_guide with 0-4
    def has_full_guide(c):
        sg = c.get("scoring_guide", {})
        if not isinstance(sg, dict):
            return False
        keys = set(str(k) for k in sg.keys())
        return all(str(i) in keys for i in range(5))

    if all_criteria:
        has_sg = all(has_full_guide(c) for c in all_criteria)
        missing = [c.get("id", "?") for c in all_criteria if not has_full_guide(c)]
    else:
        has_sg = False
        missing = ["no criteria found"]
    results.append({"text": "Every criterion has scoring_guide with 0-4", "passed": has_sg, "evidence": f"Missing/incomplete in: {missing}" if not has_sg else f"All {len(all_criteria)} have full 0-4 guides"})

    # 11. Every criterion has anti_patterns
    if all_criteria:
        has_ap = all(("anti_patterns" in c) for c in all_criteria)
        missing = [c.get("id", "?") for c in all_criteria if "anti_patterns" not in c]
    else:
        has_ap = False
        missing = ["no criteria found"]
    results.append({"text": "Every criterion has 'anti_patterns'", "passed": has_ap, "evidence": f"Missing in: {missing}" if not has_ap else f"All {len(all_criteria)} have anti_patterns"})

    # 12. At least one gate
    def is_gate(c):
        g = c.get("gate", False)
        if isinstance(g, dict):
            return g.get("enabled", False) or "severity" in g
        return False

    has_gate = any(is_gate(c) for c in all_criteria) if all_criteria else False
    gate_ids = [c.get("id", "?") for c in all_criteria if is_gate(c)]
    results.append({"text": "At least one criterion uses a gate", "passed": has_gate, "evidence": f"Gates: {gate_ids}" if has_gate else "No gates found"})

    # 13. Has scoring section
    scoring = data.get("scoring", {})
    has_scoring = isinstance(scoring, dict) and "method" in scoring and "thresholds" in scoring
    results.append({"text": "Contains scoring section with method and thresholds", "passed": has_scoring, "evidence": f"method: {scoring.get('method', 'MISSING')}, thresholds: {'present' if 'thresholds' in scoring else 'MISSING'}"})

    # 14. Has outputs section
    outputs = data.get("outputs", {})
    has_outputs = (isinstance(outputs, dict) and
                   outputs.get("require_evidence_refs") is not None and
                   outputs.get("require_confidence") is not None and
                   outputs.get("require_actions") is not None)
    results.append({"text": "Contains outputs section with evidence/confidence/actions flags", "passed": has_outputs, "evidence": f"require_evidence_refs: {outputs.get('require_evidence_refs', 'MISSING')}, require_confidence: {outputs.get('require_confidence', 'MISSING')}, require_actions: {outputs.get('require_actions', 'MISSING')}"})

    # 15. Eval-specific: criteria count or artifact_type
    if eval_name == "regulatory-overlay":
        at = data.get("artifact_type", "")
        is_any = str(at).lower() == "any"
        results.append({"text": "artifact_type is 'any'", "passed": is_any, "evidence": f"artifact_type: {at}"})
    else:
        count = len(all_criteria)
        lean = count <= 12
        results.append({"text": "No more than 12 profile-specific criteria", "passed": lean, "evidence": f"{count} criteria found"})

    return {"expectations": results}


if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: grade_rubric.py <yaml_path> <eval_name>")
        sys.exit(1)

    yaml_path = sys.argv[1]
    eval_name = sys.argv[2]
    result = grade(yaml_path, eval_name)

    # Print summary
    passed = sum(1 for e in result["expectations"] if e["passed"])
    total = len(result["expectations"])
    print(f"\n{'='*60}")
    print(f"GRADE: {passed}/{total} assertions passed")
    print(f"{'='*60}")
    for e in result["expectations"]:
        status = "PASS" if e["passed"] else "FAIL"
        print(f"  [{status}] {e['text']}")
        print(f"         {e['evidence']}")

    # Output JSON
    print(f"\n--- JSON ---")
    print(json.dumps(result, indent=2))
