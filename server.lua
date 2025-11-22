--DEV SERVER ENV version 1 
local modem = peripheral.wrap("back")
local servername = "test"
local serverhandler = "http"
local domain = ".de"
layer1 = fs.open("file.lua","r")
local content = layer1.readAll()
rednet.open("back")
-- Host DNS
rednet.host(tostring(serverhandler),tostring(servername)..tostring(domain))
print("hosted "..servername..domain.." @ "..serverhandler)

--handles requests
local function handler()
    while true do
        local clientid , message = rednet.receive(serverhandler)
        if message == "request" or "reload" then
            rednet.send(tonumber(clientid),content,tostring(serverhandler))
            print("# recieved pull req from Computer with Id:"..tostring(clientid))
        end
    end
end
handler(true)