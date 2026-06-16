#!/data/data/com.termux/files/usr/bin/bash

# ============================================================
#  RHF OS - INSTALLER v1.0
#  by ZERO / RHF
# ============================================================

RED='\033[0;31m'
GRN='\033[0;32m'
YLW='\033[1;33m'
CYN='\033[0;36m'
BLD='\033[1m'
RST='\033[0m'

clear
echo -e "${CYN}"
cat << 'EOF'
  ██████╗ ██╗  ██╗███████╗      ██████╗ ███████╗
  ██╔══██╗██║  ██║██╔════╝     ██╔═══██╗██╔════╝
  ██████╔╝███████║█████╗       ██║   ██║███████╗
  ██╔══██╗██╔══██║██╔══╝       ██║   ██║╚════██║
  ██║  ██║██║  ██║██║          ╚██████╔╝███████║
  ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝          ╚═════╝ ╚══════╝
           [ INSTALLER v1.0 by ZERO ]
EOF
echo -e "${RST}"

echo -e "${YLW}[*] Starting RHF OS Installation...${RST}"
echo ""

# ── Step 1: Update Termux packages
echo -e "${CYN}[1/7] Updating Termux packages...${RST}"
pkg update -y -q && pkg upgrade -y -q
echo -e "${GRN}    ✓ Done${RST}"

# ── Step 2: Install core dependencies
echo -e "${CYN}[2/7] Installing core dependencies...${RST}"
pkg install -y -q \
  x11-repo \
  wget \
  curl \
  git \
  proot \
  proot-distro \
  python \
  nodejs
echo -e "${GRN}    ✓ Done${RST}"

# ── Step 3: Install X11 display server
echo -e "${CYN}[3/7] Installing X11 display server...${RST}"
pkg install -y -q \
  termux-x11-nightly \
  xorg-xwininfo \
  openbox \
  obconf \
  xterm \
  tigervnc
echo -e "${GRN}    ✓ Done${RST}"

# ── Step 4: Install browser
echo -e "${CYN}[4/7] Installing browser (Firefox)...${RST}"
pkg install -y -q \
  firefox
echo -e "${GRN}    ✓ Done${RST}"

# ── Step 5: Install Ubuntu via proot-distro
echo -e "${CYN}[5/7] Installing Ubuntu (proot)...${RST}"
proot-distro install ubuntu 2>/dev/null || echo "    Ubuntu already installed"
echo -e "${GRN}    ✓ Done${RST}"

# ── Step 6: Setup RHF OS directory
echo -e "${CYN}[6/7] Setting up RHF OS environment...${RST}"
mkdir -p $HOME/rhfos
mkdir -p $HOME/rhfos/apps
mkdir -p $HOME/rhfos/data
mkdir -p $HOME/rhfos/logs
mkdir -p $HOME/.config/openbox

# Copy openbox config
cat > $HOME/.config/openbox/rc.xml << 'OPENBOX_EOF'
<?xml version="1.0" encoding="UTF-8"?>
<openbox_config>
  <theme>
    <name>Bear2</name>
    <titleLayout>NLC</titleLayout>
  </theme>
  <desktops>
    <number>4</number>
    <firstdesk>1</firstdesk>
    <names>
      <name>RHF Main</name>
      <name>Browser</name>
      <name>Terminal</name>
      <name>Admin</name>
    </names>
  </desktops>
  <keyboard>
    <keybind key="C-F1">
      <action name="GoToDesktop"><to>1</to></action>
    </keybind>
    <keybind key="C-F2">
      <action name="GoToDesktop"><to>2</to></action>
    </keybind>
    <keybind key="super-t">
      <action name="Execute"><command>xterm</command></action>
    </keybind>
  </keyboard>
</openbox_config>
OPENBOX_EOF

# Openbox autostart
cat > $HOME/.config/openbox/autostart << 'AUTO_EOF'
# RHF OS Autostart
xterm -title "RHF Terminal" -bg black -fg green &
firefox $HOME/rhfos/desktop.html &
AUTO_EOF

chmod +x $HOME/.config/openbox/autostart
echo -e "${GRN}    ✓ Done${RST}"

# ── Step 7: Install rhfos launcher
echo -e "${CYN}[7/7] Installing RHF OS launcher...${RST}"

# Copy scripts to PATH
cp $HOME/rhfos/rhfos.sh $PREFIX/bin/rhfos 2>/dev/null || true
chmod +x $PREFIX/bin/rhfos 2>/dev/null || true

echo -e "${GRN}    ✓ Done${RST}"

echo ""
echo -e "${BLD}${GRN}╔══════════════════════════════════════╗${RST}"
echo -e "${BLD}${GRN}║   RHF OS INSTALLED SUCCESSFULLY!     ║${RST}"
echo -e "${BLD}${GRN}╚══════════════════════════════════════╝${RST}"
echo ""
echo -e "${YLW}Cara menjalankan:${RST}"
echo -e "  1. Install ${BLD}Termux:X11${RST} dari F-Droid"
echo -e "  2. Buka Termux:X11 dulu, lalu balik ke Termux"
echo -e "  3. Ketik: ${BLD}${CYN}bash ~/rhfos/rhfos.sh${RST}"
echo ""
echo -e "${CYN}RHF OS by ZERO — Build the Future.${RST}"
echo ""
