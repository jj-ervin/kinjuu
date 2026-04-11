#!/usr/bin/env python3
"""
update_governance.py — Upgrade a project's eco governance to a new .eco version.

This tool reads the current eco_version from project.yaml, fetches the target
version of .eco from GitHub, and re-runs the scaffold --init logic to merge
in new/improved governance files without overwriting existing customizations.

Usage
-----
  python tools/update_governance.py --to v1.1.0
  python tools/update_governance.py --to v1.1.0 --eco-repo https://github.com/my-org/.eco.git
  python tools/update_governance.py --list-versions  # show available tags
"""
import argparse
import json
import re
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path


def parse_args():
    parser = argparse.ArgumentParser(
        description='Upgrade a project to a new .eco governance version.'
    )
    parser.add_argument(
        '--to',
        required=False,
        help='Target .eco version (e.g., v1.1.0). Use --list-versions to see available.',
    )
    parser.add_argument(
        '--eco-repo',
        default='https://github.com/jj-ervin/.eco.git',
        help='URL to .eco repository (default: official .eco)',
    )
    parser.add_argument(
        '--list-versions',
        action='store_true',
        help='List available .eco versions and exit',
    )
    parser.add_argument(
        '--dry-run',
        action='store_true',
        help='Show what would be updated without making changes',
    )
    return parser.parse_args()


def read_project_version(eco_dir):
    """Read current eco_version from project.yaml."""
    proj = eco_dir / 'project.yaml'
    if not proj.exists():
        return None
    text = proj.read_text(encoding='utf-8')
    m = re.search(r'^\s*eco_version:\s*[\"\']?([\w\-\.]+)[\"\']?', text, re.MULTILINE)
    if m:
        return m.group(1)
    return None


def write_project_version(eco_dir, version):
    """Update eco_version in project.yaml."""
    proj = eco_dir / 'project.yaml'
    if not proj.exists():
        print(f'[error] project.yaml not found in {eco_dir}', file=sys.stderr)
        return False
    text = proj.read_text(encoding='utf-8')
    if 'eco_version:' in text:
        text = re.sub(
            r'^\s*eco_version:\s*[\"\']?[\w\-\.]+[\"\']?',
            f'  eco_version: {version}',
            text,
            flags=re.MULTILINE
        )
    else:
        # Append under project: block
        text = text.rstrip('\n') + f'\n  eco_version: {version}\n'
    proj.write_text(text, encoding='utf-8')
    return True


def list_versions(repo_url):
    """List available .eco versions (git tags)."""
    with tempfile.TemporaryDirectory() as tmpdir:
        tmpdir = Path(tmpdir)
        try:
            print(f'[info] Fetching tags from {repo_url}...')
            subprocess.run(
                ['git', 'clone', '--bare', '--depth', '1', repo_url, str(tmpdir / '.eco.git')],
                capture_output=True,
                timeout=30,
                check=True,
            )
            result = subprocess.run(
                ['git', '--git-dir', str(tmpdir / '.eco.git'), 'tag', '-l'],
                capture_output=True,
                text=True,
                timeout=10,
            )
            tags = sorted(result.stdout.strip().split('\n'), reverse=True)
            tags = [t for t in tags if t]
            if not tags:
                print('[info] No version tags found')
                return
            print('\nAvailable .eco versions:')
            for tag in tags:
                print(f'  {tag}')
        except subprocess.TimeoutExpired:
            print('[error] Fetch timed out', file=sys.stderr)
            return False
        except subprocess.CalledProcessError as e:
            print(f'[error] {e.stderr.decode()}', file=sys.stderr)
            return False
    return True


def fetch_eco_version(repo_url, version, dest):
    """Clone .eco repo at target version into dest."""
    try:
        print(f'[info] Fetching .eco {version} from {repo_url}...')
        subprocess.run(
            ['git', 'clone', '--branch', version, '--depth', '1', repo_url, str(dest)],
            capture_output=True,
            timeout=60,
            check=True,
        )
        if not (dest / 'tools' / 'scaffold_project.py').exists():
            print(f'[error] scaffold_project.py not found in {version}', file=sys.stderr)
            return False
        return True
    except subprocess.TimeoutExpired:
        print(f'[error] Fetch timed out', file=sys.stderr)
        return False
    except subprocess.CalledProcessError as e:
        err = e.stderr.decode() if e.stderr else str(e)
        print(f'[error] Failed to fetch {version}: {err}', file=sys.stderr)
        return False


def run_update(args):
    """Main update workflow."""
    eco_dir = Path.cwd()
    current = read_project_version(eco_dir)

    if not current:
        print('[error] Could not read eco_version from project.yaml', file=sys.stderr)
        sys.exit(1)

    if args.list_versions:
        list_versions(args.eco_repo)
        sys.exit(0)

    if not args.to:
        print('[error] --to is required (or use --list-versions)', file=sys.stderr)
        sys.exit(1)

    target = args.to
    if target == current:
        print(f'[info] Already at {current}')
        sys.exit(0)

    print(f'[update] Upgrading from {current} to {target}')
    print()

    # Fetch target version
    with tempfile.TemporaryDirectory() as tmpdir:
        tmpdir = Path(tmpdir)
        if not fetch_eco_version(args.eco_repo, target, tmpdir):
            sys.exit(1)

        # Run scaffold --init from target version
        scaffold = tmpdir / 'tools' / 'scaffold_project.py'
        project_name = Path.cwd().name
        try:
            print('[info] Running scaffold --init from target version...')
            result = subprocess.run(
                ['python', str(scaffold), '--init', '--name', project_name],
                cwd=eco_dir,
                capture_output=True,
                text=True,
                timeout=60,
            )
            # Print scaffold output
            if result.stdout:
                print(result.stdout)
            if result.returncode != 0 and result.stderr:
                print(result.stderr, file=sys.stderr)
        except subprocess.TimeoutExpired:
            print('[error] Scaffold timed out', file=sys.stderr)
            sys.exit(1)

    # Update version
    if args.dry_run:
        print(f'[dry-run] Would update eco_version to {target}')
    else:
        if write_project_version(eco_dir, target):
            print(f'[ok] Updated eco_version to {target}')
        else:
            sys.exit(1)

    # Run validation
    print()
    print('[info] Running governance validation...')
    validate = eco_dir / 'tools' / 'validate_governance.py'
    if validate.exists():
        try:
            result = subprocess.run(
                ['python', str(validate), '--dry-run', '--diagnostics-file', 'governance-diagnostics.json'],
                cwd=eco_dir,
                capture_output=True,
                text=True,
                timeout=30,
            )
            if result.stdout:
                print(result.stdout)
            if result.returncode != 0 and result.stderr:
                print(result.stderr, file=sys.stderr)
        except subprocess.TimeoutExpired:
            print('[warning] Validation timed out', file=sys.stderr)

    print()
    print('[ok] Update complete')
    if not args.dry_run:
        print()
        print('Next steps:')
        print('  1. Review any updated files in diff')
        print('  2. Test your project (build, test suite, etc.)')
        print('  3. Run: python tools/validate_governance.py --update-hash')
        print('  4. Commit: git add -A && git commit -m "chore: upgrade .eco to', target + '"')


def main():
    args = parse_args()
    run_update(args)


if __name__ == '__main__':
    main()
