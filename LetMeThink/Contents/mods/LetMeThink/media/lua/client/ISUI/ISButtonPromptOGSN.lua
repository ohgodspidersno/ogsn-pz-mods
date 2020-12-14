
function ISButtonPrompt:getBestAButtonAction(dir)

    if UIManager.getSpeedControls() and UIManager.getSpeedControls():getCurrentGameSpeed() == 0 then
        self:setAPrompt(nil, nil, nil);
        return;
    end

    if dir == nil then
        self:setAPrompt(nil, nil, nil);
    end

    if getCell():getDrag(self.player) then
        self:setAPrompt(getCell():getDrag(self.player):getAPrompt(), nil);
    end

    local playerObj = getSpecificPlayer(self.player)

    if playerObj:getIgnoreMovement() or playerObj:isAsleep() then return end

    local vehicle = playerObj:getVehicle()
    if vehicle then
        self:setAPrompt(getText("IGUI_ExitVehicle"), self.cmdExitVehicle)
        return
    end

    local square1 = playerObj:getCurrentSquare();
    if square1 == nil then return; end

    if dir == nil then
        dir = playerObj:getDir();
    end

    if dir == IsoDirections.NE then
        self:testAButtonAction(IsoDirections.N);
        self:testAButtonAction(IsoDirections.E);
    elseif dir == IsoDirections.SE then
        self:testAButtonAction(IsoDirections.S);
        self:testAButtonAction(IsoDirections.E);
    elseif dir == IsoDirections.SW then
        self:testAButtonAction(IsoDirections.S);
        self:testAButtonAction(IsoDirections.W);
    elseif dir == IsoDirections.NW then
        self:testAButtonAction(IsoDirections.N);
        self:testAButtonAction(IsoDirections.W);
    else
        self:testAButtonAction(dir);
    end

    if self.aPrompt then return end

    -- Nothing was found in the direction the player is facing.
    -- Try a door, window or windowframe behind the player.
    local dir1 = nil
    local dir2 = nil
    if dir == IsoDirections.NW then
        dir1 = IsoDirections.S
        dir2 = IsoDirections.E
    elseif dir == IsoDirections.NE then
        dir1 = IsoDirections.S
        dir2 = IsoDirections.W
    elseif dir == IsoDirections.SE then
        dir1 = IsoDirections.N
        dir2 = IsoDirections.W
    elseif dir == IsoDirections.SW then
        dir1 = IsoDirections.N
        dir2 = IsoDirections.E
    else
        dir1 = dir:RotLeft(4) -- 180 degrees
    end
    local obj = nil
    if dir1 ~= nil then
        obj = playerObj:getContextDoorOrWindowOrWindowFrame(dir1)
        if obj then
            self:doAButtonDoorOrWindowOrWindowFrame(dir1, obj)
            return
        end
    end
    if dir2 ~= nil then
        obj = playerObj:getContextDoorOrWindowOrWindowFrame(dir2)
        if obj then
            self:doAButtonDoorOrWindowOrWindowFrame(dir1, obj)
            return
        end
    end
end


function ISButtonPrompt:getBestBButtonAction(dir)

    if UIManager.getSpeedControls() and UIManager.getSpeedControls():getCurrentGameSpeed() == 0 then
        self:setBPrompt(nil, nil, nil);
        return;
    end

    if dir == nil then
        self:setBPrompt(nil, nil, nil);
    end

    if getCell():getDrag(self.player) then
        self:setBPrompt(getText("UI_Cancel"), nil);
        return
    end

    local playerObj = getSpecificPlayer(self.player)

    if isPlayerDoingActionThatCanBeCancelled(playerObj) then
        self:setBPrompt(getText("UI_Cancel"), ISButtonPrompt.stopAction);
        return
    end

    if playerObj:getIgnoreMovement() or playerObj:isAsleep() then return end

    local vehicle = playerObj:getVehicle()
    if vehicle then
        if vehicle:isDriver(playerObj) and vehicle:isEngineRunning() then
            self:setBPrompt(getText("IGUI_VehicleApplyBrakes"))
        else
            self:setBPrompt(nil, nil, nil)
        end
        return
    end

    if playerObj:isSprinting() then
        self:setBPrompt(getText("IGUI_StopSprint"), nil)
        return
    elseif playerObj:isRunning() and playerObj:canSprint() then
        self:setBPrompt(getText("IGUI_StartSprint"), nil)
        return
    end

    local square1 = playerObj:getCurrentSquare();
    if square1 == nil then return; end

    if dir == nil then
        dir = getSpecificPlayer(self.player):getDir();
    end

    if dir == IsoDirections.NE then
        self:testBButtonAction(IsoDirections.N)
        self:testBButtonAction(IsoDirections.E)
    elseif dir == IsoDirections.SE then
        self:testBButtonAction(IsoDirections.S)
        self:testBButtonAction(IsoDirections.E)
    elseif dir == IsoDirections.SW then
        self:testBButtonAction(IsoDirections.S)
        self:testBButtonAction(IsoDirections.W)
    elseif dir == IsoDirections.NW then
        self:testBButtonAction(IsoDirections.N)
        self:testBButtonAction(IsoDirections.W)
    else
        self:testBButtonAction(dir)
    end

    if self.bPrompt then return end

    -- Nothing was found in the direction the player is facing.
    -- Try a door, window or windowframe behind the player.
    local dir1 = nil
    local dir2 = nil
    if dir == IsoDirections.NW then
        dir1 = IsoDirections.S
        dir2 = IsoDirections.E
    elseif dir == IsoDirections.NE then
        dir1 = IsoDirections.S
        dir2 = IsoDirections.W
    elseif dir == IsoDirections.SE then
        dir1 = IsoDirections.N
        dir2 = IsoDirections.W
    elseif dir == IsoDirections.SW then
        dir1 = IsoDirections.N
        dir2 = IsoDirections.E
    else
        dir1 = dir:RotLeft(4) -- 180 degrees
    end
    local obj = nil
    if dir1 ~= nil then
        obj = playerObj:getContextDoorOrWindowOrWindowFrame(dir1)
        if obj then
            self:doBButtonDoorOrWindowOrWindowFrame(dir1, obj)
            return
        end
    end
    if dir2 ~= nil then
        obj = playerObj:getContextDoorOrWindowOrWindowFrame(dir2)
        if obj then
            self:doBButtonDoorOrWindowOrWindowFrame(dir1, obj)
            return
        end
    end
end


function ISButtonPrompt:getBestYButtonAction(dir)

    if UIManager.getSpeedControls() and UIManager.getSpeedControls():getCurrentGameSpeed() == 0 then
        self:setYPrompt(nil, nil, nil);
        return;
    end

    if dir == nil then
        self:setYPrompt(nil, nil, nil);
    end

    if getCell():getDrag(self.player) then
        self:setYPrompt(nil, nil, nil);
        return;
    end

    local playerObj = getSpecificPlayer(self.player)
    if playerObj:getVehicle() then
        self.isLoot = false
        self:setYPrompt(getText("IGUI_Controller_Inventory"), nil, nil)
        return
    end

    if ISButtonPrompt.test == nil then
        ISButtonPrompt.test = {}
        ISButtonPrompt.test.sqs = {}
    end

    local sqs = ISButtonPrompt.test.sqs;
    ISButtonPrompt.test.square = getSpecificPlayer(self.player):getCurrentSquare();
    local square=ISButtonPrompt.test.square;
    if square == nil then return; end
    local cx = square:getX();
    local cy = square:getY();
    local cz = square:getZ();

    if dir == nil then
        dir = getSpecificPlayer(self.player):getDir();
    end

    if(dir == IsoDirections.N) then         sqs[2] = getCell():getGridSquare(cx-1, cy-1, cz); sqs[3] = getCell():getGridSquare(cx, cy-1, cz); sqs[4] = getCell():getGridSquare(cx+1, cy-1, cz);
    elseif (dir == IsoDirections.NE) then   sqs[2] = getCell():getGridSquare(cx, cy-1, cz); sqs[3] = getCell():getGridSquare(cx+1, cy-1, cz); sqs[4] = getCell():getGridSquare(cx+1, cy, cz);
    elseif (dir == IsoDirections.E) then    sqs[2] = getCell():getGridSquare(cx+1, cy-1, cz); sqs[3] = getCell():getGridSquare(cx+1, cy, cz); sqs[4] = getCell():getGridSquare(cx+1, cy+1, cz);
    elseif (dir == IsoDirections.SE) then   sqs[2] = getCell():getGridSquare(cx+1, cy, cz); sqs[3] = getCell():getGridSquare(cx+1, cy+1, cz); sqs[4] = getCell():getGridSquare(cx, cy+1, cz);
    elseif (dir == IsoDirections.S) then    sqs[2] = getCell():getGridSquare(cx+1, cy+1, cz); sqs[3] = getCell():getGridSquare(cx, cy+1, cz); sqs[4] = getCell():getGridSquare(cx-1, cy+1, cz);
    elseif (dir == IsoDirections.SW) then   sqs[2] = getCell():getGridSquare(cx, cy+1, cz); sqs[3] = getCell():getGridSquare(cx-1, cy+1, cz); sqs[4] = getCell():getGridSquare(cx-1, cy, cz);
    elseif (dir == IsoDirections.W) then    sqs[2] = getCell():getGridSquare(cx-1, cy+1, cz); sqs[3] = getCell():getGridSquare(cx-1, cy, cz); sqs[4] = getCell():getGridSquare(cx-1, cy-1, cz);
    elseif (dir == IsoDirections.NW) then   sqs[2] = getCell():getGridSquare(cx-1, cy, cz); sqs[3] = getCell():getGridSquare(cx-1, cy-1, cz); sqs[4] = getCell():getGridSquare(cx, cy-1, cz);
    end

    if sqs[2] == nil then return; end

    sqs[1] = square;

    local loot = false;
    for x = 1, 4 do
        if loot then break; end
        local gs = sqs[x];

        -- stop grabbing thru walls...
        if gs ~= getSpecificPlayer(self.player):getCurrentSquare() and getSpecificPlayer(self.player):getCurrentSquare():isWallTo(gs) then
            gs = nil
        end

        if gs ~= nil then

            --for y = -1, 1 do
            local obs = gs:getObjects();
            local sobs =  gs:getStaticMovingObjects();
            local wobs = gs:getWorldObjects();

            if wobs ~= nil then
                if not wobs:isEmpty() then
                    loot = true
                    break
                end
                for i = 0, wobs:size()-1 do
                    local o = wobs:get(i);
                    if instanceof(o, "IsoWorldInventoryObject") then
                        loot = true;
                        break;
                    end
                end
            end

            for i = 0, sobs:size()-1 do
                local so = sobs:get(i);

                if so:getContainer() ~= nil then
                    loot = true;
                    break;

                end

            end
            for i = 0, obs:size()-1 do
                local o = obs:get(i);


                if o:getContainer() ~= nil then
                    loot = true;
                    break;

                end
             end
        end
    end

    if loot then
	    self.isLoot = true;
        self:setYPrompt(getText("IGUI_Controller_Loot"), nil, nil);

    else
		if not getSpecificPlayer(self.player):isAsleep() then
			self.isLoot = false;
			self:setYPrompt(getText("IGUI_Controller_Inventory"), nil, nil);
        end
    end
end


function ISButtonPrompt:getBestXButtonAction(dir)
    if UIManager.getSpeedControls() and UIManager.getSpeedControls():getCurrentGameSpeed() == 0 then
        self:setXPrompt(nil, nil, nil);
        return;
    end

    if dir == nil then
        self:setXPrompt(nil, nil, nil);
    end

    if getCell():getDrag(self.player) then
        self:setXPrompt(nil, nil, nil);
        return;
    end

    local playerObj = getSpecificPlayer(self.player)
    local vehicle = playerObj:getVehicle()
    if vehicle then
        if vehicle:isDriver(playerObj) then
            self:setXPrompt(getText("IGUI_Controller_CruiseControl"), ISVehicleRegulator.onJoypadPressX, JoypadState.players[self.player+1])
        end
        return
    end

    if getSpecificPlayer(self.player):isAsleep() then return end

    -- The context-menu code is far too slow to be called every frame.
    -- So always display the 'interact' prompt, even if pressing X has no effect.
    self:setXPrompt(getText("IGUI_Controller_Interact"), ISButtonPrompt.interact, objects)
end


function ISButtonPrompt:getBestLBButtonAction(dir)
    if UIManager.getSpeedControls() and UIManager.getSpeedControls():getCurrentGameSpeed() == 0 then
        self:setLBPrompt(nil, nil, nil);
        return;
    end

    if getCell():getDrag(self.player) then
        self:setLBPrompt(getCell():getDrag(self.player):getLBPrompt(), nil, nil);
    elseif ISFirearmRadialMenu.getBestLBButtonAction(self) then
    else
        self:setLBPrompt(nil, nil, nil);
    end
end

function ISButtonPrompt:getBestRBButtonAction(dir)
    if UIManager.getSpeedControls() and UIManager.getSpeedControls():getCurrentGameSpeed() == 0 then
        self:setRBPrompt(nil, nil, nil);
        return;
    end

    if getCell():getDrag(self.player) then
        self:setRBPrompt(getCell():getDrag(self.player):getRBPrompt(), nil, nil);
    elseif ISFirearmRadialMenu.getBestRBButtonAction(self) then
    else
        self:setRBPrompt(nil, nil, nil);
    end
end
