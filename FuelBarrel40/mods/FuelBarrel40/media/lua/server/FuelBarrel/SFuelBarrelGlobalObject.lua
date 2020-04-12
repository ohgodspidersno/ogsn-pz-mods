--***********************************************************
--**                    THE INDIE STONE                    **
--***********************************************************

if isClient() then return end

require "Map/SGlobalObject"
require "FuelBarrel/BuildingObjects/ISFuelBarrel.lua"

SFuelBarrelGlobalObject = SGlobalObject:derive("SFuelBarrelGlobalObject")

function SFuelBarrelGlobalObject:new(luaSystem, globalObject)
    local o = SGlobalObject.new(self, luaSystem, globalObject)
    return o
end

function SFuelBarrelGlobalObject:initNew()
    self.fuelAmount = 0
    self.fuelMax = ISFuelBarrel.fuelMax
    self.weight = (self.fuelAmount * ISFuelBarrel.weightRatio) + ISFuelBarrel.weightEmpty
	--self.connectedGenerator = ISFuelBarrel.connectedGenerator
	self.generatorSquare = nil
end

function SFuelBarrelGlobalObject:stateFromIsoObject(isoObject)
    self.fuelAmount = isoObject:getModData().fuelAmount
    self.fuelMax = isoObject:getModData().fuelMax
	self.weight = isoObject:getModData().weight
	--self.connectedGenerator	= isoObject:getModData().connectedGenerator
    self.generatorSquare = isoObject:getModData().generatorSquare

    if not self.fuelMax then
        self.fuelMax = ISFuelBarrel.fuelMax;
        isoObject:getModData()["fuelMax"] = self.fuelMax
    end

    isoObject:transmitModData()
end

function SFuelBarrelGlobalObject:stateToIsoObject(isoObject)
    if not self.fuelAmount then
        self.fuelAmount = 0
    end
    if not self.fuelMax then
        self.fuelMax = ISFuelBarrel.fuelMax;
        isoObject:getModData()["fuelMax"] = self.fuelMax
    end
	
    self:setModData()
	if not self.weight then
		self:setFuelAmount(self.fuelAmount)
	end
	
	if self.generatorSquare then
		self:connectGenerator(self.generatorSquare)
	end
end

-- function SFuelBarrelGlobalObject:changeSprite()
    -- local isoObject = self:getIsoObject()
    -- if not isoObject then return end
    -- local spriteName = nil
    -- if isoObject:getModData()["haveLogs"] or isoObject:getModData()["haveCharcoal"] then
        -- if isoObject:getModData()["isLit"] then
            -- spriteName = "crafted_01_27"
        -- else
            -- spriteName = "crafted_01_26"
        -- end
    -- else
        -- if self.waterAmount >= self.waterMax * 0.75 then
            -- spriteName = "crafted_01_25"
        -- else
            -- spriteName = "crafted_01_24"
        -- end
    -- end
    -- if spriteName and (not isoObject:getSprite() or spriteName ~= isoObject:getSprite():getName()) then
        -- self:noise('sprite changed to '..spriteName..' at '..self.x..','..self.y..','..self.z)
        -- isoObject:setSprite(spriteName)
        -- isoObject:transmitUpdatedSpriteToClients()
    -- end
-- end

function SFuelBarrelGlobalObject:setModData()
    local isoObject = self:getIsoObject()
    if not isoObject then return end
    local previousfuelAmount = isoObject:getModData()["fuelAmount"];
    local previousweight = isoObject:getModData()["weight"];
    --local previousconnectedGenerator = isoObject:getModData()["connectedGenerator"];
	local previousgeneratorSquare = isoObject:getModData()["generatorSquare"];
    isoObject:getModData()["fuelAmount"] = self.fuelAmount;
    isoObject:getModData()["weight"] = self.weight;
    isoObject:getModData()["generatorSquare"] = self.generatorSquare;
    if previousfuelAmount ~= isoObject:getModData()["fuelAmount"] or 
		previousweight ~= isoObject:getModData()["weight"] or
		previousgeneratorSquare ~= isoObject:getModData()["generatorSquare"] then
        isoObject:transmitModData();
    end
end


function SFuelBarrelGlobalObject:connectGenerator(gSquare)
	--self.connectedGenerator = generator
	self.generatorSquare = gSquare
	local isoObject = self:getIsoObject()
    if not isoObject then return end
	--isoObject:getModData()["connectedGenerator"] = generator;
    isoObject:getModData()["generatorSquare"] = self.generatorSquare;
    isoObject:transmitModData();
end

function SFuelBarrelGlobalObject:setFuelAmount(fuelAmount)
	self.fuelAmount = fuelAmount
	self.weight = (fuelAmount * ISFuelBarrel.weightRatio) + ISFuelBarrel.weightEmpty
    local isoObject = self:getIsoObject()
    if not isoObject then return end
    isoObject:getModData()["fuelAmount"] = self.fuelAmount
	isoObject:getModData()["weight"] = self.weight
    isoObject:transmitModData()
end

-- function SFuelBarrelGlobalObject:setHaveCharcoal(haveCharcoal)
    -- self.haveCharcoal = haveCharcoal
    -- local isoObject = self:getIsoObject()
    -- if not isoObject then return end
    -- isoObject:getModData()["haveCharcoal"] = haveCharcoal
    -- isoObject:transmitModData()
    -- self:changeSprite()
-- end

-- function SFuelBarrelGlobalObject:setHaveLogs(haveLogs)
    -- self.haveLogs = haveLogs
    -- if not haveLogs then
        -- self.charcoalTick = 0
    -- end
    -- local isoObject = self:getIsoObject()
    -- if not isoObject then return end
    -- isoObject:getModData()["haveLogs"] = haveLogs
    -- isoObject:transmitModData()
    -- isoObject:transmitModData()
    -- self:changeSprite()
-- end


function SFuelBarrelGlobalObject:update()		
	local isoObject = self:getIsoObject()
    if not isoObject then return end	
	local generator = nil;
	
	if self.generatorSquare then
		local sq = getWorld():getCell():getGridSquare(self.generatorSquare[1], self.generatorSquare[2], self.generatorSquare[3])
		if sq then
			for i=0,sq:getObjects():size() - 1 do
				local obj = sq:getObjects():get(i)
				if instanceof(obj, "IsoGenerator") then
					generator = obj;
					
					self:noise("Generator is: "..tostring(generator)) --debug mode
					if self.fuelAmount > 0 and generator:getFuel() < 90 then
						print(self.fuelAmount);
						local endFuel = 0;
						while self.fuelAmount > 0 and (generator:getFuel() + endFuel) < 100 do
							self.fuelAmount = self.fuelAmount - 0.1;
							endFuel = endFuel + 1;
						end
						generator:setFuel(generator:getFuel() + endFuel);
						self:setFuelAmount(self.fuelAmount)
						--self:setModData();
					end
					break
				end
			end
			if not generator then 
				self:connectGenerator(generator)
			end
		end 
	end	
end

