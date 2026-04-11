#!/usr/bin/env python3
"""Compute governance health metrics for eco-v0.6."""
import argparse
import json
import re
from datetime import datetime, timezone
from pathlib import Path

REQUIRED_FILES = [
    'enforcement.yaml',
    'governance-hash.yaml',
    'audit-log.md',
    'change-ledger.md',
    'passchangelog.md',
    'agent-log.md',
    'sku-inheritance.yaml',
]

AUDIT_MARKERS = [
    '## Audit Entries',
    'time.loc',
    'actor:',
    'action:',
    'reason:',
    'affected_files:',
    'confirmation:',
]
LEDGER_MARKERS = [
    '## Change History',
    'change_id:',
    'timestamp:',
    'actor:',
    'change_type:',
    'description:',
    'confirmation:',
]
AGENT_MARKERS = [
    '## Agent Suggestions',
    '## Agent Actions',
    '## Agent Stalls',
    '## Agent Handoffs',
    '## time.loc stamps',
    '## Actor Attribution',
    '## Confirmations',
]
DEVPATH_MARKERS = [
    '## Governance State Hash',
    'state_hash:',
    'passchangelog enforcement',
    'agent logging enforcement',
]
SKU_REQUIRED_FIELDS = [
    'sku_metadata:',
    'completeness',
    'readiness',
    'inheritance',
    'required_templates',
    'required_rules',
]


def parse_args():
    parser = argparse.ArgumentParser(description='Compute governance health for eco-v0.6.')
    parser.add_argument('--output', default='health-report.json', help='Health report output path')
    return parser.parse_args()


def read_text(path: Path):
    return path.read_text(encoding='utf-8') if path.exists() else ''


def score_presence(files):
    present = sum(1 for path in files if path.exists())
    return int((present / len(files)) * 100) if files else 0


def score_markers(text, markers):
    found = sum(1 for marker in markers if marker in text)
    return int((found / len(markers)) * 100) if markers else 0


def score_enforcement_strength(eco_dir: Path):
    path = eco_dir / 'enforcement.yaml'
    text = read_text(path)
    required = [
        'mode: "hard"',
        'block_on_snapshot_drift: true',
        'block_on_missing_snapshot_metadata: true',
        'block_on_invalid_snapshot_integrity: true',
        'snapshots_required_in_ci: true',
        'block_on_ci_snapshot_failure: true',
        'block_on_ci_snapshot_mismatch: true',
        'health_required: true',
        'block_on_low_health: true',
        'minimum_health_score: 80',
    ]
    found = sum(1 for marker in required if marker in text)
    return int((found / len(required)) * 100)


def parse_snapshot_timestamp(snapshot_dir: Path):
    metadata = snapshot_dir / 'snapshot.json'
    if not metadata.exists():
        return None
    data = json.loads(metadata.read_text(encoding='utf-8'))
    timestamp = data.get('timestamp')
    if not timestamp:
        return None
    try:
        return datetime.fromisoformat(timestamp.replace('Z', '+00:00'))
    except ValueError:
        return None


def score_snapshot_freshness(eco_dir: Path):
    snapshot_root = eco_dir / 'state-snapshots'
    if not snapshot_root.exists() or not snapshot_root.is_dir():
        return 0, []
    snapshots = [d for d in snapshot_root.iterdir() if d.is_dir()]
    timestamps = [parse_snapshot_timestamp(s) for s in snapshots]
    timestamps = [t for t in timestamps if t is not None]
    if not timestamps:
        return 0, []
    latest = max(timestamps)
    age = (datetime.now(timezone.utc) - latest).days
    if age <= 7:
        score = 100
    elif age <= 14:
        score = 80
    elif age <= 30:
        score = 60
    elif age <= 60:
        score = 40
    else:
        score = 20
    return score, [t.isoformat() for t in timestamps]


def score_sku_alignment(repo_root: Path):
    sku_root = repo_root / 'skus'
    manifests = []
    if not sku_root.exists():
        return 0, manifests
    for sku_dir in sorted([d for d in sku_root.iterdir() if d.is_dir()]):
        path = sku_dir / '.eco' / 'manifest.yaml'
        if path.exists():
            text = read_text(path)
            matches = sum(1 for marker in SKU_REQUIRED_FIELDS if marker in text)
            manifests.append({'sku': sku_dir.name, 'score': int((matches / len(SKU_REQUIRED_FIELDS)) * 100)})
    if not manifests:
        return 0, manifests
    avg = int(sum(item['score'] for item in manifests) / len(manifests))
    return avg, manifests


def compute_health(eco_dir: Path, repo_root: Path):
    enforcement_strength = score_enforcement_strength(eco_dir)
    audit_completeness = score_markers(read_text(eco_dir / 'audit-log.md'), AUDIT_MARKERS)
    ledger_completeness = score_markers(read_text(eco_dir / 'change-ledger.md'), LEDGER_MARKERS)
    agent_activity_health = score_markers(read_text(eco_dir / 'agent-log.md'), AGENT_MARKERS)
    devpath_integrity = score_markers(read_text(eco_dir / 'devpath.md'), DEVPATH_MARKERS)
    governance_health = score_presence([repo_root / file for file in REQUIRED_FILES + ['health.yaml']])
    snapshot_freshness, snapshot_timestamps = score_snapshot_freshness(eco_dir)
    sku_alignment, sku_details = score_sku_alignment(repo_root)
    ci_status = 100 if (eco_dir / 'health-report.json').exists() else 80
    drift_risk = max(0, 100 - int((governance_health + enforcement_strength + snapshot_freshness) / 3))
    components = [governance_health, enforcement_strength, audit_completeness, ledger_completeness, snapshot_freshness, agent_activity_health, sku_alignment]
    overall_score = int(sum(components) / len(components)) if components else 0
    return {
        'governance_health': governance_health,
        'drift_risk': drift_risk,
        'enforcement_strength': enforcement_strength,
        'audit_completeness': audit_completeness,
        'ledger_completeness': ledger_completeness,
        'snapshot_freshness': snapshot_freshness,
        'agent_activity_health': agent_activity_health,
        'sku_alignment': sku_alignment,
        'devpath_integrity': devpath_integrity,
        'ci_status': ci_status,
        'overall_score': overall_score,
        'snapshot_timestamps': snapshot_timestamps,
        'sku_alignment_details': sku_details,
    }


def write_report(eco_dir: Path, report: dict, output_path: Path):
    output_path.write_text(json.dumps(report, indent=2), encoding='utf-8')


def main():
    args = parse_args()
    repo_root = Path(__file__).resolve().parents[1]
    eco_dir = repo_root
    report = compute_health(eco_dir, repo_root)
    output_path = Path(args.output)
    write_report(eco_dir, report, output_path)
    print(json.dumps(report, indent=2))
    if report['overall_score'] < 80:
        raise SystemExit(f'Overall governance health score below threshold: {report["overall_score"]}')


if __name__ == '__main__':
    main()
