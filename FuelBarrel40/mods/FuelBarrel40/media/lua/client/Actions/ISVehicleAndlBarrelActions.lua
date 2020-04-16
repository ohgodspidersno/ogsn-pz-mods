--***********************************************************
--**                    THE INDIE STONE                    **
--***********************************************************

require "TimedActions/ISBaseTimedAction"

ISVehicleAndlBarrelActions = ISBaseTimedAction:derive("ISVehicleAndlBarrelActions")

function ISVehicleAndlBarrelActions:isValid()
	return self.vehicle:isInArea(self.part:getArea(), self.character)
end

function ISVehicleAndlBarrelActions:update()
	local litres = self.tankStart + (self.tankTarget - self.tankStart) * self:getJobDelta()
	litres = math.ceil(litres)
	if litres ~= self.amountSent then
		local args = { vehicle = self.vehicle:getId(), part = self.part:getId(), amount = litres }
		sendClientCommand(self.character, 'vehicle', 'setContainerContentAmount', args)
		self.amountSent = litres
	end
	
	local litresTaken = litres - self.tankStart
	local barrelUnits = self.barrelStart - litresTaken
	local barObj = self.barrel;
	local args = { x = barObj:getX(), y = barObj:getY(), z = barObj:getZ(), fuelAmount = barrelUnits }
	CFuelBarrelSystem.instance:sendCommand(self.character, 'fuelChange', args)
	
	-- local usedDelta = self.itemStart + litresTaken / Vehicles.JerryCanLitres
	-- self.item:setUsedDelta(usedDelta)

	-- local litres = self.tankStart + (self.tankTarget - self.tankStart) * self:getJobDelta() 
	-- if isClient() then
		-- if math.floor(litres) ~= self.amountSent then
			-- local args = { vehicle = self.vehicle:getId(), part = self.part:getId(), amount = litres }
			-- sendClientCommand(self.character, 'vehicle', 'setContainerContentAmount', args)
			-- self.amountSent = math.floor(litres)
		-- end
	-- else
		-- self.part:setContainerContentAmount(litres)
	-- end
	
	-- local barrelUnits = self.barrelStart + (self.barrelTarget - self.barrelStart) * self:getJobDelta() 
	-- ISFuelBarrel.fuelChange(self.barrel, barrelUnits)
end

function ISVehicleAndlBarrelActions:start()
	self.tankStart = self.part:getContainerContentAmount() 
	-- Pumps start with 100 units of fuel.  8 pump units = 1 PetrolCan according to ISTakeFuel.
	--self.barrel = ISFuelBarrel.findObject(self.square);
	self.barrelStart = self.barrel:getModData()["fuelAmount"]	
	
	if self.check then --  add fuel to vehicle
		local barrelLitresAvail = self.barrelStart * (Vehicles.JerryCanLitres / 8)
		local tankLitresFree = self.part:getContainerCapacity() - self.tankStart 
		local takeLitres = math.min(tankLitresFree, barrelLitresAvail) 
		self.tankTarget = self.tankStart + takeLitres 
		self.barrelTarget = self.barrelStart - takeLitres / (Vehicles.JerryCanLitres / 8) 
		
		self.amountSent = self.tankStart
		self.action:setTime(30 + takeLitres * 5)
	else -- take fuel from vehicle
		local barrelLitresFree = (self.barrel:getModData()["fuelMax"] - self.barrelStart) * (Vehicles.JerryCanLitres / 8) 
		local tankLitresAvail = self.tankStart 
		local takeLitres = math.min(tankLitresAvail, barrelLitresFree) 
		self.tankTarget = self.tankStart - takeLitres  
		self.barrelTarget = self.barrelStart + takeLitres/(Vehicles.JerryCanLitres / 8) 
		
		self.amountSent = math.ceil(self.tankStart)
		self.action:setTime(30 + takeLitres * 5)
	end	
	
end

function ISVehicleAndlBarrelActions:stop()
	ISBaseTimedAction.stop(self)
end

function ISVehicleAndlBarrelActions:perform()
	local args = { vehicle = self.vehicle:getId(), part = self.part:getId(), amount = self.tankTarget }
	sendClientCommand(self.character, 'vehicle', 'setContainerContentAmount', args)
	
	local barObj = self.barrel;
	local args = { x = barObj:getX(), y = barObj:getY(), z = barObj:getZ(), fuelAmount = self.barrelTarget }
	CFuelBarrelSystem.instance:sendCommand(self.character, 'fuelChange', args)
	
	-- needed to remove from queue / start next.
	ISBaseTimedAction.perform(self)
end

function ISVehicleAndlBarrelActions:new(check, character, part, barrel, time)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.character = character
	o.vehicle = part:getVehicle()
	o.part = part
	o.barrel = barrel
	--o.square = square
	o.check = check;
	o.maxTime = math.max(time, 50)
	return o
end

