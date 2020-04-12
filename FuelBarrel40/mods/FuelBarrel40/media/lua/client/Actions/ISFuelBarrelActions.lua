--***********************************************************
--**                    THE INDIE STONE                    **
--***********************************************************

require "TimedActions/ISBaseTimedAction"

ISFuelBarrelActions = ISBaseTimedAction:derive("ISFuelBarrelActions");

function ISFuelBarrelActions:isValid()
	if self.check and self.character:getInventoryWeight() > 49.5 then return false end
	return true;
end

function ISFuelBarrelActions:update()
	self.character:faceLocation(self.barrel:getSquare():getX(), self.barrel:getSquare():getY())
	self.fuelItem:setJobDelta(self:getJobDelta())
	if self.check then self.fuelItem:setJobType(getText("ContextMenu_TakeGasoline"))
	else self.fuelItem:setJobType(getText("ContextMenu_AddGasoline")) end
	
	local litres = self.barrelStart + (self.barrelTarget - self.barrelStart)*self:getJobDelta()
	if self.check then litres = math.ceil(litres)
	else litres = math.floor(litres) end
	
	if litres ~= self.amountSent then
		local barObj = self.barrel;
		local args = { x = barObj:getX(), y = barObj:getY(), z = barObj:getZ(), fuelAmount = litres }
		CFuelBarrelSystem.instance:sendCommand(self.character, 'fuelChange', args)
		self.amountSent = litres
	end
	
	local litresTaken = litres - self.barrelStart
	local usedDelta = self.itemStart - litresTaken*self.fuelItem:getUseDelta()
	self.fuelItem:setUsedDelta(usedDelta)
end

function ISFuelBarrelActions:start()
	self.barrelStart = self.barrel:getModData()["fuelAmount"];
	self.itemStart = self.fuelItem:getUsedDelta();
 
	if self.check then --take from barrel
		local add = (1.0 - self.itemStart)/self.fuelItem:getUseDelta();
		local take = math.min(add, self.barrelStart);
		
		self.barrelTarget = self.barrelStart - take;
		self.itemTarget = self.itemStart + take*self.fuelItem:getUseDelta();
		
		self.amountSent = math.ceil(self.barrelStart);
		self.action:setTime(30 + take * 5)
	else --add to barrel
		local add = self.barrel:getModData()["fuelMax"] - self.barrelStart;
		local take = math.min(add, self.itemStart/self.fuelItem:getUseDelta());
		
		self.barrelTarget = self.barrelStart + take;
		self.itemTarget = self.itemStart - take*self.fuelItem:getUseDelta();
		
		self.amountSent = self.barrelStart;
		self.action:setTime(30 + take * 5)
	end
	
end

function ISFuelBarrelActions:stop()
	self.fuelItem:setJobDelta(0)
    ISBaseTimedAction.stop(self);
end

 function ISFuelBarrelActions:perform()
	self.fuelItem:setJobDelta(0)
	self.fuelItem:setUsedDelta(self.itemTarget)
	local barObj = self.barrel;
	local args = { x = barObj:getX(), y = barObj:getY(), z = barObj:getZ(), fuelAmount = self.barrelTarget }
	CFuelBarrelSystem.instance:sendCommand(self.character, 'fuelChange', args)
	
	if self.check then
	else
		if self.fuelItem:getUsedDelta() <= 0 then
			self.fuelItem:Use()
		end
	end
	
--	print('add gasoline level=' .. self.part:getContainerContentAmount())

	-- needed to remove from queue / start next.
	ISBaseTimedAction.perform(self)
end

function ISFuelBarrelActions:new(check, barrel, character, fuelItem, time)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.check = check;
	o.barrel = barrel;
	o.character = character;
	o.fuelItem = fuelItem;
	o.stopOnWalk = true;
	o.stopOnRun = true;
	o.maxTime = time;
	return o;
end
