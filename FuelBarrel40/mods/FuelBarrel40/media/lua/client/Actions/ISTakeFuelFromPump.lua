--***********************************************************
--**                   THE INDIE STONE                     **
--***********************************************************

require "TimedActions/ISBaseTimedAction"

ISTakeFuelFromPump = ISBaseTimedAction:derive("ISTakeFuelFromPump");

function ISTakeFuelFromPump:isValid()
	if self.character:getInventoryWeight() > 49.5 then return false end
	return true;
end

function ISTakeFuelFromPump:update()
	self.character:faceLocation(self.square:getX(), self.square:getY())
	self.barrel:setJobDelta(self:getJobDelta())
	self.barrel:setJobType(getText("ContextMenu_TakeGasoline"))
	
	local litres = self.pumpStart + (self.pumpTarget - self.pumpStart)*self:getJobDelta()
	if isClient() then
		self.square:getProperties():Set("fuelAmount", math.floor(litres) .. "");
		-- if math.floor(litres) ~= self.amountSent then
			-- local args = { vehicle = self.vehicle:getId(), part = self.part:getId(), amount = litres }
			-- sendClientCommand(self.character, 'vehicle', 'setContainerContentAmount', args)
			-- self.amountSent = math.floor(litres)
		-- end
	else
		self.square:getProperties():Set("fuelAmount", math.floor(litres) .. "");
	end
	
	local usedDelta = self.barrelStart + (self.barrelTarget - self.barrelStart) * self:getJobDelta()
	if usedDelta > 1 then usedDelta = 1 end
	self.barrel:setUsedDelta(usedDelta)
end

function ISTakeFuelFromPump:start()
	self.pumpStart = tonumber(self.square:getProperties():Val("fuelAmount"))
	self.barrelStart = self.barrel:getUsedDelta();
	
	local add = (1.0 - self.barrelStart)/self.barrel:getUseDelta();
	local take = math.min(add, self.pumpStart);
	
	self.pumpTarget = self.pumpStart - take;
	self.barrelTarget = self.barrelStart + take*self.barrel:getUseDelta();	
end

function ISTakeFuelFromPump:stop()
	self.barrel:setJobDelta(0)
    ISBaseTimedAction.stop(self);
end

function ISTakeFuelFromPump:perform()
	self.barrel:setJobDelta(0)
	if isClient() then
		self.square:getProperties():Set("fuelAmount", math.floor(self.pumpTarget) .. "");
		-- local args = { vehicle = self.vehicle:getId(), part = self.part:getId(), amount = self.tankTarget }
		-- sendClientCommand(self.character, 'vehicle', 'setContainerContentAmount', args)
	else
		self.square:getProperties():Set("fuelAmount", math.floor(self.pumpTarget) .. "");
	end

    -- needed to remove from queue / start next.
	ISBaseTimedAction.perform(self);
end

function ISTakeFuelFromPump:new(character, square, barrel, time)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.character = character;
    o.square = square;
	o.barrel = barrel;
	o.stopOnWalk = true;
	o.stopOnRun = true;
	o.maxTime = time;
	return o;
end
