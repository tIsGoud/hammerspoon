-----------------------------------------------
-- Hyper.lua
-----------------------------------------------

-- The clean modal keybindings are made possible due to a comment from Steve Kehlet (github/skehlet),
-- he mentioned that there is no need to assign a key to the modal key.
-- With that a much cleaner piece of code.
-- Important here is the Karabiner-elements configuration where the "to_if_alone"-section
-- is used to restore the original key function.

-- In karabiner-elements set 'tab' to f18/escape
hyper = hs.hotkey.modal.new({}, nil)
hs.hotkey.bind({}, "f18", function () hyper:enter() end, function () hyper:exit() end)
