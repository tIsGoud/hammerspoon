-----------------------------------------------------------------------------
-- Init.lua
-----------------------------------------------------------------------------
hs.logger.defaultLogLevel="info"
hs.window.animationDuration = 0

-- "hyper" is configured as "tab" in Karabiner-Elements
hyper = {"ctrl","'alt","'cmd","shift"}
ctrl_opt = {"ctrl","option"}
ctrl_cmd = {"ctrl","cmd"}
ctrl_shift = {"ctrl", "shift"}

-- Get the hostname
hostname = hs.host.localizedName()

-----------------------------------------------------------------------------
-- Load SpoonInstall, so we can easily load our other Spoons
-----------------------------------------------------------------------------
hs.loadSpoon("SpoonInstall")
spoon.SpoonInstall.use_syncinstall = true
Install=spoon.SpoonInstall

-----------------------------------------------------------------------------
-- ReloadConfiguration
-----------------------------------------------------------------------------
-- Install:andUse("ReloadConfiguration",
--   {
--     watch_paths = hs.configdir,
--     hotkeys = {
--       reloadConfiguration =  { hyper, "r" }
--     }
--   }
-- )

hs.hotkey.bind(hyper, "r", function()
  hs.reload()
end)

-----------------------------------------------------------------------------
-- MiroWindowsManager, hotkey plus arrows position and size the wondows
-----------------------------------------------------------------------------
Install:andUse("MiroWindowsManager",
  {
    config = {
      sizes = {2, 3, 3/2}
    },
    hotkeys = {
      up =         { ctrl_opt, "up" },
      right =      { ctrl_opt, "right" },
      down =       { ctrl_opt, "down" },
      left =       { ctrl_opt, "left" },
      fullscreen = { ctrl_opt, "return" }
    }
  }
)

-----------------------------------------------------------------------------
-- WindowScreenLeftAndRight, move window to left or right screen
-- default hotkeys ("ctrl", "alt", "cmd") and left- or right arrow
-----------------------------------------------------------------------------
Install:andUse("WindowScreenLeftAndRight",
  {
    config = {
      animationDuration = 0
    },
    hotkeys = {
      screen_left = {  ctrl_shift, "left"},
      screen_right = { ctrl_shift, "right"}
    }
  }
)

-----------------------------------------------------------------------------
-- MouseCircle, draw a darkred circle around the mouse cursor
-----------------------------------------------------------------------------
Install:andUse("MouseCircle",
  {
    config = {
      color = hs.drawing.color.x11.darkred
    },
    hotkeys = {
      show = { hyper, "m" }
    }
  }
)

-----------------------------------------------------------------------------
-- PopupTranslateSelection, show a popup window with the translation of the
-- currently selected (or other) text
-----------------------------------------------------------------------------
local wm=hs.webview.windowMasks
Install:andUse("PopupTranslateSelection",
  {
    -- config = {
    --   popup_style = wm.utility|wm.HUD|wm.titled|
    --     wm.closable|wm.resizable,
    -- },
    hotkeys = {
      translate_nl_en = { hyper, "e" },
      translate_en_nl = { hyper, "d" }
    }
  }
)

-----------------------------------------------
-- WiFinotifier.lua
-----------------------------------------------

-- Current functionality is just a notification with the network name
-- Would be nice to turn on a VPN on an untrusted WiFi network

wifiWatcher = nil
homeSSID = "tisgoud"
workSSID = ""
lastSSID = hs.wifi.currentNetwork()

function ssidChangedCallback()
    newSSID = hs.wifi.currentNetwork()

    if newSSID == homeSSID and lastSSID ~= homeSSID then
        -- We just joined our home WiFi network
        hs.notify.new({title="WiFI", informativeText=string.format("Connected to %q", homeSSID)}):send()
    elseif newSSID ~= homeSSID and lastSSID == homeSSID then
        -- We just departed our home WiFi network
        hs.alert.show(string.format("WiFi connected to %q", newSSID), 3)
    end

    lastSSID = newSSID
end

wifiWatcher = hs.wifi.watcher.new(ssidChangedCallback)
wifiWatcher:start()