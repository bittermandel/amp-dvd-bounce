# amp-dvd-bounce

Bouncing DVD logo screensaver for [Amp](https://ampcode.com) — renders while the agent is thinking.

## How it works

Uses the [Kitty graphics protocol](https://sw.kovidgoyal.net/kitty/graphics-protocol/) to render the official DVD VIDEO logo as a transparent PNG overlay on top of your terminal. The image floats over your content without destroying it — no ANSI hacks, no screen corruption.

- `agent.start` → spawns a background process that bounces the logo
- `agent.end` → kills the process and removes the image overlay

## Supported terminals

Any terminal with Kitty graphics protocol support:

- [Ghostty](https://ghostty.org)
- [Kitty](https://sw.kovidgoyal.net/kitty/)
- [WezTerm](https://wezfurlong.org/wezterm/)
- [Konsole](https://konsole.kde.org/) (partial)

Will not work in: iTerm2, Terminal.app, Alacritty, tmux.

## Install

Clone into your Amp plugins directory:

```bash
git clone https://github.com/bittermandel/amp-dvd-bounce ~/.config/amp/plugins/dvd-bounce
```

Run Amp with plugins enabled:

```bash
PLUGINS=all amp
```
