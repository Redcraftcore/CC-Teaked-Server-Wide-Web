-- client.lua
local basalt = require("basalt")
local modem = peripheral.find("modem",rednet.open)
local execpath = "cache.lua"
--basalt browser head
local main = basalt.getMainFrame()

--searchbar
main:addLabel()
    :setText("HTTP://")
    :setPosition(0, 1)
main:addLabel()
    :setText("--------------------------")
    :setPosition(0, 2)
local search = main:addInput()    
search:setPosition(8, 1)        -- place next to label
      :setSize(15, 1)            -- width of the search bar
      :setText("") -- placeholder text
      :setBackground(colors.lightGray)
      :setForeground(colors.black)
main:addButton()
    :setText("Load")
    :setPosition(23,1)
    :setSize(4,1)
    :onClick(function ()
        local serverId = rednet.lookup("http",search:getText())
            rednet.send(serverId, "request","http")
        

    end)
--tab frame
local tab = main:addFrame()     --creates frame
tab:setPosition(0,3)
    :setSize(27,18)
    :setBackground(colors.lightGray)
local program = tab:addProgram()        --adds programm from cache to frame
program:setPosition(0,0)
    :setSize(27,18)
    :setBackground(colors.lightGray)
    --Background Handler of the client side
local function handler()
    while true do
        local id , reply = rednet.receive("http")
        if reply then
            local file = fs.open("cache.lua", "w")
            file.write(reply)
            file.close()  -- important!
            program:execute("cache.lua")  -- execute AFTER file is written
        end
    end
end
--starts both ui and handler
parallel.waitForAny(basalt.run,handler)