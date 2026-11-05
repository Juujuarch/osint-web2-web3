# Contributing

1. All new skills follow the frontmatter convention: `name` + `description` (with trigger conditions) at the top of SKILL.md.
2. Sources must be explicit: every "use tool X" claim must name the actual tool/source in the SKILL.md or docs/SOURCES.md.
3. Do not vendor third-party repos - link upstream and install via `tools/install-backends.sh`.
4. Zero credentials. Run `bash tools/scan-secrets.sh` before committing.
5. Every skill includes a MATCHING LOGIC section using the global confidence framework (skills/osint/SKILL.md).
6. When adding a new OSINT domain, also add a row to the router table in `skills/osint/SKILL.md`.
7. Keep the read-only principle for all web3 skills.
8. All repository content is in English.