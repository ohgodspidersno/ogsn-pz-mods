--***********************************************************
--**                    THE INDIE STONE                    **
--***********************************************************

if isClient() then return end

local function noise(message) SFuelBarrelSystem.instance:noise(message) end

local function CreateObject(sq, spriteName, fuelAmount, weight, generatorSquare)
	local modData = {}
	modData["fuelAmount"] = fuelAmount
	modData["fuelMax"] = ISFuelBarrel.fuelMax
	modData["weight"] = weight
	--modData["connectedGenerator"] = connectedGenerator
	modData["generatorSquare"] = generatorSquare

	local cell = getWorld():getCell()
	local north = false
	local javaObject = IsoThumpable.new(cell, sq, spriteName, north, modData)

	javaObject:setCanPassThrough(false)
	javaObject:setCanBarricade(false)
	javaObject:setThumpDmg(8)
	javaObject:setIsContainer(false)
	javaObject:setIsDoor(false)
	javaObject:setIsDoorFrame(false)
	javaObject:setCrossSpeed(1.0)
	javaObject:setBlockAllTheSquare(true)
	javaObject:setName("FuelBarrel")
	javaObject:setIsDismantable(true)
	javaObject:setCanBePlastered(false)
	javaObject:setIsHoppable(false)
	javaObject:setIsThumpable(true)
	javaObject:setModData(copyTable(modData))
	javaObject:setMaxHealth(200)
	javaObject:setHealth(200)
	javaObject:setBreakSound("BreakObject")
	javaObject:setSpecialTooltip(true)

	--javaObject:setWaterAmount(waterAmount)

	return javaObject
end

local function ReplaceExistingObject(isoObject, fuelAmount, weight, generatorSquare)
	local sq = isoObject:getSquare()
	noise('replacing isoObject at '..sq:getX()..','..sq:getY()..','..sq:getZ())
	local javaObject = CreateObject(sq, isoObject:getSprite():getName(), fuelAmount, weight, generatorSquare)
	local index = isoObject:getObjectIndex()
	sq:transmitRemoveItemFromSquare(isoObject)
	sq:AddSpecialObject(javaObject, index)
	javaObject:transmitCompleteItemToClients()
	return javaObject
end

local function NewEmpty(isoObject)
	local fuelAmount = ZombRand(0, ISFuelBarrel.fuelMax * 0.30) or 0
	local weight = fuelAmount * ISFuelBarrel.weightRatio + ISFuelBarrel.weightEmpty
	ReplaceExistingObject(isoObject, fuelAmount, weight, generatorSquare)
end

-- local function NewWater(isoObject)
	-- local fuelAmount = ZombRand(0, ISFuelBarrel.fuelMax * 0.30) or 0
	-- local weight = fuelAmount * ISFuelBarrel.weightRatio + ISFuelBarrel.weightEmpty
	-- ReplaceExistingObject(isoObject, fuelAmount, weight)
-- end



local PRIORITY = 5

MapObjects.OnNewWithSprite("trpack_1", NewEmpty, PRIORITY)
--MapObjects.OnNewWithSprite("crafted_01_25", NewWater, PRIORITY)


-- -- -- -- --

local function LoadObject(isoObject, fuelAmount, weight)
	local sq = isoObject:getSquare()
	if instanceof(isoObject, "IsoThumpable") then
	else
		isoObject = ReplaceExistingObject(isoObject, fuelAmount, weight, generatorSquare)
	end
	SFuelBarrelSystem.instance:loadIsoObject(isoObject)
end

local function LoadEmpty(isoObject)
	local fuelAmount = ZombRand(0, ISFuelBarrel.fuelMax * 0.30) or 0
	local weight = fuelAmount * ISFuelBarrel.weightRatio + ISFuelBarrel.weightEmpty
	LoadObject(isoObject, fuelAmount, weight, generatorSquare)
end

-- local function LoadWater(isoObject)
	-- local waterAmount = isoObject:getSquare():isOutside() and ZombRand(ISMetalDrum.waterMax * 0.75, ISMetalDrum.waterMax) or 0
	-- local haveLogs = false
	-- local isLit = false
	-- LoadObject(isoObject, waterAmount, haveLogs, isLit)
-- end



MapObjects.OnLoadWithSprite("trpack_1", LoadEmpty, PRIORITY)
--MapObjects.OnLoadWithSprite("crafted_01_25", LoadWater, PRIORITY)


