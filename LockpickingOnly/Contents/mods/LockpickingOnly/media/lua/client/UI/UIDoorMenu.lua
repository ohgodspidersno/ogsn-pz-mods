require('luautils');

-- ------------------------------------------------
-- Local Functions
-- ------------------------------------------------

---
-- Tests if the door is open, locked or barricaded or inside of a house.
-- @param door - The door to check.
-- @return - False if it is open, barricaded or not locked.
--
local function isValidDoor(door, character)
    return not door:IsOpen()
            and door:isLocked()
            and not door:isBarricaded()
            and door:isExteriorDoor(character);
end

---
-- This function calculates the time it will take to break
-- the lock. Then it walks the player to the door, equips
-- the crowbar and starts the timed action to break the
-- lock.
-- @param worldObjects - List of all clicked items.
-- @param door - The door to open.
-- @param player - The active player.
-- Destroy lock time affected by: Panic, nimblefingers, Athletic, Handy, Strong, Stout, Fit, Out of Shape, Feeble, Weak, Asthmatic, Unfit
local function breakLock(worldObjects, door, player)
    local modData = door:getModData();
    local panic = player:getStats():getPanic()
    local panicModifier = math.floor((panic/40)+1) -- ranges from 1 to 3
    local time = 150 + (modData.lockLevel + 1) * 10 * panicModifier;

    -- Traits affect the length of the lockbreaking.
    -- Niblefingers starts by cutting the base in half
    if player:HasTrait("nimblefingers") then
        time = time/2;
    end
    -- GREAT traits:  Athletic, Handy, Strong
    if player:HasTrait("Athletic") then
        time = time - ZombRand(25);
    end
    if player:HasTrait("Handy") then
        time = time - ZombRand(25);
    end
    if player:HasTrait("Strong") then
        time = time - ZombRand(25);
    end
    -- GOOD traits: Stout, Fit
    if player:HasTrait("Stout") then
        time = time - ZombRand(15);
    end
    if player:HasTrait("Fit") then
        time = time - ZombRand(15);
    end
    -- BAD traits: Out of Shape, Feeble
    if player:HasTrait("Out of Shape") then
      time = time + ZombRand(15);
    end
    if player:HasTrait("Feeble") then
      time = time + ZombRand(15);
    end
    -- AWFUL traits: Weak, Asthmatic, Unfit
    if player:HasTrait("Weak") then
        time = time + ZombRand(25);
    end
    if player:HasTrait("Asthmatic") then
        time = time + ZombRand(25);
    end
    if player:HasTrait("Unfit") then
        time = time + ZombRand(25);
    end

    -- Walk to the door and start the Timed Action.
    if luautils.walkToObject(player, door) then
        local primItem, scndItem = luautils.equipItems(player, "Crowbar");

        ISTimedActionQueue.add(TABreakDoorLock:new(player, door, time, primItem, scndItem));
    end
end

---
-- @param worldObjects
-- @param door
-- @param player
--
local function pickLock(worldObjects, door, player)
    local modData = door:getModData();
    local panic = player:getStats():getPanic()
    local panicModifier = math.floor((panic/25)+1) -- ranges from 1 to 5

    -- If the lock is broken, we display a modal and end the function here.
    if modData.lockLevel == 6 then
        luautils.okModal(FMJlockPicking_Text.brokenLockModal, true);
        return;
    end

    local time = (250 + (modData.lockLevel + 1) * 10 + ZombRand(75))*panicModifier;

    -- Traits affect the length of the lockpicking.
    if player:HasTrait("nimblefingers") or (player:HasTrait("nimblefingers2")) then
        time = time - 50;
    end
    if player:HasTrait("Handy") then
        time = time - ZombRand(50);
    end

    if luautils.walkAdjWindowOrDoor(player, door:getSquare(), door) then
        -- Walk to the door and start the Timed Action.
        local primItem, scndItem = luautils.equipItems(player, "Screwdriver", "BobbyPin");

        ISTimedActionQueue.add(TAPickDoorLock:new(player, door, time, primItem, scndItem));
    end
end


---
-- Creates the context menu entries for lockpicking and
-- lockbreaking. If the selected door doesn't have a lockLevel
-- yet it assigns a random one to it.
-- @param player - The player who clicked the door.
-- @param context - The context menu.
-- @param worldObjects - A list of clicked items.
--
local function createMenuEntries(player, context, worldObjects)
    local door;
    local modData;

    -- Search through the table of clicked items.
    for _, object in ipairs(worldObjects) do
        -- Look if the clicked item is of type door.
        if instanceof(object, "IsoDoor") or (instanceof(object, "IsoThumpable") and object:isDoor()) then
            door = object;
            break;
        end
    end

    -- Exit early if we have no door.
    if not door then return end

    local player = getSpecificPlayer(player);

    -- Test if we have a valid door to open.
    if not isValidDoor(door, player) then
        print("No valid door to open.");
        return false;
    else
        -- Load the doors mod data.
        modData = door:getModData();
        modData.lockLevel = modData.lockLevel or 0;

        -- If we have no lock level yet, assign one.
        if modData.lockLevel == 0 then
            modData.lockLevel = ZombRand(5) + 1;
        end
    end

    local inventory = player:getInventory();

    -- Add context option for breaking the lock.
    if inventory:contains("Crowbar") then
        local primItem = inventory:FindAndReturn("Crowbar");

        if not primItem or primItem:getCondition() <= 0 or not player:getKnownRecipes():contains("Break Door Locks") then
            print("No Break Door Locks or valid crowbar");
        else
            context:addOption(FMJlockPicking_Text.contextBreakDoorLock .. " (" .. FMJlockPicking_Text.lockLevels[modData.lockLevel] .. ")", worldObjects, breakLock, door, player);
        end
    end

    -- Add context option for picking the lock.
    if inventory:contains("Screwdriver") and inventory:contains("BobbyPin") then
        local primItem = inventory:FindAndReturn("Screwdriver");
        local scndItem = inventory:FindAndReturn("BobbyPin");

        if not primItem or primItem:getCondition() <= 0 or not scndItem or scndItem:getCondition() <= 0 or not player:getKnownRecipes():contains("Lockpicking") then
            print("No Lockpicking or valid screwdriver / hairpin");
        else
            context:addOption(FMJlockPicking_Text.contextPickDoorLock .. " (" .. FMJlockPicking_Text.lockLevels[modData.lockLevel] .. ")", worldObjects, pickLock, door, player);
        end
    end
end

-- ------------------------------------------------
-- Game hooks
-- ------------------------------------------------

Events.OnFillWorldObjectContextMenu.Add(createMenuEntries);
