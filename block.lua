Block = {

new = function (self, id, data)
    data = data or 0
    local obj = { id = id, data = data }
    setmetatable(obj, self)
    self.__index=self
    return obj
end,

withData = function (self, data)
    return Block:new(self.id, data)
end,

toString = function (block)
   for k,v in pairs(block) do
       print(k,v)
   end
end,

toValTable = function(self)
    return {self.id, self.data}
end

}

--Overload of comparison operators
function Block.__eq (obj1, obj2)
   return ((obj1.id == obj2.id) and (obj1.data == obj2.data))
end


AIR                = function () return Block:new(0) end
STONE              = function () return Block:new(1) end
GRASS              = function () return Block:new(2) end
DIRT               = function () return Block:new(3) end
COBBLESTONE        = function () return Block:new(4) end
WOOD_PLANKS        = function () return Block:new(5) end
SAPLING            = function () return Block:new(6) end
BEDROCK            = function () return Block:new(7) end
WATER_FLOWING      = function () return Block:new(8) end
WATER              = function () return WATER_FLOWING() end
WATER_STATIONARY   = function () return Block:new(9) end
LAVA_FLOWING       = function () return Block:new(10) end
LAVA               = function () return LAVA_FLOWING() end
LAVA_STATIONARY    = function () return Block:new(11) end
SAND               = function () return Block:new(12) end
GRAVEL             = function () return Block:new(13) end
GOLD_ORE           = function () return Block:new(14) end
IRON_ORE           = function () return Block:new(15) end
COAL_ORE           = function () return Block:new(16) end
WOOD               = function () return Block:new(17) end
LEAVES             = function () return Block:new(18) end
GLASS              = function () return Block:new(20) end
LAPIS_LAZULI_ORE   = function () return Block:new(21) end
LAPIS_LAZULI_BLOCK = function () return Block:new(22) end
SANDSTONE          = function () return Block:new(24) end
BED                = function () return Block:new(26) end
COBWEB             = function () return Block:new(30) end
GRASS_TALL         = function () return Block:new(31) end
WOOL               = function () return Block:new(35) end
FLOWER_YELLOW      = function () return Block:new(37) end
FLOWER_CYAN        = function () return Block:new(38) end
MUSHROOM_BROWN     = function () return Block:new(39) end
MUSHROOM_RED       = function () return Block:new(40) end
GOLD_BLOCK         = function () return Block:new(41) end
IRON_BLOCK         = function () return Block:new(42) end
STONE_SLAB_DOUBLE  = function () return Block:new(43) end
STONE_SLAB         = function () return Block:new(44) end
BRICK_BLOCK        = function () return Block:new(45) end
TNT                = function () return Block:new(46) end
BOOKSHELF          = function () return Block:new(47) end
MOSS_STONE         = function () return Block:new(48) end
OBSIDIAN           = function () return Block:new(49) end
TORCH              = function () return Block:new(50) end
FIRE               = function () return Block:new(51) end
STAIRS_WOOD        = function () return Block:new(53) end
CHEST              = function () return Block:new(54) end
DIAMOND_ORE        = function () return Block:new(56) end
DIAMOND_BLOCK      = function () return Block:new(57) end
CRAFTING_TABLE     = function () return Block:new(58) end
FARMLAND           = function () return Block:new(60) end
FURNACE_INACTIVE   = function () return Block:new(61) end
FURNACE_ACTIVE     = function () return Block:new(62) end
DOOR_WOOD          = function () return Block:new(64) end
LADDER             = function () return Block:new(65) end
STAIRS_COBBLESTONE = function () return Block:new(67) end
DOOR_IRON          = function () return Block:new(71) end
REDSTONE_ORE       = function () return Block:new(73) end
SNOW               = function () return Block:new(78) end
ICE                = function () return Block:new(79) end
SNOW_BLOCK         = function () return Block:new(80) end
CACTUS             = function () return Block:new(81) end
CLAY               = function () return Block:new(82) end
SUGAR_CANE         = function () return Block:new(83) end
FENCE              = function () return Block:new(85) end
GLOWSTONE_BLOCK    = function () return Block:new(89) end
BEDROCK_INVISIBLE  = function () return Block:new(95) end
STONE_BRICK        = function () return Block:new(98) end
GLASS_PANE         = function () return Block:new(102) end
MELON              = function () return Block:new(103) end
FENCE_GATE         = function () return Block:new(107) end
GLOWING_OBSIDIAN   = function () return Block:new(246) end
NETHER_REACTOR_CORE= function () return Block:new(247) end


