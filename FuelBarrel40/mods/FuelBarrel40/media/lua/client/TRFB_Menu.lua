--***********************************************************
--**                    THE INDIE STONE                    **
--***********************************************************

TRFB_Menu={}

TRFB_Menu.Option = function(player, context, worldobjects, test)
	if test and ISWorldObjectContextMenu.Test then return true end
	
	local barrel = nil;
	
    for i,v in ipairs(worldobjects) do
		if CFuelBarrelSystem.instance:isValidIsoObject(v) then
			barrel = v
		end
	end
	
	if barrel and getSpecificPlayer(player):DistToSquared(barrel:getX() + 0.5, barrel:getY() + 0.5) < 2 * 2 then
		local option = context:addOption(getText("ContextMenu_Fuel_Barrel"), worldobjects, nil)
		local tooltip = TRFB_VehicleMenu.addToolTip()
		tooltip:setName(getText("ContextMenu_Fuel_Barrel"))
		tooltip.description = getText("IGUI_RemainingPercent", round((barrel:getModData()["fuelAmount"] / barrel:getModData()["fuelMax"]) * 100))
		option.toolTip = tooltip
	end
end

TRFB_Menu.doMenu = function(player, context, worldobjects, test)
	if test and ISWorldObjectContextMenu.Test then return true end
	
	local takeFuel = nil;
	local addFuel = nil;
	local MyhaveFuel = nil;
	local barrel = nil;
	local addedOption = nil;
	local Mygenerator = nil;
	
    for i,v in ipairs(worldobjects) do

		--Find generator
		if instanceof(v, "IsoGenerator") then
			Mygenerator = v;
		end
		
		
		--Pickup all barrels
		for iB=0,v:getSquare():getObjects():size()-1 do
			local checkObject = v:getSquare():getObjects():get(iB);
			local properties = checkObject:getSprite():getProperties();
			local prop = properties:getPropertyNames();
			local name = (properties :Is("CustomName") and properties :Val("CustomName")) or "None"
			if name == "Barrel" then
				barrel = checkObject;
				break;
			end
		end
		
		--Take fuel from barrel
		if v:getName() == "FuelBarrel" and v:getModData()["fuelAmount"] > 0 then 
			takeFuel = v;
		end
		
		--Add fuel to barrel
		if v:getName() == "FuelBarrel" and v:getModData()["fuelAmount"] < v:getModData()["fuelMax"] then 
			addFuel = v;
		end

		--Take fuel from pump to barrel
		if v:getSquare():getProperties():Is("fuelAmount") and tonumber(v:getSquare():getProperties():Val("fuelAmount")) > 0 then
			local petrolBarrel = getSpecificPlayer(player):getInventory():FindAndReturn("BarrelEmpty");
			if not petrolBarrel then
				local barrels = getSpecificPlayer(player):getInventory():getItemsFromType("PetrolBarrel");
				for i=0, barrels:size() -1 do
					if barrels:get(i):getUsedDelta() < 1 then
						MyhaveFuel = v;
						break;
					end
				end
			else
				MyhaveFuel = v;
			end
		end
	end
	
	--Connect generator and barrel
	if Mygenerator and not Mygenerator:isActivated() then
		local square, generatorBarrel = TRFB_Menu.getNearbyFuelBarrel(Mygenerator);
		if generatorBarrel then	
			local option = context:addOption(getText("ContextMenu_ConnectBarrel"), generatorBarrel, TRFB_Menu.connectBarrel, Mygenerator, getSpecificPlayer(player))
			local tooltip = TRFB_VehicleMenu.addToolTip()
			tooltip:setBarrel(generatorBarrel)
			tooltip:setName(getText("ContextMenu_Fuel_Barrel"))
			tooltip.description = getText("IGUI_RemainingPercent", round((generatorBarrel:getModData()["fuelAmount"] / generatorBarrel:getModData()["fuelMax"]) * 100))
			option.toolTip = tooltip	
		end
		
	end
	
	--Make molotov
	if takeFuel and takeFuel:getModData()["fuelAmount"] >= 1 then
		local inv = getSpecificPlayer(player):getInventory();
		local bottle = (inv:FindAndReturn("WineEmpty") or inv:FindAndReturn("WineEmpty2") or inv:FindAndReturn("WhiskeyEmpty"));
		local sheet = (inv:FindAndReturn("RippedSheets") or inv:FindAndReturn("RippedSheetsDirty"));
		if bottle and sheet then
			context:addOption(getText("ContextMenu_MakeMolotov"), takeFuel, TRFB_Menu.onMakeMolotov, getSpecificPlayer(player), bottle, sheet);
		end
	end
	
	--Pickup all barrels
	if barrel then
		addedOption = context:addOption(getText("ContextMenu_PickUpBarrel"), barrel, TRFB_Menu.onTakeBarrel, getSpecificPlayer(player));
		if barrel:getModData()["weight"] and getSpecificPlayer(player):DistToSquared(barrel:getX() + 0.5, barrel:getY() + 0.5) < 2 * 2 then
			local tooltip = TRFB_VehicleMenu.addToolTip()
			tooltip:setName(getText("ContextMenu_Fuel_Barrel"))
			tooltip.description = getText("IGUI_Weight", round(barrel:getModData()["weight"], 2))
			addedOption.toolTip = tooltip
		end
		
		if barrel:getModData()["weight"] then 
			if (50 - getSpecificPlayer(player):getInventoryWeight()) < barrel:getModData()["weight"] then
				addedOption.onSelect = nil;
				addedOption.notAvailable = true;
			elseif barrel:getModData()["weight"] > 45 then
				addedOption.onSelect = nil;
				addedOption.notAvailable = true;
			end
		elseif 35 < getSpecificPlayer(player):getInventoryWeight() then
			addedOption.onSelect = nil;
			addedOption.notAvailable = true;
		end
	end
	
	
	--Take fuel from pump to barrel
	if MyhaveFuel and ((SandboxVars.AllowExteriorGenerator and MyhaveFuel:getSquare():haveElectricity()) or (SandboxVars.ElecShutModifier > -1 and GameTime:getInstance():getNightsSurvived() < SandboxVars.ElecShutModifier)) then
        if test == true then return true; end
        context:addOption(getText("ContextMenu_TakeGasFromPump"),  getSpecificPlayer(player), TRFB_Menu.onTakeFuelFromPump, MyhaveFuel:getSquare());
    end
	
	
	--Add fuel to barrels from fuelItem
	if addFuel then
        if test == true then return true; end
		local pourOut = {}
        for i = 0, getSpecificPlayer(player):getInventory():getItems():size() -1 do
            local item = getSpecificPlayer(player):getInventory():getItems():get(i);
			local itemType = item:getType();
			if (itemType == "PetrolCan" and item:getUsedDelta() > 0)
			or (itemType == "PetrolBarrel" and item:getUsedDelta() > 0) then
				table.insert(pourOut, item)
			end
		end
		
		if #pourOut > 0 then
			local subMenuOption = context:addOption(getText("ContextMenu_PourOut"), worldobjects, nil);
			local subMenu = context:getNew(context)
			context:addSubMenu(subMenuOption, subMenu)
			for _,item in ipairs(pourOut) do
				subMenu:addOption(item:getName(), addFuel, TRFB_Menu.onAddFuel, getSpecificPlayer(player), addFuel:getSquare(), item);
			end
		end
    end
	
	
	--Take fuel from barrel to fuelItem
	if takeFuel then
        if test == true then return true; end
		local pourInto = {}
        for i = 0, getSpecificPlayer(player):getInventory():getItems():size() -1 do
            local item = getSpecificPlayer(player):getInventory():getItems():get(i);
			local itemType = item:getType();
			if itemType == "EmptyPetrolCan" 
			or (itemType == "PetrolCan" and item:getUsedDelta() < 1)
			or itemType == "BarrelEmpty" 
			or (itemType == "PetrolBarrel" and item:getUsedDelta() < 1) then
				table.insert(pourInto, item)
			end
		end
		
		if #pourInto > 0 then
			local subMenuOption = context:addOption(getText("ContextMenu_Fill"), worldobjects, nil);
			local subMenu = context:getNew(context)
			context:addSubMenu(subMenuOption, subMenu)
			for _,item in ipairs(pourInto) do
				subMenu:addOption(item:getName(), takeFuel, TRFB_Menu.onTakeFuel, getSpecificPlayer(player), takeFuel:getSquare(), item);
			end
		end
    end

	
	--Find barrel in inventory to place 
	local FuelBarrel = getSpecificPlayer(player):getInventory():FindAndReturn("BarrelEmpty");
	if not FuelBarrel then
		FuelBarrel = getSpecificPlayer(player):getInventory():FindAndReturn("PetrolBarrel");
	end
	if FuelBarrel then
		context:addOption(getText("ContextMenu_PlaceFuelBarrel"), player, TRFB_Menu.onPlaceFuelBarrel, "trpack_1");	
	end	
	
	
	--Debug
	if getCore():isInDebug() then
		TRFB_Menu.Debug(worldobjects, getSpecificPlayer(player))
	end
end

TRFB_Menu.Debug = function(worldobjects, player)
	for i,v in ipairs(worldobjects) do	
		if instanceof(v, "IsoGenerator") then
			player:Say(getText(tostring(v)));
		end
		if v:getName() == "FuelBarrel" and (v:getModData()["fuelAmount"] > 0 or v:getModData()["connectedGenerator"] or v:getModData()["weight"]) then
			player:Say(getText("FuelAmount: "..tostring(v:getModData()["fuelAmount"])));
			player:Say(getText("Weight: "..tostring(v:getModData()["weight"])));				
			--player:Say(getText(tostring(v:getModData()["connectedGenerator"])));
			if v:getModData()["generatorSquare"] then
			--player:Say(getText(tostring(v:getModData()["generatorSquare"])));
			print(v:getModData()["generatorSquare"][1])
			print(v:getModData()["generatorSquare"][2])
			print(v:getModData()["generatorSquare"][3])
			end
			
			--player:Say(getText(tostring(ISFuelBarrel.weightEmpty)));
			--player:Say(getText(tostring(v:getSprite():getName())));		
			--print("FuelProp: "..tostring(v:getSquare():getProperties():getPropertyNames()));
			break;
		end
	end
	--print(bcUtils.dump(worldobjects));
	--print("Size is: "..#worldobjects);
	--player:Say(getText(tostring(#worldobjects)));
end

TRFB_Menu.onMakeMolotov = function(barrel, player, bottle, sheet)
	if luautils.walkAdj(player, barrel:getSquare()) then
		ISTimedActionQueue.add(ISMakeMolotov:new(player, barrel, bottle, sheet));
	end
end

TRFB_Menu.connectBarrel = function(barrel, generator, player)
	if luautils.walkAdj(player, barrel:getSquare()) then
		local sq = generator:getSquare();
		local square = {sq:getX(),sq:getY(),sq:getZ()}
		local args = { x = barrel:getX(), y = barrel:getY(), z = barrel:getZ(), generatorSquare  = square }
		CFuelBarrelSystem.instance:sendCommand(player, 'connectGenerator', args)
	end
end

TRFB_Menu.getNearbyFuelBarrel = function(generator)
	if not generator then return nil end
	local square = getCell():getGridSquare(generator:getX(), generator:getY(), generator:getZ())
	if not square then return nil end
	for dy=-2,2 do
		for dx=-2,2 do
			-- TODO: check line-of-sight between 2 squares
			local square2 = getCell():getGridSquare(square:getX() + dx, square:getY() + dy, square:getZ())
			if square2 then
				local barrel = CFuelBarrelSystem:getIsoObjectOnSquare(square2);
				if barrel and barrel:getModData()["fuelAmount"] > 0 and not square:isBlockedTo(square2) and not barrel:getModData()["generatorSquare"] then
					return square2, barrel
				end	
			end
		end
	end
end

TRFB_Menu.onTakeBarrel = function(barrel, player)
	if luautils.walkAdj(player, barrel:getSquare()) then
		ISTimedActionQueue.add(ISTakeFuelBarrel:new(player, barrel));
	end
end

TRFB_Menu.onPlaceFuelBarrel = function(player, sprite)
	local FuelBarrel = getSpecificPlayer(player):getInventory():FindAndReturn("BarrelEmpty");
	if not FuelBarrel then
		FuelBarrel = getSpecificPlayer(player):getInventory():FindAndReturn("PetrolBarrel");
	else
		getSpecificPlayer(player):getInventory():Remove(FuelBarrel);
		FuelBarrel = getSpecificPlayer(player):getInventory():AddItem("TRPack.PetrolBarrel");
		FuelBarrel:setUsedDelta(0);
	end
	
	if FuelBarrel then
		local barrel = ISFuelBarrel:new(sprite, FuelBarrel);
		barrel.player = player
		barrel.modData["need:TRPack.PetrolBarrel"] = "1";
		getCell():setDrag(barrel, player);
	end
end

TRFB_Menu.onTakeFuelFromPump = function(player, square)
    local petrolBarrel = player:getInventory():FindAndReturn("BarrelEmpty");
    if petrolBarrel then
        player:getInventory():Remove(petrolBarrel);
        petrolBarrel = player:getInventory():AddItem("TRPack.PetrolBarrel");
        petrolBarrel:setUsedDelta(0);
    else
        local barrels = player:getInventory():getItemsFromType("PetrolBarrel");
        for i=0, barrels:size() -1 do
			if barrels:get(i):getUsedDelta() < 1 then
                petrolBarrel = barrels:get(i);
                break;
            end
        end
    end
	
	local destCapacity = (1 - petrolBarrel:getUsedDelta()) / petrolBarrel:getUseDelta();--Скільки бочка може вмістити
	
    if petrolBarrel and luautils.walkAdj(player, square) then
		ISTimedActionQueue.add(ISEquipWeaponAction:new(player, petrolBarrel, 80, true, true))
        ISTimedActionQueue.add(ISTakeFuelFromPump:new(player, square, petrolBarrel, 30 + destCapacity*4));
    end
end

TRFB_Menu.onAddFuel = function(fuelBarrel, player, square, fuelItem)
	--false if add fuel to barrel
    if fuelItem and luautils.walkAdj(player, square) then
		if fuelItem:getType() == "PetrolCan" then
			ISTimedActionQueue.add(ISEquipWeaponAction:new(player, fuelItem, 40, true))
		else
			ISTimedActionQueue.add(ISEquipWeaponAction:new(player, fuelItem, 80, true, true))
		end
		ISTimedActionQueue.add(ISFuelBarrelActions:new(false, fuelBarrel, player, fuelItem, 40));
    end
end

TRFB_Menu.onTakeFuel = function(fuelBarrel, player, square, fuelItem)
	local equip = nil;
	if fuelItem:isEquipped() then equip = true end
	
	if fuelItem:getType() =="EmptyPetrolCan" then
		player:getInventory():Remove(fuelItem);
		fuelItem = player:getInventory():AddItem("Base.PetrolCan");
		fuelItem:setUsedDelta(0);
		if equip then
			player:setPrimaryHandItem(fuelItem);
		end
	elseif fuelItem:getType() =="BarrelEmpty" then
		player:getInventory():Remove(fuelItem);
		fuelItem = player:getInventory():AddItem("TRPack.PetrolBarrel");
		fuelItem:setUsedDelta(0);
		if equip then
			player:setPrimaryHandItem(fuelItem);
			player:setSecondaryHandItem(fuelItem);
		end
	end
	
	--true if take fuel from barrel
    if fuelItem and luautils.walkAdj(player, square) then
		if fuelItem:getType() == "PetrolCan" then
			ISTimedActionQueue.add(ISEquipWeaponAction:new(player, fuelItem, 40, true))
		else
			ISTimedActionQueue.add(ISEquipWeaponAction:new(player, fuelItem, 80, true, true))
		end
		ISTimedActionQueue.add(ISFuelBarrelActions:new(true, fuelBarrel, player, fuelItem, 40));
    end
end


Events.OnPreFillWorldObjectContextMenu.Add(TRFB_Menu.Option);
Events.OnFillWorldObjectContextMenu.Add(TRFB_Menu.doMenu);