-- CLIENT BROWSER (CLEAN + FIXED)

local serverID = 1
local history = {}
local currentPage = nil
local buttons = {}

rednet.open("back")  -- change if needed


-- Request function
local function requestPage(pageName)
    if pageName == nil then
        print("ERROR: Tried to request nil page")
        return
    end

    rednet.send(serverID, {
        type = "req",
        page = pageName
    })
end


-- Rendering
local function renderPage(payload)
    if payload == nil then
        term.clear()
        term.setCursorPos(1,1)
        print("ERROR: Server sent empty payload")
        return
    end
    term.clear()
    term.setCursorPos(1,1)
    print(payload.title or "")
    print("")
    buttons = {}
    local line = 3
    for _, element in ipairs(payload.elements or {}) do
        term.setCursorPos(1, line)
        if element.type == "text" then
            print(element.value)
        elseif element.type == "button" then
            print("[" .. element.label .. "]")
            buttons[line] = element
        end

        line = line + 1
    end
end


-- Navigation
local function navigateTo(pageName)
    if currentPage then
        table.insert(history, currentPage)
    end
    requestPage(pageName)
end


-- Go back in history
local function goBack()
    if #history > 0 then
        local last = table.remove(history)
        requestPage(last)
    end
end


-- Start on Home
navigateTo("Home")   -- IMPORTANT: matches your server's file name


-- Main event loop
while true do
    local event, p1, p2, p3 = os.pullEvent()
    
    -- Network packet received
    if event == "rednet_message" then
        local id, msg = p1, p2

        if type(msg) == "table" then
            if msg.type == "rel" then
                currentPage = msg.page
                renderPage(msg.payload)
            end

            if msg.type == "update" then
                renderPage(msg.payload)
            end
        else
            print("ERROR: Received non-table message")
        end
    end

    -- Mouse click
    if event == "mouse_click" then
        local _, x, y = p1, p2, p3

        local btn = buttons[y]
        if btn then
            if btn.goto then
                navigateTo(btn.goto)
            elseif btn.action == "back" then
                goBack()
            end
        end
    end
end
