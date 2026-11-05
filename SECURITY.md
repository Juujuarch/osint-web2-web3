# Security Policy

## Credential policy

1. **Zero credentials in the repo.** No tokens, API keys, private keys, or passwords - not in code, examples, documentation, or commit history.
2. **No hardcoding.** All secrets enter via environment variables (`export HIBP_KEY=...`) or a local secret manager, and all env files are gitignored.
3. **Scan before push.** `bash tools/scan-secrets.sh` must pass (exit 0) before `git push`.
4. **If it was ever committed**: treat it as permanently leaked - revoke/rotate immediately; deleting the commit is not enough (history, forks, and external caches persist).
5. **Minimum token scope**: when a token is needed (e.g. HIBP, Shodan), use the smallest read-only scope possible, and keep investigation tokens separate from personal ones.

## Minimum OPSEC before investigations

- Separate VM or container per case
- Dedicated browser profile, no personal accounts logged in
- Do not use networks/IPs linkable to your real identity for sensitive phases
- Minimal logging: keep only what becomes evidence
- Encrypted storage for investigation results; do not auto-sync to personal cloud

## Data-leak specific rules

- Breach data contains third-party PII: process only with a documented legal basis (UU PDP No. 27/2022 / GDPR Art. 6/9)
- Prefer k-anonymity (`tools/breach-check.sh`) and ToS-compliant services over full leaked databases
- If you must handle a dump: isolated environment, minimal retention, encrypted storage
- National ID numbers (NIK), biometrics, health data = sensitive personal data; stricter basis required

## Reporting a vulnerability

If you find exposed credentials or a security issue in this repo, do not open a public issue - contact the maintainer directly.