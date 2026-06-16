#!/data/data/com.termux/files/usr/bin/bash

# ============================================================
#  RHF OS - LAUNCHER v1.1 (Dual Support: X11 & VNC)
#  by ZERO / RHF
# ============================================================

RED='\033[0;31m'
GRN='\033[0;32m'
YLW='\033[1;33m'
CYN='\033[0;36m'
BLD='\033[1m'
RST='\033[0m'

RHFOS_DIR="$HOME/rhfos"
LOG="$RHFOS_DIR/logs/rhfos.log"

# Hapus export DISPLAY di sini, kita set dinamis pas milih menu

clear
echo -e "${CYN}"
cat << 'EOF'
  ██████╗ ██╗  ██╗███████╗      ██████╗ ███████╗
  ██╔══██╗██║  ██║██╔════╝     ██╔═══██╗██╔════╝
  ██████╔╝███████║█████╗       ██║   ██║███████╗
  ██╔══██╗██╔══██║██╔══╝       ██║   ██║╚════██║
  ██║  ██║██║  ██║██║          ╚██████╔╝███████║
  ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝          ╚═════╝ ╚══════╝
      [ LAUNCHER v1.1 - X11 & VNC EDITION ]
EOF
echo -e "${RST}"

mkdir -p "$RHFOS_DIR/logs"

# ── Check Termux:X11
check_x11() {
  if ! command -v termux-x11 &>/dev/null; then
    echo -e "${RED}[!] Termux:X11 tidak ditemukan!${RST}"
    echo -e "${YLW}    Install dulu: pkg install termux-x11-nightly${RST}"
    exit 1
  fi
}

# ── Check VNC
check_vnc() {
  if ! command -v vncserver &>/dev/null; then
    echo -e "${RED}[!] TigerVNC tidak ditemukan!${RST}"
    echo -e "${YLW}    Install dulu: pkg install tigervnc${RST}"
    echo -e "${YLW}    Lalu jalankan 'vncpasswd' buat bikin password VNC.${RST}"
    exit 1
  fi
}

# ── Check dependencies
check_deps() {
  local missing=()
  for dep in openbox xterm firefox; do
    if ! command -v "$dep" &>/dev/null; then
      missing+=("$dep")
    fi
  done
  if [ ${#missing[@]} -gt 0 ]; then
    echo -e "${RED}[!] Dependency kurang: ${missing[*]}${RST}"
    echo -e "${YLW}    Jalankan install.sh dulu!${RST}"
    exit 1
  fi
}

# ── Start Termux:X11
start_x11() {
  echo -e "${CYN}[1/4] Starting Termux:X11...${RST}"
  pkill -f "termux-x11" 2>/dev/null
  pkill -f "Xwayland" 2>/dev/null
  sleep 1

  termux-x11 :0 &
  X11_PID=$!
  echo "$X11_PID" > "$RHFOS_DIR/logs/x11.pid"
  sleep 2
  echo -e "${GRN}    ✓ X11 Server PID: $X11_PID${RST}"
}

# ── Start VNC Server
start_vnc() {
  echo -e "${CYN}[1/4] Starting VNC Server (Port 5901)...${RST}"
  vncserver -kill :1 &>/dev/null
  sleep 1
  
  vncserver :1 -geometry 1280x720 -depth 24 &>/dev/null
  VNC_PID=$(pgrep -f "Xvnc :1")
  echo "$VNC_PID" > "$RHFOS_DIR/logs/vnc.pid"
  sleep 2
  echo -e "${GRN}    ✓ VNC Server Ready! Buka RVNC ke 127.0.0.1:5901${RST}"
}

# ── Start Openbox WM
start_wm() {
  echo -e "${CYN}[2/4] Starting Window Manager (Openbox)...${RST}"
  # Menggunakan $DISPLAY yang dinamis (bisa :0 atau :1)
  DISPLAY=$DISPLAY openbox-session &>/dev/null &
  WM_PID=$!
  echo "$WM_PID" > "$RHFOS_DIR/logs/wm.pid"
  sleep 2
  echo -e "${GRN}    ✓ Openbox WM PID: $WM_PID${RST}"
}

# ── Start desktop UI
start_desktop() {
  echo -e "${CYN}[3/4] Loading RHF OS Desktop...${RST}"
  sleep 1
  DISPLAY=$DISPLAY firefox --new-window "file://$RHFOS_DIR/desktop.html" &>/dev/null &
  DESK_PID=$!
  echo "$DESK_PID" > "$RHFOS_DIR/logs/desktop.pid"
  sleep 2
  echo -e "${GRN}    ✓ Desktop loaded${RST}"
}

# ── Start terminal
start_terminal() {
  echo -e "${CYN}[4/4] Starting RHF Terminal...${RST}"
  DISPLAY=$DISPLAY xterm \
    -title "RHF OS Terminal" \
    -bg "#0a0a0f" \
    -fg "#00ff88" \
    -fa "Monospace" \
    -fs 11 \
    -geometry 80x24+50+50 &>/dev/null &
  TERM_PID=$!
  echo "$TERM_PID" > "$RHFOS_DIR/logs/term.pid"
  echo -e "${GRN}    ✓ Terminal PID: $TERM_PID${RST}"
}

# ── Menu
show_menu() {
  echo ""
  echo -e "${BLD}${CYN}╔══════════════════════════════════════╗${RST}"
  echo -e "${BLD}${CYN}║         RHF OS CONTROL MENU          ║${RST}"
  echo -e "${BLD}${CYN}╠══════════════════════════════════════╣${RST}"
  echo -e "${BLD}${CYN}║${RST}  1. Boot OS via Termux:X11 (App)    ${CYN}║${RST}"
  echo -e "${BLD}${CYN}║${RST}  2. Boot OS via RealVNC (RVNC)      ${CYN}║${RST}"
  echo -e "${BLD}${CYN}║${RST}  3. Open Browser                    ${CYN}║${RST}"
  echo -e "${BLD}${CYN}║${RST}  4. Open Terminal                   ${CYN}║${RST}"
  echo -e "${BLD}${CYN}║${RST}  5. Open Admin Panel                ${CYN}║${RST}"
  echo -e "${BLD}${CYN}║${RST}  6. Restart RHF OS                  ${CYN}║${RST}"
  echo -e "${BLD}${CYN}║${RST}  7. Shutdown RHF OS                 ${CYN}║${RST}"
  echo -e "${BLD}${CYN}╚══════════════════════════════════════╝${RST}"
  echo ""
  echo -ne "${YLW}Pilih [1-7]: ${RST}"
  read -r choice

  case $choice in
    1)
      export DISPLAY=":0"
      check_x11
      check_deps
      start_x11
      start_wm
      start_desktop
      start_terminal
      echo ""
      echo -e "${BLD}${GRN}✓ RHF OS Berhasil Boot via Termux:X11!${RST}"
      echo -e "${YLW}  Buka aplikasi Termux:X11 sekarang.${RST}"
      ;;
    2)
      export DISPLAY=":1"
      check_vnc
      check_deps
      start_vnc
      start_wm
      start_desktop
      start_terminal
      echo ""
      echo -e "${BLD}${GRN}✓ RHF OS Berhasil Boot via VNC!${RST}"
      echo -e "${YLW}  Buka RVNC Viewer, konek ke localhost:5901 (atau 127.0.0.1:5901)${RST}"
      ;;
    3)
      echo -e "${CYN}Opening browser...${RST}"
      DISPLAY=$DISPLAY firefox &>/dev/null &
      echo -e "${GRN}✓ Browser opened${RST}"
      ;;
    4)
      echo -e "${CYN}Opening terminal...${RST}"
      DISPLAY=$DISPLAY xterm -bg "#0a0a0f" -fg "#00ff88" &>/dev/null &
      echo -e "${GRN}✓ Terminal opened${RST}"
      ;;
    5)
      echo -e "${CYN}Opening Admin Panel...${RST}"
      DISPLAY=$DISPLAY firefox "file://$RHFOS_DIR/admin.html" &>/dev/null &
      echo -e "${GRN}✓ Admin Panel opened${RST}"
      ;;
    6)
      echo -e "${YLW}Restarting RHF OS Desktop...${RST}"
      pkill -f openbox 2>/dev/null
      pkill -f firefox 2>/dev/null
      pkill -f xterm 2>/dev/null
      sleep 2
      start_wm
      start_desktop
      start_terminal
      echo -e "${GRN}✓ Restarted!${RST}"
      ;;
    7)
      echo -e "${RED}Shutting down RHF OS...${RST}"
      pkill -f openbox 2>/dev/null
      pkill -f firefox 2>/dev/null
      pkill -f xterm 2>/dev/null
      pkill -f termux-x11 2>/dev/null
      vncserver -kill :1 &>/dev/null
      rm -f "$RHFOS_DIR/logs/"*.pid
      echo -e "${GRN}✓ RHF OS Shutdown. Semua service X11/VNC dimatikan. Goodbye!${RST}"
      exit 0
      ;;
    *)
      echo -e "${RED}Pilihan tidak valid!${RST}"
      show_menu
      ;;
  esac
}

# ── Entry point
# Deteksi apakah DISPLAY sudah di-set sebelumnya (buat menu tambahan biar ga error)
if [ -z "$DISPLAY" ]; then
  export DISPLAY=":0"
fi

show_menu
