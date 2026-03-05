#!/usr/bin/env bash
# DVD Bounce — Kitty Graphics Protocol version
# Uses the official DVD VIDEO logo as a transparent PNG overlay.
# Requires: Ghostty/Kitty terminal with graphics protocol support.

set -e
TTY=/dev/tty

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
LOGO_PNG="$SCRIPT_DIR/dvd-logo.png"

if [[ ! -f "$LOGO_PNG" ]]; then
  echo "dvd-logo.png not found at $LOGO_PNG" >&2
  exit 1
fi

LOGO_COLS=22
LOGO_ROWS=6
IMAGE_ID=99

echo $$ > /tmp/dvd-bounce.pid

cleanup() {
  printf '\e_Ga=d,d=I,i=%d,q=2;\e\\' "$IMAGE_ID" > "$TTY" 2>/dev/null
  printf '\e[?25h' > "$TTY" 2>/dev/null
  rm -f /tmp/dvd-bounce.pid
  exit 0
}
trap cleanup EXIT TERM INT

# ---------- Upload the DVD logo once ----------
DATA=$(base64 < "$LOGO_PNG" | tr -d '\n')
printf '\e_Gf=100,t=d,i=%d,a=t,q=2;%s\e\\' "$IMAGE_ID" "$DATA" > "$TTY"

# ---------- Helper to get real terminal size from /dev/tty ----------
get_size() {
  local size
  size=$(stty size < "$TTY" 2>/dev/null) || { echo "24 80"; return; }
  echo "$size"
}

# ---------- Init bounce state ----------
read -r rows cols <<< "$(get_size)"

x=$(( RANDOM % (cols - LOGO_COLS > 1 ? cols - LOGO_COLS : 1) ))
y=$(( RANDOM % (rows - LOGO_ROWS > 1 ? rows - LOGO_ROWS : 1) ))
dx=1
dy=1

printf '\e[?25l' > "$TTY"

# ---------- Animation loop ----------
while true; do
  read -r rows cols <<< "$(get_size)"

  # Place with p=1 — auto-replaces previous placement (no flash)
  printf '\e[%d;%dH' "$((y + 1))" "$((x + 1))" > "$TTY"
  printf '\e_Ga=p,i=%d,p=1,c=%d,r=%d,z=10,C=1,q=2;\e\\' \
    "$IMAGE_ID" "$LOGO_COLS" "$LOGO_ROWS" > "$TTY"

  # Advance position
  x=$(( x + dx ))
  y=$(( y + dy ))

  (( x <= 0 ))                  && { x=0;                       dx=1;  }
  (( x + LOGO_COLS >= cols ))   && { x=$(( cols - LOGO_COLS ));  dx=-1; }
  (( y <= 0 ))                  && { y=0;                       dy=1;  }
  (( y + LOGO_ROWS >= rows ))   && { y=$(( rows - LOGO_ROWS )); dy=-1; }

  sleep 0.08
done
