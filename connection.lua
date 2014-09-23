require "socket"


function join(sep, tbl)
    local str = ""
    local numElements = table.getn(tbl)
    local iter = 1
    for k,v in pairs(tbl) do
       str = str..v
       if iter ~= numElements then
           str = str..","
       end
       iter = iter + 1
    end
    return str

end

function flattenIndexedTable (tbl)
    flatTable = {}
--    print( type(tbl), tbl)
    if (tbl ~= nil and type(tbl) == 'table') then
        for k,v in ipairs(tbl) do
        --    print(k,v)
            if (v ~= nil and type(v) == 'table') then
                table.insert(flatTable, flattenIndexedTable(v))
            else
                table.insert(flatTable, v)
            end
        end
    else
        table.insert(flatTable, tbl)
    end
    for k,v in pairs(flatTable) do
    --    print(k,v)
    end
    return flatTable
end

function flattenIndexedTableToString(tbl)
--    print( type(tbl), tbl)
    if (tbl ~= nil and type(tbl)== 'table') then
        local arrSz = table.getn(tbl)
    --    print("arrsz "..arrSz)
        if(arrSz > 0)then
            --Remove empty strings and join together
            return join(",", flattenIndexedTable(tbl));
        else
            return ""
        end
    else
        return tbl
    end
end

Connection = {

new = function (self, address, port)
    address = address or '127.0.0.1'
    port = port or 4711
    local sockTcp = socket.tcp()
   -- print (address)
   -- print (port)
    local connection = assert(socket.connect(address, port))
    local obj = { sock = sockTcp, conn = connection, lastSent="" }
    setmetatable(obj, self)
    self.__index=self
    return obj
end,

drain = function(self)

    while 1 do
        local list = socket.select({self.sock}, {}, 0.0)
        if self.sock ~= list[1]  then
            break
        end
        -- set timeout so that drain works
        -- TODO determine if should just set timeout as 0.01 in create() and leave it as such
        self.conn:settimeout(0.01)
        -- Note this requires the conn:settimeout(0.01) done in create() otherwise this blocks indefinitely
        local data = self.conn:receive(1500)
        if data == '' or not data then
            break
        end
    end
    -- set back to blocking mode
    self.conn:settimeout(nil)
end,

send = function (self, f, ...)
    self:drain()
--    print ("in send")
--    print (f)
--    print (...)
    local data = {n=select("#", ...), ...}
    local msgData = flattenIndexedTableToString(data)
--    print(msgData)
    local msg= f..'('
    if (msgData ~= nil and msgData ~= "") then
        msg = msg..msgData
    end
    msg= msg..')'
--    print ("~"..msg.."~")
    self.lastSent=msg
    self.conn:send(msg.."\n")
end,

receive = function (self)
    local line = self.conn:receive()
--    print (line)
    return line
end,

sendAndReceive = function (self, ...)
    --print ("in sendAndReceive")
    --print (...)
    self:send(...)
    local response = self:receive()
    --print("local response = "..response)
    return response
end,

close = function (self)

    self.conn:close()
end

}
