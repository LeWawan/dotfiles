-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- ---------------------------------------------------------------------------
-- Personal keymaps (migrated from bindings.conf)
-- ---------------------------------------------------------------------------

-- Vim-style focus movement: SUPER + h/j/k/l
-- (these conflict with the defaults SUPER+J toggle split, SUPER+K keybindings,
-- SUPER+L toggle layout, so unbind them first)
hl.unbind("SUPER + J")
hl.unbind("SUPER + K")
hl.unbind("SUPER + L")

o.bind("SUPER + H", "Focus on left window", hl.dsp.focus({ direction = "l" }))
o.bind("SUPER + J", "Focus on below window", hl.dsp.focus({ direction = "d" }))
o.bind("SUPER + K", "Focus on above window", hl.dsp.focus({ direction = "u" }))
o.bind("SUPER + L", "Focus on right window", hl.dsp.focus({ direction = "r" }))

-- Workspace switching: CTRL + SUPER + h/j/k/l -> workspaces 1..4
-- (defaults SUPER+CTRL+H hardware menu, SUPER+CTRL+K herdr keybindings,
-- SUPER+CTRL+L lock system conflict, so unbind them first)
hl.unbind("SUPER + CTRL + H")
hl.unbind("SUPER + CTRL + K")
hl.unbind("SUPER + CTRL + L")

o.bind("CTRL + SUPER + H", "Switch to workspace 1", hl.dsp.focus({ workspace = "1" }))
o.bind("CTRL + SUPER + J", "Switch to workspace 2", hl.dsp.focus({ workspace = "2" }))
o.bind("CTRL + SUPER + K", "Switch to workspace 3", hl.dsp.focus({ workspace = "3" }))
o.bind("CTRL + SUPER + L", "Switch to workspace 4", hl.dsp.focus({ workspace = "4" }))

-- Move window to workspace: CTRL + SHIFT + h/j/k/l -> workspaces 1..4
o.bind("CTRL + SHIFT + H", "Move window to workspace 1", hl.dsp.window.move({ workspace = "1" }))
o.bind("CTRL + SHIFT + J", "Move window to workspace 2", hl.dsp.window.move({ workspace = "2" }))
o.bind("CTRL + SHIFT + K", "Move window to workspace 3", hl.dsp.window.move({ workspace = "3" }))
o.bind("CTRL + SHIFT + L", "Move window to workspace 4", hl.dsp.window.move({ workspace = "4" }))

-- Layout scrolling: SUPER + SHIFT + L (was SUPER+L in old config)
o.bind("SUPER + SHIFT + L", "Toggle workspace layout", "omarchy-hyprland-workspace-layout-toggle")

-- Brightness toggle: SUPER + CTRL + M
o.bind("SUPER + CTRL + M", "Toggle night brightness", "/home/wawan/.local/bin/omarchy-toggle-brightness")

-- ---------------------------------------------------------------------------
-- Personal application bindings (migrated from bindings.conf)
-- ---------------------------------------------------------------------------

-- Typora (replaces default Omawrite on SUPER+SHIFT+W)
hl.unbind("SUPER + SHIFT + W")
o.bind("SUPER + SHIFT + W", "Typora", { launch = "typora --enable-wayland-ime" })

-- Steam (replaces default Google Maps on SUPER+SHIFT+S)
hl.unbind("SUPER + SHIFT + S")
o.bind("SUPER + SHIFT + S", "Steam", { launch = "steam", focus = "steam" })

-- Dashlane (replaces default 1password on SUPER+SHIFT+SLASH)
hl.unbind("SUPER + SHIFT + SLASH")
o.bind("SUPER + SHIFT + SLASH", "Dashlane", { webapp = "chrome-extension://fdjamakpfbbddfjaooikfcpapjohcfmg/index.html##/credentials" })

-- Discord
o.bind("SUPER + SHIFT + ALT + D", "Discord", { webapp = "https://discord.com/channels/@me", focus = true })

-- Element (replaces default New email on SUPER+SHIFT+ALT+E)
hl.unbind("SUPER + SHIFT + ALT + E")
o.bind("SUPER + SHIFT + ALT + E", "Element", { webapp = "https://app.element.io/#/home", focus = true })

-- MammouthAI (replaces default ChatGPT on SUPER+SHIFT+A)
hl.unbind("SUPER + SHIFT + A")
o.bind("SUPER + SHIFT + A", "MammouthAI", { webapp = "https://mammouth.ai/app/a/default" })

-- Proton Mail (replaces default hey Email on SUPER+SHIFT+E)
hl.unbind("SUPER + SHIFT + E")
o.bind("SUPER + SHIFT + E", "Email", { webapp = "https://mail.proton.me/u/4/inbox" })

-- Proton Calendar (replaces default hey Calendar on SUPER+SHIFT+C)
hl.unbind("SUPER + SHIFT + C")
o.bind("SUPER + SHIFT + C", "Calendar", { webapp = "https://calendar.proton.me/u/4/" })

-- Proton Drive (replaces default Docker on SUPER+SHIFT+D)
hl.unbind("SUPER + SHIFT + D")
o.bind("SUPER + SHIFT + D", "Drive", { webapp = "https://drive.proton.me/u/0/" })

-- WhatsApp (default uses SUPER+SHIFT+ALT+G; keep both)
o.bind("SUPER + SHIFT + ALT + W", "WhatsApp", { webapp = "https://web.whatsapp.com/", focus = true })

-- Activity (CCTV), replaces default voxtype dictation on SUPER+CTRL+X
hl.unbind("SUPER + CTRL + X")
o.window("org.omarchy.cctv", { tag = "+floating-window" })
o.bind(
  "SUPER + CTRL + X",
  "Activity",
  'CCTV_DAEMON_PASSWORD="$(secret-tool lookup service cctv type password)" omarchy-launch-tui cctv'
)
