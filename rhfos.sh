#!/data/data/com.termux/files/usr/bin/bash

# ============================================================
#  RHF OS - LAUNCHER v1.0
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
DISPLAY=":0"
export DISPLAY

clear
echo -e "${CYN}"
cat << 'EOF'
  ██████╗ ██╗  ██╗███████╗      ██████╗ ███████╗
  ██╔══██╗██║  ██║██╔════╝     ██╔═══██╗██╔════╝
  ██████╔╝███████║█████╗       ██║   ██║███████╗
  ██╔══██╗██╔══██║██╔══╝       ██║   ██║╚════██║
  ██║  ██║██║  ██║██║          ╚██████╔╝███████║
  ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝          ╚═════╝ ╚══════╝
           [ LAUNCHING v1.0 by ZERO ]
EOF
echo -e "${RST}"

mkdir -p "$RHFOS_DIR/logs"

# ── Check Termux:X11
check_x11() {
  if ! command -v termux-x11 &>/dev/null; then
    echo -e "${RED}[!] Termux:X11 tidak ditemukan!${RST}"
    echo -e "${YLW}    Install dulu: https://github.com/termux/termux-x11${RST}"
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
  # Kill existing X server jika ada
  pkill -f "termux-x11" 2>/dev/null
  pkill -f "Xwayland" 2>/dev/null
  sleep 1

  # Start X11 server di background
  termux-x11 :0 -xstartup "openbox-session" &
  X11_PID=$!
  echo "$X11_PID" > "$RHFOS_DIR/logs/x11.pid"
  sleep 2
  echo -e "${GRN}    ✓ X11 Server PID: $X11_PID${RST}"
}

# ── Start Openbox WM
start_wm() {
  echo -e "${CYN}[2/4] Starting Window Manager (Openbox)...${RST}"
  DISPLAY=:0 openbox-session &>/dev/null &
  WM_PID=$!
  echo "$WM_PID" > "$RHFOS_DIR/logs/wm.pid"
  sleep 2
  echo -e "${GRN}    ✓ Openbox WM PID: $WM_PID${RST}"
}

# ── Start desktop UI
start_desktop() {
  echo -e "${CYN}[3/4] Loading RHF OS Desktop...${RST}"
  sleep 1
  # Buka desktop.html di firefox
  DISPLAY=:0 firefox --new-window "file://$RHFOS_DIR/desktop.html" &>/dev/null &
  DESK_PID=$!
  echo "$DESK_PID" > "$RHFOS_DIR/logs/desktop.pid"
  sleep 2
  echo -e "${GRN}    ✓ Desktop loaded${RST}"
}

# ── Start terminal
start_terminal() {
  echo -e "${CYN}[4/4] Starting RHF Terminal...${RST}"
  DISPLAY=:0 xterm \
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
  echo -e "${BLD}${CYN}╔══════════════════════════════╗${RST}"
  echo -e "${BLD}${CYN}║      RHF OS CONTROL MENU     ║${RST}"
  echo -e "${BLD}${CYN}╠══════════════════════════════╣${RST}"
  echo -e "${BLD}${CYN}║${RST}  1. Boot RHF OS              ${CYN}║${RST}"
  echo -e "${BLD}${CYN}║${RST}  2. Open Browser              ${CYN}║${RST}"
  echo -e "${BLD}${CYN}║${RST}  3. Open Terminal             ${CYN}║${RST}"
  echo -e "${BLD}${CYN}║${RST}  4. Open Admin Panel          ${CYN}║${RST}"
  echo -e "${BLD}${CYN}║${RST}  5. Restart RHF OS            ${CYN}║${RST}"
  echo -e "${BLD}${CYN}║${RST}  6. Shutdown RHF OS           ${CYN}║${RST}"
  echo -e "${BLD}${CYN}╚══════════════════════════════╝${RST}"
  echo ""
  echo -ne "${YLW}Pilih [1-6]: ${RST}"
  read -r choice

  case $choice in
    1)
      check_x11
      check_deps
      start_x11
      start_wm
      start_desktop
      start_terminal
      echo ""
      echo -e "${BLD}${GRN}✓ RHF OS Berhasil Boot!${RST}"
      echo -e "${YLW}  Buka app Termux:X11 di device lo untuk melihat desktop.${RST}"
      ;;
    2)
      echo -e "${CYN}Opening browser...${RST}"
      DISPLAY=:0 firefox &>/dev/null &
      echo -e "${GRN}✓ Browser opened${RST}"
      ;;
    3)
      echo -e "${CYN}Opening terminal...${RST}"
      DISPLAY=:0 xterm -bg "#0a0a0f" -fg "#00ff88" &>/dev/null &
      echo -e "${GRN}✓ Terminal opened${RST}"
      ;;
    4)
      echo -e "${CYN}Opening Admin Panel...${RST}"
      DISPLAY=:0 firefox "file://$RHFOS_DIR/admin.html" &>/dev/null &
      echo -e "${GRN}✓ Admin Panel opened${RST}"
      ;;
    5)
      echo -e "${YLW}Restarting RHF OS...${RST}"
      pkill -f openbox 2>/dev/null
      pkill -f firefox 2>/dev/null
      pkill -f xterm 2>/dev/null
      sleep 2
      start_wm
      start_desktop
      start_terminal
      echo -e "${GRN}✓ Restarted!${RST}"
      ;;
    6)
      echo -e "${RED}Shutting down RHF OS...${RST}"
      pkill -f openbox 2>/dev/null
      pkill -f firefox 2>/dev/null
      pkill -f xterm 2>/dev/null
      pkill -f termux-x11 2>/dev/null
      rm -f "$RHFOS_DIR/logs/"*.pid
      echo -e "${GRN}✓ RHF OS Shutdown. Goodbye!${RST}"
      exit 0
      ;;
    *)
      echo -e "${RED}Pilihan tidak valid!${RST}"
      show_menu
      ;;
  esac
}

# ── Entry point
show_menu
