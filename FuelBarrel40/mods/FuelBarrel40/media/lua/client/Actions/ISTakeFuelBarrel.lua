--***********************************************************
--**                    THE INDIE STONE                    **
--***********************************************************

require "TimedActions/ISBaseTimedAction"

ISTakeFuelBarrel = ISBaseTimedAction:derive("ISTakeFuelBarrel");

function ISTakeFuelBarrel:isValid()
	if self.barrel:getModData()["weight"] then 
		if self.barrel:getModData()["weight"] > 45 then return false; end
	end
	return true
end

function ISTakeFuelBarrel:update()
	self.character:faceThisObject(self.barrel)
end

function ISTakeFuelBarrel:start()
end

function ISTakeFuelBarrel:stop()
    ISBaseTimedAction.stop(self);
end

function ISTakeFuelBarrel:perform()
	local Barrel = self.character:getInventory():AddItem("TRPack.PetrolBarrel");
	if self.barrel:getModData()["fuelAmount"] then
		Barrel:setUsedDelta(tonumber(self.barrel:getModData()["fuelAmount"])*Barrel:getUseDelta());
	else
		Barrel:setUsedDelta((ZombRand(300)+1)/1000);
	end
	
	self.character:getInventory():setDrawDirty(true);

	if isClient() then
		sledgeDestroy(self.barrel);
	else
		self.barrel:getSquare():transmitRemoveItemFromSquare(self.barrel)
		--ISFuelBarrel.OnDestroyIsoThumpable(self.barrel, nil)
	end

    -- needed to remove from queue / start next.
	ISBaseTimedAction.perform(self);
end

function ISTakeFuelBarrel:new(character, barrel)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.character = character
	o.barrel = barrel
	o.stopOnWalk = true;
	o.stopOnRun = true;
	if barrel:getModData()["weight"] then
		o.maxTime = barrel:getModData()["weight"]*3;
	else
		o.maxTime = 80;
	end
	return o;
end