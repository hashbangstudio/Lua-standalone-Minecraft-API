Vec3 = {


new = function(self, xin, yin, zin)
    if type(xin) == 'table' and yin == nil and zin == nil then
        zin = xin[3]
        yin = xin[2]
        xin = xin[1]
    end

    local obj = {x=xin, y=yin , z=zin}
    setmetatable(obj, self)
    self.__index=self
    return obj
end, 

toString = function(self)
    return "["..self.x..","..self.y..","..self.z.."]"
end,

clone = function(self)
            return Vec3:new(self.x, self.y, self.z)
end,


length = function(self)
            return math.sqrt(self:lengthSqr())
end,

lengthSqr = function(self)
    return self.x * self.x + self.y * self.y  + self.z * self.z
end

}

Vec3.__unm = function (self)
    return Vec3:new(-self.x, -self.y, -self.z)
end

Vec3.__add  = function(self, rhs)
        local c = Vec3:new(
                self.x + rhs.x,
                self.y + rhs.y,
                self.z + rhs.z
        )
        return c
end

Vec3.__mul = function(self, rhs)
    local c = Vec3:new(
        self.x * rhs,
        self.y * rhs,
        self.z * rhs
    )
    return c
end


Vec3.__sub = function (self, rhs)
        return self:__add(-rhs)
end

Vec3.__eq = function (self, rhs)
        return (
        self.x == rhs.x 
        and self.y == rhs.y
        and self.z == rhs.z
        )
end

