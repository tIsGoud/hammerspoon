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
