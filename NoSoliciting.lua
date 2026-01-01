local defaultFrame = DEFAULT_CHAT_FRAME
local defaultWrite = DEFAULT_CHAT_FRAME.AddMessage
local log = function(text, r, g, b, group, holdTime)
  defaultWrite(defaultFrame, tostring(text), r, g, b, group, holdTime)
end

-- Cache of joined channels for faster lookup
local joinedChannels = {}

-- Function to update the joined channels cache
local function updateJoinedChannels()
    -- Clear the table manually (table.wipe doesn't exist in Lua 5.0)
    for k in pairs(joinedChannels) do
        joinedChannels[k] = nil
    end
    
    local channelList = {GetChannelList()}
    
    for i = 1, table.getn(channelList), 3 do
        local channelIndex = channelList[i]
        local channelName = channelList[i + 1]
        if channelName then
            joinedChannels[string.lower(channelName)] = true
        end
    end
end

-- Check if a channel should be filtered
local function shouldFilterChannel(channelName)
    if not channelName then return false end
    
    channelName = string.lower(channelName)
    
    -- Always filter World, Trade, Say, and Yell
    if channelName == "world" or channelName == "trade" or 
       channelName == "say" or channelName == "yell" then
        return true
    end
    
    -- Check if this is a joined channel
    if joinedChannels[channelName] then
        return true
    end
    
    return false
end

local hookChatFrame = function(frame)
  if (not frame) then return end
  
  local original = frame.AddMessage
  if (original) then
    frame.AddMessage = function(t, message, r, g, b, id)
      if (NoSoliciting_Enabled) then
        local channel = nil
        local found = false
        
        -- Try multiple patterns to extract channel
        
        -- Pattern 1: Channel messages like "[1. Trade]"
        found, _, channel = string.find(message, "^%[%d+%. ([^%]]+)%]")
        
        -- Pattern 2: Simple channel messages like "[Trade]"
        if not found then
            found, _, channel = string.find(message, "^%[([^%]]+)%]")
        end
        
        -- Pattern 3: Player name prefix for say/yell (e.g., "Player says:")
        if not found then
            -- Check for " says: " or " yells: " pattern
            if string.find(message, " says: ") then
                channel = "Say"
                found = true
            elseif string.find(message, " yells: ") then
                channel = "Yell"
                found = true
            end
        end
        
        -- Pattern 4: Try to find any ":" as delimiter
        if not found then
            local colonPos = string.find(message, ": ")
            if colonPos then
                -- Check if it looks like a player name followed by action
                local prefix = string.sub(message, 1, colonPos - 1)
                if string.find(prefix, " says$") then
                    channel = "Say"
                    found = true
                elseif string.find(prefix, " yells$") then
                    channel = "Yell"
                    found = true
                end
            end
        end
        
        if (found and channel and shouldFilterChannel(channel)) then
            -- Check if message contains any keyword
            if (NoSoliciting_FindKeyword(message)) then
                -- Message contains keyword, so HIDE it
                return
            end  
        end
      end
      
      -- Use the correct argument passing for Lua 5.0
      if r then
          original(t, message, r, g, b, id)
      else
          original(t, message)
      end
    end
  else
    log("Tried to hook non-chat frame")
  end
end

function NoSoliciting_FindKeyword(message)
    -- Convert message to lowercase for case-insensitive matching
    local lowerMessage = string.lower(message)
    
    for pattern, _ in pairs(NoSoliciting_KeyWords) do
        -- Check if the keyword appears in the message
        if (string.find(lowerMessage, pattern, 1, true)) then
            return true
        end
    end
    return false
end

function NoSoliciting_OnLoad()
    this:RegisterEvent("VARIABLES_LOADED")
    this:RegisterEvent("CHANNEL_UI_UPDATE") -- Update when channels change

    -- Set up slash commands.
    SlashCmdList["NOSOLICITING"] = NoSoliciting_CmdRelay
    SLASH_NOSOLICITING1 = "/ns"
    SLASH_NOSOLICITING2 = "/nosoliciting"
end

local hookFunctions = function()
    hookChatFrame(ChatFrame1)
    hookChatFrame(ChatFrame2)
    hookChatFrame(ChatFrame3)
    hookChatFrame(ChatFrame4)
    hookChatFrame(ChatFrame5)
    hookChatFrame(ChatFrame6)
    hookChatFrame(ChatFrame7)
end

local initialize = function()
    if not NoSoliciting_KeyWords then
        NoSoliciting_KeyWords = {}
    end
    if NoSoliciting_Enabled == nil then
        NoSoliciting_Enabled = true
    end
    
    -- Initialize joined channels cache
    updateJoinedChannels()
    
    hookFunctions()
    
    log(string.format("NoSoliciting loaded (%s)", (NoSoliciting_Enabled and "enabled") or "disabled"))
    log("Hiding messages containing keywords in all channels (World, Trade, Say, Yell, etc.)")
    
    -- Test message to show it's working
    log("Test: Add keyword 'test' with /ns add test to filter messages containing 'test'")
end

-- Event handler.
function NoSoliciting_OnEvent()
    if (event == "VARIABLES_LOADED") then
        initialize()
    elseif (event == "CHANNEL_UI_UPDATE") then
        updateJoinedChannels()
    end
end

local commands = {
    ["add"] = function(args)
        local found, _, keyword = string.find(args or "", "^%s*(%S+)")
        if (found) then
            -- Store keywords in lowercase for case-insensitive matching
            keyword = string.lower(keyword)
            NoSoliciting_KeyWords[keyword] = true
            log(string.format("Added '%s' to filter list." , keyword))
        else
            log("/ns add <keyword> - add a keyword to filter list.")
        end
    end,
    
    ["del"] = function(args)
        local found, _, keyword = string.find(args or "", "^%s*(%S+)")
        if (found) then
            keyword = string.lower(keyword)
            if (NoSoliciting_KeyWords[keyword]) then
                NoSoliciting_KeyWords[keyword] = nil
                log(string.format("Removed '%s' from filter list." , keyword))
            else
                log(string.format("'%s' is not on the filter list." , keyword))
            end
        else
            log("/ns del <keyword> - removes a keyword from filter list.")
        end
    end,
    
    ["on"] = function(args)
        NoSoliciting_Enabled = true
        log("NoSoliciting enabled - hiding messages with keywords")
    end,
    
    ["off"] = function(args)
        NoSoliciting_Enabled = false
        log("NoSoliciting disabled - showing all messages")
    end,

    ["list"] = function()
        local keywords = {}
        log("Keywords on the filter list (case-insensitive):")
        for keyword,_ in pairs(NoSoliciting_KeyWords) do
            table.insert(keywords, keyword)
        end
        
        if table.getn(keywords) == 0 then
            log("  No keywords in filter list")
        else
            log("  " .. table.concat(keywords, ", "))
        end
    end,
    
    ["channels"] = function()
        log("Currently filtering these channels:")
        local channelNames = {}
        
        -- Always include World, Trade, Say, and Yell
        table.insert(channelNames, "World")
        table.insert(channelNames, "Trade")
        table.insert(channelNames, "Say")
        table.insert(channelNames, "Yell")
        
        -- Add all joined channels
        for channelName, _ in pairs(joinedChannels) do
            table.insert(channelNames, channelName)
        end
        
        log("  " .. table.concat(channelNames, ", "))
    end,
    
    ["refresh"] = function()
        updateJoinedChannels()
        log("Channel list refreshed")
    end,
    
    ["test"] = function()
        log("Testing channel detection patterns...")
        log("Add a test keyword: /ns add testfilter")
        log("Then try saying/yelling 'testfilter' to see if it's filtered")
        log("Also try in trade/world: [Trade] testfilter")
    end
}

-- Metatable for commands to provide default help
local commandMeta = {
    __index = function()
        return function()
            log("NoSoliciting - Hides messages containing keywords in all channels")
            log("Commands:")
            log("  /ns add <keyword>     - add a keyword to filter list.")
            log("  /ns del <keyword>     - removes a keyword from filter list.")
            log("  /ns list              - lists all keywords currently active.")
            log("  /ns channels          - shows which channels are being filtered")
            log("  /ns refresh           - refresh the list of joined channels")
            log("  /ns test              - run a test to verify filtering works")
            log("  /ns on/off            - temporarily enables/disables filtering")
            log("Filtered channels: World, Trade, Say, Yell, and all joined channels")
            log("Note: Keywords are case-insensitive!")
        end
    end
}

setmetatable(commands, commandMeta)

-- Command-line handler.
function NoSoliciting_CmdRelay(args)
    if args then
        local _, _, cmd, subargs = string.find(args, "^%s*(%S-)%s(.+)$")
        if not cmd then
            cmd = string.gsub(args, "^%s*(%S+)%s*$", "%1")
            if cmd == "" then cmd = args end
        end
        
        if cmd and commands[string.lower(cmd)] then
            commands[string.lower(cmd)](subargs)
        else
            commands[""]() -- Show help
        end
    else
        commands[""]() -- Show help
    end
end