-- Keep only your personal input overrides here. Uncommented settings below
-- replace Omarchy's defaults.

-- Slower keyboard repeat delay than the default (250).
hl.config({
  input = {
    repeat_delay = 600,
  },
})

-- Magic Trackpad Apple
hl.device({
  name = "apple-inc.-magic-trackpad-usb-c",
  sensitivity = 0.15,
  scroll_factor = 0.08,
  natural_scroll = true,
  accel_profile = "adaptive",
})

-- SteelSeries Aerox 5 wireless (first endpoint)
hl.device({
  name = "steelseries-steelseries-aerox-5-wireless",
  sensitivity = 0,
  accel_profile = "flat",
})

-- SteelSeries Aerox 5 wireless (second endpoint)
hl.device({
  name = "steelseries-steelseries-aerox-5-wireless-3",
  sensitivity = 0,
  accel_profile = "flat",
})

-- 3-finger horizontal swipe to change workspaces.
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
