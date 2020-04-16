--***********************************************************
--**                    THE INDIE STONE                    **
--***********************************************************

TRFB_VehicleMenu = {}

function TRFB_VehicleMenu.OnFillWorldObjectContextMenu(player, context, worldobjects, test)
	local playerObj = getSpecificPlayer(player)
	local vehicle = playerObj:getVehicle()
	if not vehicle then
		if JoypadState.players[player+1] then
			local px = playerObj:getX()
			local py = playerObj:getY()
			local pz = playerObj:getZ()
			local sqs = {}
			sqs[1] = getCell():getGridSquare(px, py, pz)
			local dir = playerObj:getDir()
			if (dir == IsoDirections.N) then        sqs[2] = getCell():getGridSquare(px-1, py-1, pz); sqs[3] = getCell():getGridSquare(px, py-1, pz);   sqs[4] = getCell():getGridSquare(px+1, py-1, pz);
			elseif (dir == IsoDirections.NE) then   sqs[2] = getCell():getGridSquare(px, py-1, pz);   sqs[3] = getCell():getGridSquare(px+1, py-1, pz); sqs[4] = getCell():getGridSquare(px+1, py, pz);
			elseif (dir == IsoDirections.E) then    sqs[2] = getCell():getGridSquare(px+1, py-1, pz); sqs[3] = getCell():getGridSquare(px+1, py, pz);   sqs[4] = getCell():getGridSquare(px+1, py+1, pz);
			elseif (dir == IsoDirections.SE) then   sqs[2] = getCell():getGridSquare(px+1, py, pz);   sqs[3] = getCell():getGridSquare(px+1, py+1, pz); sqs[4] = getCell():getGridSquare(px, py+1, pz);
			elseif (dir == IsoDirections.S) then    sqs[2] = getCell():getGridSquare(px+1, py+1, pz); sqs[3] = getCell():getGridSquare(px, py+1, pz);   sqs[4] = getCell():getGridSquare(px-1, py+1, pz);
			elseif (dir == IsoDirections.SW) then   sqs[2] = getCell():getGridSquare(px, py+1, pz);   sqs[3] = getCell():getGridSquare(px-1, py+1, pz); sqs[4] = getCell():getGridSquare(px-1, py, pz);
			elseif (dir == IsoDirections.W) then    sqs[2] = getCell():getGridSquare(px-1, py+1, pz); sqs[3] = getCell():getGridSquare(px-1, py, pz);   sqs[4] = getCell():getGridSquare(px-1, py-1, pz);
			elseif (dir == IsoDirections.NW) then   sqs[2] = getCell():getGridSquare(px-1, py, pz);   sqs[3] = getCell():getGridSquare(px-1, py-1, pz); sqs[4] = getCell():getGridSquare(px, py-1, pz);
			end
			for _,sq in ipairs(sqs) do
				vehicle = sq:getVehicleContainer()
				if vehicle then
					return TRFB_VehicleMenu.FillMenuOutsideVehicle(player, context, vehicle, test)
				end
			end
			return
		end
		vehicle = IsoObjectPicker.Instance:PickVehicle(getMouseXScaled(), getMouseYScaled())
		if vehicle then
			return TRFB_VehicleMenu.FillMenuOutsideVehicle(player, context, vehicle, test)
		end
		return
	end
end

function TRFB_VehicleMenu.FillMenuOutsideVehicle(player, context, vehicle, test)
	local playerObj = getSpecificPlayer(player)
	TRFB_VehicleMenu.FillPartMenu(player, context, nil, vehicle);
end

function TRFB_VehicleMenu.FillPartMenu(playerIndex, context, slice, vehicle)
	local playerObj = getSpecificPlayer(playerIndex);
	local typeToItem = VehicleUtils.getItems(playerIndex)
	for i=1,vehicle:getPartCount() do
		local part = vehicle:getPartByIndex(i-1)
		if not vehicle:isEngineStarted() and part:isContainer() and part:getContainerContentType() == "Gasoline" then
			-- if typeToItem["Base.PetrolCan"] and part:getContainerContentAmount() < part:getContainerCapacity() then
				-- if slice then
					-- slice:addSlice(getText("ContextMenu_VehicleAddGas"), getTexture("Item_Petrol"), ISVehiclePartMenu.onAddGasoline, playerObj, part)
				-- else
					-- context:addOption(getText("ContextMenu_VehicleAddGas"), playerObj,ISVehiclePartMenu.onAddGasoline, part)
				-- end
			-- end
			-- if ISVehiclePartMenu.getGasCanNotFull(typeToItem) and part:getContainerContentAmount() > 0 then
				-- if slice then
					-- slice:addSlice(getText("ContextMenu_VehicleSiphonGas"), getTexture("Item_Petrol"), ISVehiclePartMenu.onTakeGasoline, playerObj, part)
				-- else
					-- context:addOption(getText("ContextMenu_VehicleSiphonGas"), playerObj, ISVehiclePartMenu.onTakeGasoline, part)
				-- end
			-- end
			
			
			--Add fuel to barrel
			local square, barrel = TRFB_VehicleMenu.getNearbyFuelBarrel(vehicle, true)
			if square and part:getContainerContentAmount() > 0 then
				if slice then
					slice:addSlice(getText("ContextMenu_VehicleRefuelFromPump"), getTexture("Item_Petrol"), ISVehiclePartMenu.onPumpGasoline, playerObj, part)
				else
					local option = context:addOption(getText("ContextMenu_VehicleTakeFuelToBarrel"), playerObj, TRFB_VehicleMenu.onAddFuelToBarrel, part)
					local tooltip = TRFB_VehicleMenu.addToolTip()
					tooltip:setBarrel(barrel)
					tooltip:setName(getText("ContextMenu_Fuel_Barrel"))
					tooltip.description = getText("IGUI_RemainingPercent", round((barrel:getModData()["fuelAmount"] / barrel:getModData()["fuelMax"]) * 100))
					option.toolTip = tooltip
				end
			end
			
			--Take fuel from barrel
			local square, barrel = TRFB_VehicleMenu.getNearbyFuelBarrel(vehicle, false)
			if square and part:getContainerContentAmount() < part:getContainerCapacity() then
				if slice then
					slice:addSlice(getText("ContextMenu_VehicleRefuelFromPump"), getTexture("Item_Petrol"), ISVehiclePartMenu.onPumpGasoline, playerObj, part)
				else
					local option = context:addOption(getText("ContextMenu_VehicleRefuelFromBarrel"), playerObj, TRFB_VehicleMenu.onTakeFuelFromBarrel, part)
					local tooltip = TRFB_VehicleMenu.addToolTip()
					tooltip:setBarrel(barrel)
					tooltip:setName(getText("ContextMenu_Fuel_Barrel"))
					tooltip.description = getText("IGUI_RemainingPercent", round((barrel:getModData()["fuelAmount"] / barrel:getModData()["fuelMax"]) * 100))
					option.toolTip = tooltip
				end
			end
			
		end
	end
end

function TRFB_VehicleMenu.addToolTip()
    local toolTip = TRFB_ToolTip:new();
    toolTip:initialise();
    toolTip:setVisible(false);
    return toolTip;
end

function TRFB_VehicleMenu.getNearbyFuelBarrel(vehicle, addToBarrel)
	local part = vehicle:getPartById("GasTank")
	if not part then return nil end
	local areaCenter = vehicle:getAreaCenter(part:getArea())
	if not areaCenter then return nil end
	local square = getCell():getGridSquare(areaCenter:getX(), areaCenter:getY(), vehicle:getZ())
	if not square then return nil end
	for dy=-2,2 do
		for dx=-2,2 do
			local square2 = getCell():getGridSquare(square:getX() + dx, square:getY() + dy, square:getZ())
			if square2 then
			local barrel = CFuelBarrelSystem:getIsoObjectOnSquare(square2);
				if addToBarrel then
					if barrel and barrel:getModData()["fuelAmount"] < barrel:getModData()["fuelMax"] and not square:isBlockedTo(square2) then 
						return square2, barrel
					end	
				else
					if barrel and barrel:getModData()["fuelAmount"] > 0 and not square:isBlockedTo(square2) then 
						return  square2, barrel
					end	
				end
			end
		end
	end
end

-- function TRFB_VehicleMenu.getNearbyFuelBarrel(vehicle)
	-- local part = vehicle:getPartById("GasTank")
	-- if not part then return nil end
	-- local areaCenter = vehicle:getAreaCenter(part:getArea())
	-- if not areaCenter then return nil end
	-- local square = getCell():getGridSquare(areaCenter:getX(), areaCenter:getY(), vehicle:getZ())
	-- if not square then return nil end
	-- for dy=-2,2 do
		-- for dx=-2,2 do
			-- local square2 = getCell():getGridSquare(square:getX() + dx, square:getY() + dy, square:getZ())
			-- if square2 then
				-- local barrel = CFuelBarrelSystem:getIsoObjectOnSquare(square2);
				
			-- end
		-- end
	-- end
-- end

function TRFB_VehicleMenu.onAddFuelToBarrel(playerObj, part)
	if playerObj:getVehicle() then
		ISVehicleMenu.onExit(playerObj)
	end
	local square, barrel = TRFB_VehicleMenu.getNearbyFuelBarrel(part:getVehicle(), true)
	if square then
		ISTimedActionQueue.add(ISPathFindAction:pathToVehicleArea(playerObj, part:getVehicle(), part:getArea()))
		ISTimedActionQueue.add(ISVehicleAndlBarrelActions:new(false, playerObj, part, barrel, 150))
	end
end

function TRFB_VehicleMenu.onTakeFuelFromBarrel(playerObj, part)
	if playerObj:getVehicle() then
		ISVehicleMenu.onExit(playerObj)
	end
	local square, barrel = TRFB_VehicleMenu.getNearbyFuelBarrel(part:getVehicle(), false)
	if square then
		ISTimedActionQueue.add(ISPathFindAction:pathToVehicleArea(playerObj, part:getVehicle(), part:getArea()))
		ISTimedActionQueue.add(ISVehicleAndlBarrelActions:new(true, playerObj, part, barrel, 150))
	end
end

Events.OnFillWorldObjectContextMenu.Add(TRFB_VehicleMenu.OnFillWorldObjectContextMenu)