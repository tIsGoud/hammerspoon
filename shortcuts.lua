-----------------------------------------------
-- Deprecated shortcuts
-- Shortcuts are handled in Karabiner
-----------------------------------------------

-- Bind Hyper key + 'l' to lockscreen
hyper:bind({}, "l", function()
  -- lockScreen, systemSleep, startScreensaver
  hs.caffeinate.systemSleep()
  hyper.triggered = true
end)

-- Bind Hyper key + 'control' + 'l' to start screenSaver
hyper:bind({"ctrl"}, "l", function()
  -- lockScreen, systemSleep, startScreensaver
  hs.caffeinate.startScreensaver()
  hyper.triggered = true
end)

function hyperLaunchApp(object)
    hyper:bind({object.modifier}, object.key, function()
        hyper.triggered = true
        hs.application.launchOrFocus(object.app)
        local application = hs.application.get(object.app)
        if application ~= nil then
            local window = application:focusedWindow()
        end
    end)
end

-- Launch and focus applications with 'hyper' and shortkeys
hs.fnutils.each({
    { key = "/", modifier = nil, app = "Finder" },
    { key = "i", modifier = nil, app = "iTerm" },
    { key = "t", modifier = "alt,ctrl", app = "Terminal" },
    { key = "p", modifier = nil, app = "Preview" },
    { key = "1", modifier = nil, app = "Safari" },
    { key = "2", modifier = nil, app = "Firefox Developer Edition" },
    { key = "3", modifier = nil, app = "Iridium" },
    { key = "c", modifier = nil, app = "VSCodium" },
    { key = "b", modifier = nil, app = "Bitwarden" },
}, function(object)
    hyperLaunchApp(object)
end)

function launchApp(object)
    hs.hotkey.bind({object.modifier}, object.key, function()
        hyper.triggered = true
        hs.application.launchOrFocus(object.app)
        local application = hs.application.get(object.app)
        if application ~= nil then
            local window = application:focusedWindow()
        end
    end)
end

-- Launch and focus applications with shortkeys
hs.fnutils.each({
    { key = "f", modifier = "alt-ctrl", app = "Finder" },
    { key = "t", modifier = "alt,ctrl", app = "iTerm" },
}, function(object)
    launchApp(object)
end)

-- Examine the available keycodes:
-- hs.inspect(hs.keycodes.map)
