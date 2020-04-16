--***********************************************************
--**                    THE INDIE STONE                    **
--***********************************************************

if isClient() then return end

require "Map/SGlobalObjectSystem"
require "FuelBarrel/BuildingObjects/ISFuelBarrel.lua" -- for ISFuelBarrel{}

SFuelBarrelSystem = SGlobalObjectSystem:derive("SFuelBarrelSystem")

function SFuelBarrelSystem:new()
    local o = SGlobalObjectSystem.new(self, "fuelbarrel")
    return o
end

function SFuelBarrelSystem:initSystem()
    SGlobalObjectSystem.initSystem(self)

    -- Specify GlobalObjectSystem fields that should be saved.
    self.system:setModDataKeys({})
    
    -- Specify GlobalObject fields that should be saved.
    self.system:setObjectModDataKeys({'fuelAmount', 'weight', 'generatorSquare'})

    self:convertOldModData()
end

function SFuelBarrelSystem:newLuaObject(globalObject)
    return SFuelBarrelGlobalObject:new(self, globalObject)
end

function SFuelBarrelSystem:isValidIsoObject(isoObject)
    return instanceof(isoObject, "IsoThumpable") and isoObject:getName() == "FuelBarrel"
end

function SFuelBarrelSystem:convertOldModData()
end

function SFuelBarrelSystem:checkGenerator()
    for i=1,self:getLuaObjectCount() do
        local luaObject = self:getLuaObjectByIndex(i)
        luaObject:update()
    end
end

local noise = function(msg)
    SFuelBarrelSystem.instance:noise(msg)
end

local function getFuelBarrelAt(x, y, z)
    return SFuelBarrelSystem.instance:getLuaObjectAt(x, y, z)
end

function SFuelBarrelSystem:OnClientCommand(command, player, args)
    local barrel = getFuelBarrelAt(args.x, args.y, args.z)
    if not barrel then
        noise('no fuelbarrel found at '..args.x..','..args.y..','..args.z)
        return
    end
	
    if command == "fuelChange" then
        barrel:setFuelAmount(args.fuelAmount)
        return
    end
	
	if command == "connectGenerator" then
		barrel:connectGenerator(args.generatorSquare);
        return
    end
	
	if command == "makeMolotov" then
		player:sendObjectChange('removeOneOf', { type = args.bottle:getType() })
		player:sendObjectChange('removeOneOf', { type = args.sheet:getType() })
		player:sendObjectChange('addItemOfType', { type = 'Base.Molotov', count = 1 })
		barrel:setFuelAmount(args.fuelAmount)
		return
	end
    -- if command == "addLogs" then
        -- for i=1,5 do
            -- player:sendObjectChange('removeOneOf', { type = 'Log' })
        -- end
        -- barrel:setHaveLogs(true)
        -- return
    -- end
    -- if command == "removeLogs" then
        -- player:sendObjectChange('addItemOfType', { type = 'Base.Log', count = 5 })
        -- barrel:setHaveLogs(false)
        -- return
    -- end
    -- if command == "lightFire" then
        -- if not barrel.isLit and barrel.haveLogs then
            -- barrel:setLit(true)
        -- end
        -- return
    -- end
    -- if command == "putOutFire" then
        -- if barrel.isLit then
            -- barrel:setLit(false)
        -- end
        -- return
    -- end
    -- if command == "removeCharcoal" then
        -- if drum.haveCharcoal then
            -- drum:setHaveCharcoal(false)
            -- player:sendObjectChange('addItemOfType', { type = 'Base.Charcoal', count = 2 })
        -- end
        -- return
    -- end
    -- if command == "removeWater" then
        -- if drum.waterAmount > 0 then
            -- drum.waterAmount = 0
            -- drum:getIsoObject():setWaterAmount(0)
            -- drum:getIsoObject():transmitModData()
        -- end
        -- return
    -- end
end

SGlobalObjectSystem.RegisterSystemClass(SFuelBarrelSystem)

-- every 10 minutes we check, to fill generator
local function EveryTenMinutes()
    SFuelBarrelSystem.instance:checkGenerator()
end

Events.EveryTenMinutes.Add(EveryTenMinutes)

