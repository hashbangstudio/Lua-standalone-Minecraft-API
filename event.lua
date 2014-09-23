local pathToThisFile = ...
local folderContainingThisFile = pathToThisFile:match(".+/") or ""
require (folderContainingThisFile..'vec3')

BlockEvent = {


new = function(self, typein, xin, yin, zin, facein, entityIdin)

    if type(typein) == 'table' and xin == nil and yin == nil and zin == nil and facein ==nil and entityId == nil  then
        entityIdin = typein[6]
        facein = typein[5]
        zin = typein[4]
        yin = typein[3]
        xin = typein[2]
        typein = typein[1]
    elseif type(xin) == 'table' and yin == nil and zin == nil and facein ==nil and entityId == nil  then
        entityIdin = xin[5]
        facein = xin[4]
        zin = xin[3]
        yin = xin[2]
        xin = xin[1]
    end
    local posnIn = Vec3:new(xin, yin, zin)
    local obj = {type=typein, face=facein, entityId=entityIdin, posn=posnIn }
    setmetatable(obj, self)
    self.__index=self
    return obj
end,

toString = function(self)
    local sTypeHash = {[0] = "BlockEvent.HIT"}
    key = self.type
    local typeText = sTypeHash[key] or "???"
    output = "BlockEvent("..typeText..", "..self.posn.x..", "..self.posn.y..", "..self.posn.z..", "..self.face..", "..self.entityId..")"
    return output
end,

Hit = function(self, x, y, z, face, entityId)
    return BlockEvent:new(0, x, y, z, face, entityId)
end,



}

