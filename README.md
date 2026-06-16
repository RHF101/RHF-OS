# RHF OS v1.0
**by ZERO / RHF**

---

## File Structure
```
rhfos/
├── install.sh    → Auto installer (jalanin pertama kali)
├── rhfos.sh      → Launcher utama
├── desktop.html  → Desktop UI (jalan di browser X11)
├── admin.html    → Admin panel
└── README.md     → Ini
```

---

## CARA INSTALL & JALANKAN

### Step 1 — Install app yang dibutuhkan di HP lo
1. Install **Termux** dari F-Droid (bukan Play Store)
   - https://f-droid.org/packages/com.termux/
2. Install **Termux:X11** dari F-Droid
   - https://github.com/termux/termux-x11/releases

### Step 2 — Copy files ke Termux
Di Termux, ketik:
```bash
mkdir -p ~/rhfos
```
Lalu copy semua file ke folder `~/rhfos/`

### Step 3 — Jalankan installer
```bash
cd ~/rhfos
chmod +x install.sh rhfos.sh
bash install.sh
```
Tunggu sampai selesai (butuh internet, ~5-10 menit).
### KETIKA GAGAL 
### Step 3 — Jalankan installer
```cp ~/storage/shared/Download/install.sh ~/rhfos/
cp ~/storage/shared/Download/rhfos.sh ~/rhfos/
cd ~/rhfos
chmod +x install.sh rhfos.sh
bash install.sh```


### Step 4 — Boot RHF OS
1. Buka app **Termux:X11** dulu di HP lo
2. Balik ke **Termux**, ketik:
```bash
bash ~/rhfos/rhfos.sh
```
3. Pilih **1. Boot RHF OS**
4. Buka app **Termux:X11** → Desktop RHF OS muncul!

---

## FITUR RHF OS

| Fitur | Keterangan |
|---|---|
| 🖥️ Desktop | Desktop GUI dengan icons & dock |
| ⬛ Terminal | Terminal dengan command support |
| 🌐 Browser | Browser (Firefox via X11) |
| 📁 File Manager | Browse files sistem |
| ⚙️ System Info | CPU, memory, uptime |
| 📝 Notes | Notepad dengan auto-save |
| 🔒 Admin Panel | Full admin control |

### Terminal Commands
```
help      → Lihat semua command
ls        → List files
uname     → Info kernel
whoami    → Current user
date      → Tanggal & waktu
neofetch  → System info ASCII
clear     → Clear terminal
reboot    → Restart OS
shutdown  → Matikan OS
```

### Admin Panel Features
- 📊 Dashboard — stats real-time
- 👥 Users — manage user accounts
- 📋 System Logs — event log live
- ⬛ Remote Terminal — terminal khusus admin
- 📡 Broadcast — kirim pesan ke semua user
- ⚙️ Settings — konfigurasi OS

---

## TROUBLESHOOT

**Desktop tidak muncul di Termux:X11?**
→ Pastikan buka Termux:X11 app DULU sebelum boot

**Firefox tidak bisa install?**
```bash
pkg install x11-repo -y
pkg install firefox -y
```

**X11 error: cannot connect to display**
→ Pastikan Termux:X11 sudah berjalan di background

**Permission denied saat jalanin script**
```bash
chmod +x ~/rhfos/*.sh
```

---

## ROADMAP NEXT UPDATE
- [ ] App Store RHF
- [ ] Multi-user login
- [ ] Firebase sync real-time
- [ ] Custom wallpaper
- [ ] More built-in apps

---

*RHF OS — Built by ZERO. Build the Future.*
