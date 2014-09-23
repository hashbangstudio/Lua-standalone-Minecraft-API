require ('math')

local pathToThisFile = ...
local folderContainingThisFile = pathToThisFile:match(".+/") or ""
require (folderContainingThisFile..'connection')
require (folderContainingThisFile..'vec3')

map = function(func, table)
    for k,v in pairs(table) do
   --    print("in map ")
   --    print(k,v)
       table[k] = func(v)
    end
--    print ("end map")
--    print (table)
    return table
end

--TODO implement a split like functin
split = function(sep, string)
    assert (sep ~= "")
    local t={}
    for i in string.gmatch(string, '[^'..sep..']+') do
    --    print (t, i)
        table.insert(t, i)
    end
    return t
end

intFloor = function(inputArray)
    return map(toInteger, inputArray)
end

toInteger = function (num)
    return math.floor(tonumber(num)) or error("Could not create integer from "..tostring(num))
end

getNumFromStatusBool = function(boolean)
    if (boolean == 1 or string.lower(boolean) == 'true') then
        return 1
    else
        return 0
    end
end


CmdPositioner = {

new = function(self, conn, pkg)
    local obj = { conn = conn, pkg = pkg or "Unknown"}
    setmetatable(obj, self)
    self.__index=self
    return obj
end,

--Methods for setting and getting positions
getPos = function(self, id)
    --Get entity position (entityId:int) = Vec3
    local s = self.conn:sendAndReceive(self.pkg..".getPos", id)
    return Vec3:new(split(",",s))
end,

setPos = function(self, id, ...)
    --Set entity position (entityId:int, x,y,z)
    self.conn:send(self.pkg..".setPos", id, ...)
end,

getTilePos = function(self, id)
        local response = self.conn:sendAndReceive(self.pkg..".getTile", id)
        local result = Vec3:new(map(toInteger, split(",", response)))
        return result
end,

setTilePos = function(self, id, ...)
        --Set entity tile position (entityId:int) = Vec3
        self.conn:send(self.pkg..".setTile", id, intFloor({...}))
end,

setting = function(self, setting, status)
    --Set a player setting (setting, status). keys: autojump
    local status = getNumFromStatusBool(status)
    self.conn:send(self.pkg..".setting", setting, status)
end
}

CmdEntity = {
    --Methods for entities

new = function(self, conn)

    local positioner = CmdPositioner:new(conn, "entity")
    local obj = {conn = conn,
                cmdpos = positioner}

    setmetatable(obj, self)
    self.__index=self
    return obj
end

}

CmdPlayer = {
   --Methods for the host (Raspberry Pi) player
new = function(self, conn )
    local positioner = CmdPositioner:new(conn, "player")
    local obj = {conn = conn,
                cmdpos = positioner}

    setmetatable(obj, self)
    self.__index=self
    return obj
end,

getPos = function(self)
            return self.cmdpos:getPos({})
end,
setPos = function(self, ...)
    return self.cmdpos:setPos({}, ...)
end,
getTilePos = function(self)
    return self.cmdpos:getTilePos({})
end,

setTilePos = function(self, ...)
    return self.cmdpos:setTilePos({}, ...)
end,

setting = function(self, ...)
    return self.cmdpos:setting(...)
end
}

CmdCamera = {
new = function(self, conn )
    local obj = {conn = conn}
    setmetatable(obj, self)
    self.__index=self
    return obj
end,

setNormal = function(self, data)
    -- Set camera mode to normal Minecraft view ([entityId])
    self.conn:send("camera.mode.setNormal", data)
end,

setFixed = function(self)
    --  Set camera mode to fixed view
    self.conn:send("camera.mode.setFixed")
end,

setFollow = function(self, data)
    -- Set camera mode to follow an entity ([entityId])
    self.conn:send("camera.mode.setFollow", data)
end,

setPos = function(self, ...)
    -- Set camera entity position (x,y,z)
    self.conn:send("camera.setPos", ...)
end
}

CmdEvents = {
   -- Events

new = function(self, conn)
    local obj = {conn = conn}
    setmetatable(obj, self)
    self.__index=self
    return obj
end,

clearAll = function(self)
    -- Clear all old events
    self.conn:send("events.clear")
end,

pollBlockHits = function(self)
    -- Only triggered by sword = [BlockEvent]
    local resp = self.conn:sendAndReceive("events.block.hits")
    hitsArray = {}
    if not (resp == '') then
        events = split("|", resp)
        for k,e in ipairs(events) do
            entry = split(",", e)
            entry = map(toInteger, entry)
            table.insert(hitsArray, BlockEvent:Hit(entry))
        end
    end
    return hitsArray
end
}

Minecraft = {
--The main class to interact with a running instance of Minecraft Pi.

getBlock = function(self, ...)
    local t = {n=select("#",...), ...}
    --Get block (x,y,z) = id:int
    return toInteger(self.conn:sendAndReceive("world.getBlock", intFloor(t)))
end,

getBlockWithData = function(self, ...)
    local t = {n=select("#",...), ...}
    -- Get block with data (x,y,z) = Block
    local ans = self.conn:sendAndReceive("world.getBlockWithData", intFloor(t))
    idAndData = map(toInteger, split(",", ans))
    return Block:new(idAndData[1], idAndData[2])
end,

--
--        TODO
--
getBlocks = function(self, ...)
    local t = {n=select("#",...), ...}
    -- Get a cuboid of blocks (x0,y0,z0,x1,y1,z1) = [id:int]
    return toInteger(self.conn:sendAndReceive("world.getBlocks", intFloor(t)))
end,

setBlock = function(self, ...)
    --TODO need to flatten Block object if passed in to id and data
    local t = {n=select("#",...), ...}
    local numArgs = #t
    -- Check for if have a block passed as 4th argument
    -- if so then change Block to table representation
    if (numArgs == 4) then
        if type(t[4]) == 'table' then
        --    print ("could be a block")
            -- If have same metatable then are Blocks
            if (getmetatable(Block:new(0)) == getmetatable(t[4])) then
            --    print("has block meta table")
                local blkTable = t[4]:toValTable()
                local index = 4
                for k,v in pairs(blkTable) do
                    t[index] = v
                    index = index + 1
                end
            end
        end
    end
    --  Set block (x,y,z,id,[data])
    self.conn:send("world.setBlock", intFloor(t))
end,

setBlocks = function(self, ...)
    local t = {n=select("#",...), ...}
    local numArgs = #t
    -- Check for if have a block passed as 7th argument
    -- if so then change Block to table representation
    if (numArgs == 7) then
        if type(t[7]) == 'table' then
        --    print ("could be a block")
            -- If have same metatable then are Blocks
            if (getmetatable(Block:new(0)) == getmetatable(t[7])) then
            --    print("has block meta table")
                local blkTable = t[7]:toValTable()
                local index = 7
                for k,v in pairs(blkTable) do
                    t[index] = v
                    index = index + 1
                end
            end
        end
    end
    --  Set a cuboid of blocks (x0,y0,z0,x1,y1,z1,id,[data])
    self.conn:send("world.setBlocks", intFloor(t))
end,

getHeight = function(self, ...)
    print (...)
    local t = {n=select("#", ...), ...}
    --  Get the height of the world (x,z) = int
    local response = self.conn:sendAndReceive("world.getHeight", intFloor(t))
    print ("response is :"..response)
    return toInteger(response)
end,

getPlayerEntityIds = function(self)
    --   Get the entity ids of the connected players = [id:int]
    local ids = self.conn:sendAndReceive("world.getPlayerIds")
    local idArray = split("|", ids)
    return idArray
end,

saveCheckpoint = function(self)
    -- Save a checkpoint that can be used for restoring the world
    self.conn:send("world.checkpoint.save")
end,

restoreCheckpoint = function(self)
    -- Restore the world state to the checkpoint
    self.conn:send("world.checkpoint.restore")
end,

postToChat = function(self, msg)
   --Post a message to the game chat
   self.conn:send("chat.post", msg)
end,

setting = function(self, setting, status)
    -- Set a world setting (setting, status). keys: world_immutable, nametags_visible
    local status = getNumFromStatusBool(status)
    self.conn:send("world.setting", setting, status)
end,

create = function(self, address, port)
        address = address or "127.0.0.1"
        port = port or 4711
        return Minecraft:new(Connection:new(address, port))
end,

new = function(self, conn)
     local obj = {conn = conn,
                 camera = CmdCamera:new(conn),
                 entity = CmdEntity:new(conn),
                 player = CmdPlayer:new(conn),
                 events = CmdEvents:new(conn)
                }

    setmetatable(obj, self)
    self.__index=self
    return obj
end,

close = function(self)
    self.conn:close()
end
}
