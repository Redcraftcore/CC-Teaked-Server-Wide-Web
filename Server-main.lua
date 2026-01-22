--Server v2
local modem = peripheral.wrap("top")
local disk = perhibial.wrap("bottom")
--Name settings
local Servername = "test"
local domain = ".com"
--host and log for host start
rednet.host("online",tostring(Servername..domain))
term.clear()
print("server hosted under"..tostring(Servername..domain))                  --log stamp

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
function RCR(Cid,rmsg)
    --region clarify redirect
    if rmsg.page == nil then
        print("Computer"..Cid.." requested Home")                       --log stamp
        fs.open("/disk/home","r")
    else
        print("Computer"..Cid.." requested "..tostring(rmsg.page))      --log stamp
        local cmsg = fs.open(tostring(rmsg.page),"r")
        rednet.send(Cid,cmsg)
    end
end

--start main function
handle()