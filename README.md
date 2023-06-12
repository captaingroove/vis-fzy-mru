# Fuzzy find and open most recently used files in vis

Use [fzy](https://github.com/jhawthorn/fzy.git) to open most recently used files in [vis](https://github.com/martanne/vis).

## Usage

In vis:

`:fzymru`

## Configuration

In visrc.lua:

```lua
plugin_vis_mru_fzy = require('plugins/vis-fzy-mru')

-- Path to the fzy executable (default: "fzy")
plugin_vis_mru_fzy.fzymru_path = "fzy"

-- Arguments passed to fzy (default: "")
plugin_vis_mru_fzy.fzymru_args = ""

-- File path to file history (default: "$HOME/.mru") 
plugin_vis_mru_fzy.fzymru_filepath = os.getenv("HOME") .. "/.vismru"

-- The number of most recently used files kept in history (default: 20)
plugin_vis_mru_fzy.fzymru_history = 60

-- Mapping configuration example (<Space>f)
vis.events.subscribe(vis.events.INIT, function()
    vis:map(vis.modes.NORMAL, " f", ":fzymru<Enter>", "most recent files")
end)
```

## Inspired by

- [vis-fzf-mru](https://github.com/peaceant/vis-fzf-mru.git)
