-----------------------------------------------------------------------------
-- Init.lua
-----------------------------------------------------------------------------
hs.logger.defaultLogLevel="debug"
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
-- MicMute, mute the microphone
-----------------------------------------------------------------------------
Install:andUse("MicMute")

-- Eventhandler
hs.urlevent.bind("toggleMic", function(eventName, params)
    spoon.MicMute:toggleMicMute()
end)

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

-- Eventhandler
hs.urlevent.bind("reloadConfig", function(eventName, params)
    hs.reload()
    hs.notify.new({title="Hammerspoon", informativeText="Reloaded configuration"}):send()
end)

-----------------------------------------------------------------------------
-- MiroWindowsManager, hotkey plus arrows position and size the wondows
-----------------------------------------------------------------------------
Install:andUse("MiroWindowsManager",
  {
    config = {
      fullScreenSizes = {1,4/3},  -- 1/1 or 3/4 of the total screen's size
      sizes = {2, 3, 3/2}         -- 1/2, 1/3 and 2/3 of the total screen's size
    },
    hotkeys = {
      up =         { hyper, "up" },
      right =      { hyper, "right" },
      down =       { hyper, "down" },
      left =       { hyper, "left" },
      fullscreen = { hyper, "return" }
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
      screen_left = { ctrl_shift, "left"},
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

-- Eventhandler
hs.urlevent.bind("showMouse", function(eventName, params)
    spoon.MouseCircle:show()
end)

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
      translate_nl_en = { hyper, "n" },
      translate_en_nl = { hyper, "e" },
      translate_de_nl = { hyper, "d" }
    }
  }
)

-- EventHandlers
hs.urlevent.bind("translate_NL_to_EN", function(eventName, params)
    spoon.PopupTranslateSelection:translateSelectionPopup(en, nl)
end)

hs.urlevent.bind("translate_EN_to_NL", function(eventName, params)
    spoon.PopupTranslateSelection:translateSelectionPopup(nl, en)
end)

hs.urlevent.bind("translate_DE_to_NL", function(eventName, params)
    spoon.PopupTranslateSelection:translateSelectionPopup(nl, de)
end)

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

-----------------------------------------------
-- URL Event handlers not working
-----------------------------------------------

hs.urlevent.bind("Up", function(eventName, params)
    spoon.MiroWindowsManager:up()
end)

hs.urlevent.bind("Down", function(eventName, params)
    spoon.MiroWindowsManager:down()
end)