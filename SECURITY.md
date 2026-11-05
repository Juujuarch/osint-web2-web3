# Security Policy

## Kebijakan kredensial

1. **Nol kredensial di repo.** Tidak ada token, API key, private key, password - di kode, contoh, dokumentasi, atau commit history.
2. **Tidak ada hardcode.** Semua rahasia masuk via environment variable (`export HIBP_KEY=...`) atau secret manager lokal, dan semua env file masuk `.gitignore`.
3. **Scan sebelum push.** `bash tools/scan-secrets.sh` wajib lolos (exit 0) sebelum `git push`.
4. **Kalau pernah ke-commit**: anggap bocor permanen - revoke/rotate segera, jangan cukup hapus commit (history tetap ada sampai force-push + GC, dan fork/cache eksternal tetap bisa menyimpan).
5. **Token scope minimum**: kalau butuh token (misal HIBP, Shodan), pakai read-only scope sekecil mungkin, dan pisahkan token investigasi dari token pribadi.

## OPSEC minimum sebelum investigasi

- VM atau container terpisah untuk kasus investigasi
- Browser profile dedicated, tanpa akun personal yang login
- Jangan pakai koneksi/IP yang bisa di-link ke identitas asli untuk fase sensitif
- Log minimal: simpan hanya yang jadi bukti, sisanya jangan
- Penyimpanan hasil investigasi terenkripsi, jangan auto-sync ke cloud pribadi

## Pelaporan vulnerability

Kalau menemukan kebocoran kredensial atau celah keamanan di repo ini, jangan buka issue publik - hubungi maintainer langsung.