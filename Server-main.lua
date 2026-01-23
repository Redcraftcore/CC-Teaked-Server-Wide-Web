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
    print("Computer"..Cid.." requested "..page)
    local file = fs.open("/disk/"..page..".json", "r")
    -- Redirect to home if missing
    if not file then
        file = fs.open("/disk/home.json", "r")
        page = "home"
    end
    -- Read JSON → table
    local pageTable = textutils.unserializeJSON(file.readAll())
    file.close()
    -- Build packet
    local csmg = {
        type = "rel",
        page = page,
        payload = pageTable
    }

    -- Send packet
    rednet.send(Cid, csmg)
end


--start main function
handle()