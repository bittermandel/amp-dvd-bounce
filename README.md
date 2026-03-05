# amp-dvd-bounce

A small [Amp](https://ampcode.com) plugin that shows a bouncing DVD logo while the agent is running, because nothing says "deep work" like watching it miss the corner for five minutes.

## How it works

The plugin uses the [Kitty graphics protocol](https://sw.kovidgoyal.net/kitty/graphics-protocol/) to draw `dvd-logo.png` as an overlay in the terminal.

- On `agent.start`, it launches `dvd-bounce-render.sh` in the background.
- On `agent.end`, it stops that process and clears the overlay.

## Supported terminals

Works in terminals with Kitty graphics support, including:

- [Ghostty](https://ghostty.org)
- [Kitty](https://sw.kovidgoyal.net/kitty/)
- [WezTerm](https://wezfurlong.org/wezterm/)
- [Konsole](https://konsole.kde.org/) (partial)

Does not work in iTerm2, Terminal.app, Alacritty, or tmux.

## Install

Clone the plugin into your Amp plugins directory:

```bash
git clone https://github.com/bittermandel/amp-dvd-bounce ~/.config/amp/plugins/dvd-bounce
```

Start Amp with plugins enabled:

```bash
PLUGINS=all amp
```
