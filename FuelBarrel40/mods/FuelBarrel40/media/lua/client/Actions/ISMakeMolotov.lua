--***********************************************************
--**                    THE INDIE STONE                    **
--***********************************************************

require "TimedActions/ISBaseTimedAction"

ISMakeMolotov = ISBaseTimedAction:derive("ISMakeMolotov");

function ISMakeMolotov:isValid()
	return true;
end

function ISMakeMolotov:update()
	self.character:faceThisObject(self.barrel)
end

function ISMakeMolotov:start()
end

function ISMakeMolotov:stop()
    ISBaseTimedAction.stop(self);
end

function ISMakeMolotov:perform()
	local barObj = self.barrel;
	local args = { x = barObj:getX(), y = barObj:getY(), z = barObj:getZ(), fuelAmount = barObj:getModData()["fuelAmount"] - 1, bottle = self.bottle, sheet = self.sheet }
	CFuelBarrelSystem.instance:sendCommand(self.character, 'makeMolotov', args)

	-- self.character:getInventory():Remove(self.bottle);
	-- self.character:getInventory():Remove(self.sheet);
	-- self.character:getInventory():AddItem("Base.Molotov");
	
	-- self.character:getInventory():setDrawDirty(true);
	
	
	-- if isClient() then
		-- ISFuelBarrel.fuelChange(self.barrel, (self.barrel:getModData()["fuelAmount"]-1))
	-- else
		-- ISFuelBarrel.fuelChange(self.barrel, (self.barrel:getModData()["fuelAmount"]-1))
	-- end

    -- needed to remove from queue / start next.
	ISBaseTimedAction.perform(self);
end

function ISMakeMolotov:new(character, barrel, bottle, sheet)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.character = character
	o.barrel = barrel
	o.bottle = bottle
	o.sheet = sheet
	o.stopOnWalk = true;
	o.stopOnRun = true;
	o.maxTime = 60;
	return o;
end