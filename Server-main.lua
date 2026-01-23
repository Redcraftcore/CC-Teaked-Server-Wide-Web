--Server v2
local modem = peripheral.wrap("top")
local disk = peripheral.wrap("bottom")
--Name settings
local Servername = "test"
local domain = ".com"
--host and log for host start
rednet.open("top")
rednet.host("online",tostring(Servername..domain))
term.clear()
print("server hosted under"..tostring(Servername..domain))                  --log stamp
--table for sending data


--main handle loop
local function handle()
    while true do
        local Cid , rmsg = rednet.receive()

        --request type check(not yet implemented)
        if rmsg.type == "req" then
            print("Computer"..Cid.." requested page")                       --log stamp
            RCR(Cid,rmsg)
        elseif rmsg.type == "rel" then
            print("Computer"..Cid.." requested reload of page")             --log stamp
            RCR(Cid,rmsg)
        else
            rednet.send(Cid,"Malformed msg try again")
        end
        os.sleep(0.025)
    end
end
--region clarify redirect
function RCR(Cid, rmsg)
    local page = rmsg.page or "home"
    print("Computer "..Cid.." requested "..page)
    local file = fs.open("/disk/"..page..".json", "r")
    if not file then
        file = fs.open("/disk/home.json", "r")
        page = "home"
    end

    -- Read JSON
    local raw = file.readAll()
    file.close()

    local pageTable = textutils.unserializeJSON(raw)

    -- Build packet
    local packet = {
        type = "rel",
        page = page,
        payload = pageTable
    }

    -- Send packet
    rednet.send(Cid, packet)
end



--start main function
handle()