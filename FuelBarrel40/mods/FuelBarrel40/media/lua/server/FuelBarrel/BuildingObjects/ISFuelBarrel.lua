--***********************************************************
--**                    THE INDIE STONE                    **
--***********************************************************

require "ISBuildingObject"

-- this class extend ISBuildingObject, it's a class to help you drag around/place an item in the world
ISFuelBarrel = ISBuildingObject:derive("ISFuelBarrel");
ISFuelBarrel.fuelMax = 120;
ISFuelBarrel.weightRatio = 0.625;
ISFuelBarrel.weightEmpty = ScriptManager.instance:FindItem("TRPack.BarrelEmpty"):getActualWeight();

function ISFuelBarrel:create(x, y, z, north, sprite)
	-- local fuelBarrel = getSpecificPlayer(self.player):getInventory():FindAndReturn("BarrelEmpty");
    -- if fuelBarrel then
        -- getSpecificPlayer(self.player):getInventory():Remove(fuelBarrel);
        -- fuelBarrel = getSpecificPlayer(self.player):getInventory():AddItem("TRPack.PetrolBarrel");
        -- fuelBarrel:setUsedDelta(0);
    -- else
        -- local barrels = getSpecificPlayer(self.player):getInventory():getItemsFromType("PetrolBarrel");
		-- fuelBarrel = barrels:get(0);
    -- end
	
	local plObj = getSpecificPlayer(self.player)
	
	local fuelAmount = self.fuelBarrel:getUsedDelta()/self.fuelBarrel:getUseDelta();
	local weight = self.fuelBarrel:getActualWeight()
	
	if plObj:getPrimaryHandItem() == self.fuelBarrel then --...or are equiped primary...
		plObj:setPrimaryHandItem(nil);
	end
	if plObj:getSecondaryHandItem() == self.fuelBarrel then --...or are equiped secondary...
		plObj:setSecondaryHandItem(nil); --remove them from being equipped
	end	
	
	plObj:getInventory():Remove(self.fuelBarrel);


    local cell = getWorld():getCell();
    self.sq = cell:getGridSquare(x, y, z);
    self.javaObject = IsoThumpable.new(cell, self.sq, sprite, north, self);
    buildUtil.setInfo(self.javaObject, self);
    --buildUtil.consumeMaterial(self);
    self.javaObject:setMaxHealth(200);
    self.javaObject:setBreakSound("BreakObject");
    self.sq:AddSpecialObject(self.javaObject);
    self.javaObject:getModData()["fuelMax"] = ISFuelBarrel.fuelMax;
    self.javaObject:getModData()["fuelAmount"] = fuelAmount;
    self.javaObject:getModData()["weight"] = weight;
	--self.javaObject:getModData()["connectedGenerator"] = nil;
    self.javaObject:getModData()["generatorSquare"] = nil;
    self.javaObject:setSpecialTooltip(true)
	
    -- local barrel = {};
    -- barrel.x = self.sq:getX();
    -- barrel.y = self.sq:getY();
    -- barrel.z = self.sq:getZ();
	-- barrel.fuelAmount = fuelAmount;
	-- barrel.fuelMax = fuelMax;
	-- barrel.weight = weight;
	-- barrel.connectedGenerator = nil;
	-- barrel.generatorSquare = nil;
	
    self.javaObject:transmitCompleteItemToServer(); 
	-- OnObjectAdded event will create the SRainBarrelGlobalObject on the server.
    -- This is only needed for singleplayer which doesn't trigger OnObjectAdded.
    triggerEvent("OnObjectAdded", self.javaObject)
end

function ISFuelBarrel:new(sprite, fuelBarrel)
    local o = {};
    setmetatable(o, self);
    self.__index = self;
    o:init();
    o:setSprite(sprite);
    o:setNorthSprite(sprite);
    o.noNeedHammer = true;
	o.fuelBarrel = fuelBarrel;
    o.name = "FuelBarrel";
    o.dismantable = true;	
	--o.blockAllTheSquare = true;
	o.maxTime = 80;
    return o;
end

-- our barrel can be placed on this square ?
-- this function is called everytime you move the mouse over a grid square, you can for example not allow building inside house..
function ISFuelBarrel:isValid(square)
    if not square then return false end
    if square:isSolid() or square:isSolidTrans() then return false end
    if square:HasStairs() then return false end
    if square:HasTree() then return false end
    if not square:getMovingObjects():isEmpty() then return false end
    if not square:TreatAsSolidFloor() then return false end
    if not self:haveMaterial(square) then return false end
    for i=1,square:getObjects():size() do
        local obj = square:getObjects():get(i-1)
        if self:getSprite() == obj:getTextureName()
		or instanceof(obj, "IsoGenerator") 
		or CCampfireSystem.instance:isValidIsoObject(obj)then return false end
    end
    if buildUtil.stairIsBlockingPlacement( square, true ) then return false; end
    return true
end

-- called after render the ghost objects
-- the ISBuildingObject only render 1 sprite (north, south...), for example for stairs I can render the 2 others tile for stairs here
-- if I return false, the ghost render will be in red and I couldn't build the item
function ISFuelBarrel:render(x, y, z, square)
    ISBuildingObject.render(self, x, y, z, square)
end





-- function ISFuelBarrel.isISFuelBarrelObject(object)
    -- return object ~= nil and object:getName() == "Fuel Barrel"
-- end

-- function ISFuelBarrel.findObject(square)
    -- if not square then return nil end
    -- for i=0,square:getSpecialObjects():size()-1 do
        -- local obj = square:getSpecialObjects():get(i)
        -- if ISFuelBarrel.isISFuelBarrelObject(obj) then
            -- return obj
        -- end
    -- end
    -- return nil
-- end


-- function ISFuelBarrel.LoadGridsquare(square)
    -- if isClient() then return; end
    -- -- does this square have a rain barrel ?
    -- for i=0,square:getSpecialObjects():size() - 1 do
        -- local obj = square:getSpecialObjects():get(i)
        -- if ISFuelBarrel.isISFuelBarrelObject(obj) then
            -- ISFuelBarrel.loadFuelBarrel(obj)
            -- break
        -- end
    -- end
-- end

-- function ISFuelBarrel.loadGridsquareJavaHook(sq, object)
    -- if isClient() then return; end
    -- ISFuelBarrel.loadFuelBarrel(object)
-- end

-- -- load the barrel
-- function ISFuelBarrel.loadFuelBarrel(barrelObject)
    -- if not barrelObject or not barrelObject:getSquare() then return end
    -- local square = barrelObject:getSquare()
    -- local barrel = nil;
    -- -- check if we don't already have this barrel in our map (the streaming of the map make the gridsquare to reload every time)
    -- for i,v in ipairs(ISFuelBarrel.barrels) do
        -- if v.x == square:getX() and v.y == square:getY() and v.z == square:getZ() then
            -- barrel = v;
            -- break;
        -- end
    -- end
    -- if not barrel then -- if we don't have the barrel, it's basically when you load your saved game the first time
        -- barrel = {};
        -- barrel.x = square:getX();
        -- barrel.y = square:getY();
        -- barrel.z = square:getZ();
		-- barrel.fuelAmount = barrelObject:getModData()["fuelAmount"];
		-- barrel.fuelMax = barrelObject:getModData()["fuelMax"];
		-- barrel.weight = barrelObject:getModData()["weight"];
		-- barrel.connectedGenerator = barrelObject:getModData()["connectedGenerator"];
		-- barrel.generatorSquare = barrelObject:getModData()["generatorSquare"];
		-- table.insert(ISFuelBarrel.barrels, barrel);
    -- else
        -- barrelObject:getModData()["fuelAmount"]= barrel.fuelAmount;
        -- barrelObject:getModData()["weight"]= barrel.weight;
		-- barrelObject:getModData()["connectedGenerator"] = barrel.connectedGenerator;
		-- barrelObject:getModData()["generatorSquare"] = barrel.generatorSquare;
    -- end

    -- barrelObject:setSpecialTooltip(true)
    -- barrelObject:getModData()["fuelMax"] = barrel.fuelMax
    -- barrel.exterior = square:isOutside()
-- end

-- -- Called when the client adds an object to the map (which it shouldn't be able to)
-- ISFuelBarrel.OnObjectAdded = function(object)
    -- if isClient() then return end
    -- if ISFuelBarrel.isISFuelBarrelObject(object) then
        -- ISFuelBarrel.loadFuelBarrel(object)
    -- end
-- end

-- function ISFuelBarrel.OnDestroyIsoThumpable(thump, player)
    -- if isClient() then return end
    -- if not thump:getSquare() or not ISFuelBarrel.isISFuelBarrelObject(thump) then
        -- return
    -- end
    -- local sq = thump:getSquare()
    -- if not sq then return end
        -- for iB,vB in ipairs(ISFuelBarrel.barrels) do
        -- if vB.x == sq:getX() and vB.y == sq:getY() and vB.z == sq:getZ() then
            -- noise('destroyed at '..vB.x..','..vB.y..','..vB.z)
        -- table.remove(ISFuelBarrel.barrels, iB)
        -- break
        -- end
    -- end
-- end

-- function ISFuelBarrel.getLuaObject(barrel)
    -- if not barrel then return nil; end
    -- for _,vB in ipairs(ISFuelBarrel.barrels) do
        -- if vB.x == barrel:getX() and vB.y == barrel:getY() and vB.z == barrel:getZ() then
            -- return vB;
        -- end
    -- end
-- end



-- function ISFuelBarrel.checkGenerator()
    -- if isClient() then return; end
	-- noise("Barrel Count: "..#ISFuelBarrel.barrels) --debug mode
	-- for i,vB in ipairs(ISFuelBarrel.barrels) do	
		-- ISFuelBarrel.setModData(vB);	
		-- local square = getCell():getGridSquare(vB.x, vB.y, vB.z);
		-- if square then
			-- local barrelObject = RainCollectorBarrel.findObject(square)
			-- if barrelObject then
				-- if not vB.connectedGenerator and vB.generatorSquare then
					-- local sq = getWorld():getCell():getGridSquare(vB.generatorSquare[1],vB.generatorSquare[2],vB.generatorSquare[3])
					-- if sq then
						-- for i=0,sq:getObjects():size() - 1 do
							-- local obj = sq:getObjects():get(i)
							-- if instanceof(obj, "IsoGenerator") then
								-- vB.connectedGenerator = obj
								-- barrelObject:getModData()["connectedGenerator"] = obj;
								-- barrelObject:transmitModData();
								-- break
							-- end
						-- end
					-- end
				-- end 
				
				-- if not vB.connectedGenerator then 
					-- vB.generatorSquare = nil
					-- barrelObject:getModData()["generatorSquare"] = nil;
					-- barrelObject:transmitModData();
					-- noise("No generator!") --debug mode
				-- else	
					-- noise("Generator is: "..tostring(vB.connectedGenerator)) --debug mode
					-- if vB.fuelAmount > 0 and vB.connectedGenerator:getFuel() < 90 then
						-- print(vB.fuelAmount);
						-- local endFuel = 0;
						-- while vB.fuelAmount > 0 and (vB.connectedGenerator:getFuel() + endFuel) < 100 do
							-- vB.fuelAmount = vB.fuelAmount - 0.1;
							-- endFuel = endFuel + 1;
						-- end
						-- vB.connectedGenerator:setFuel(vB.connectedGenerator:getFuel() + endFuel);
						-- vB.weight = (0.625 * vB.fuelAmount) + 5;
						-- barrelObject:getModData()["fuelAmount"] = vB.fuelAmount;
						-- barrelObject:getModData()["weight"] = vB.weight;
						-- barrelObject:transmitModData();
					-- end
				-- end
			-- end
		-- end
		-- --ISFuelBarrel.setModData(vB);
	-- end
-- end

