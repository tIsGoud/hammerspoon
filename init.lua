------------------------------------------------------------
-- Init.lua
------------------------------------------------------------
hs.logger.defaultLogLevel="info"

--require "hammer"
--require "windowmanagement"
require "wifinotifier"

-- Capture the hostname, so we can make this config behave differently across my Macs
hostname = hs.host.localizedName()

------------------------------------------------------------
-- Reload config on write
------------------------------------------------------------
local function reload_config()
  hs.reload()
end

hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reload_config):start()
hs.alert.show("Hammerspoon config (re)loaded")

-----------------------------------------------
-- Bind the hammer key
-----------------------------------------------

-- The clean modal keybindings are made possible due to a comment from Steve Kehlet (github/skehlet),
-- he mentioned that there is no need to assign a key to the modal key.
-- With that a much cleaner piece of code.
-- Important here is the Karabiner-elements configuration where the "to_if_alone"-section
-- is used to restore the original key function.

-- In karabiner-elements set 'tab' to f18/escape

hammer = hs.hotkey.modal.new()
f18 = hs.hotkey.bind({}, 'f18', function () hammer:enter() end, function () hammer:exit() end)

------------------------------------------------------------
-- Load SpoonInstall, so we can easily load our other Spoons
------------------------------------------------------------
hs.loadSpoon("SpoonInstall")
spoon.SpoonInstall.use_syncinstall = true
Install=spoon.SpoonInstall

------------------------------------------------------------
-- Draw a circle around the mouse cursor
------------------------------------------------------------
Install:andUse("MouseCircle",
                {
                    disable = false,
                    config = {
                        color = hs.drawing.color.x11.darkred
                },
                hotkeys = {
                    show = { {hammer}, "m" }
                }
            }
)
------------------------------------------------------------
-- Direct URLs automatically based on patterns
-- See https://github.com/zzamboni/dot-hammerspoon/blob/master/init.org
------------------------------------------------------------
Install:andUse("URLDispatcher",
  {
    config = {
      url_patterns = {
          {"https?://%w+.zoom.us", "us.zoom.xos", ""}
      },
      url_redir_decoders = {
        -- Send MS Teams URLs directly to the app
        { "MS Teams URLs",
        "(https://teams.microsoft.com.*)", "msteams:%1", true },
        -- Preview incorrectly encodes the anchor
        -- character in URLs as %23, we fix it
        { "Fix broken Preview anchor URLs", "%%23", "#", false, "Preview" },
      },
      default_handler = "com.apple.Safari"
    },
    start = true
  }
)
