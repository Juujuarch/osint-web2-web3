# Contributing

1. Semua skill baru/edit ikut pola frontmatter `name` + `description` di baris pertama SKILL.md.
2. Sumber harus eksplisit: tiap klaim "pakai tool X" harus menyebut nama tool/sumber asli di SKILL.md atau docs/SOURCES.md.
3. Jangan vendor repo orang langsung - link ke upstream, install via `tools/install-backends.sh`.
4. Nol kredensial. Jalankan `bash tools/scan-secrets.sh` sebelum commit.
5. Kalau menambah domain OSINT baru, tambahkan juga baris di tabel router `skills/osint/SKILL.md`.
6. Pertahankan prinsip read-only untuk semua skill web3.