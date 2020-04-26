require('TimedActions/ISBaseTimedAction');
require('luautils');

-- ------------------------------------------------
-- Global Variables
-- ------------------------------------------------

TABreakDoorLock = ISBaseTimedAction:derive("TABreakDoorLock");

-- ------------------------------------------------
-- Constants
-- ------------------------------------------------

local BASE_CHANCE = 4;
local NOISE_SUCCESS = 25;
local NOISE_FAILURE = 35;

-- ------------------------------------------------
-- Local Functions
-- ------------------------------------------------

---
-- This function modifies the chance of breaking the lock successfully.
-- The higher the chance value, the higher is the chance of success.
-- @param - The player trying to break the lock.
-- Chance to destroy lock affected by: panic, nimblefingers, lucky
local function calculateChance(player)
    local panic = player:getStats():getPanic()
    local panicModifier = math.floor((panic/28)) -- ranges from 0 to 3
    local chance = BASE_CHANCE-panicModifier;
    if player:HasTrait('nimblefingers') or (player:HasTrait('nimblefingers2')) then
        chance = chance + 2;
    end
    if player:HasTrait('Lucky') then
        chance = chance + 2;
    elseif player:HasTrait('Unlucky') then
        chance = chance - 4;
    end

    return math.max(3, chance);
end

---
-- This function calculates a noise modifer based on the player's traits.
-- @param - The player trying to break the lock.
-- Sound of destroying lock affected by: nimblefingers, noiseiness, panic
local function calculateNoiseModifier(player)
  local panic = player:getStats():getPanic()
  local panicModifier = math.floor((panic/28)) -- ranges from 0 to 3
  local noiseModifier = panicModifier;
    if player:HasTrait('nimblefingers') or (player:HasTrait('nimblefingers2')) then
        noiseModifier = noiseModifier - 3;
    end
    if player:HasTrait('Clumsy') then
        noiseModifier = noiseModifier + 6;
    elseif player:HasTrait('Graceful') then
        noiseModifier = noiseModifier - 5;
    end
    return noiseModifier;
end

-- ------------------------------------------------
-- Functions
-- ------------------------------------------------

---
-- The condition which tells the timed action if it
-- is still valid.
--
function TABreakDoorLock:isValid()
    return self.character:getPrimaryHandItem():getType() == "Crowbar";
end

---
-- Stops the Timed Action and re-equips the previous
-- used items.
--
function TABreakDoorLock:stop()
    luautils.equipItems(self.character, self.storedPrim, self.storedScnd);
    ISBaseTimedAction.stop(self);
end

---
-- Is called when the time has passed.
--
function TABreakDoorLock:perform()
    local door = self.object;
    local tile = door:getSquare();
    local player = self.character;
    local item = player:getPrimaryHandItem();
    local chance = calculateChance(player);
    local noiseModifier = calculateNoiseModifier(player);

    -- Check if breaking the lock is successful.
    if ZombRand(chance) == 0 then
        -- Play world sound and add an attraction point for that sound to the world.
        getSoundManager():PlayWorldSound("sledgehammer", false, tile, 0, 15, 20, true);
        addSound(door, tile:getX(), tile:getY(), tile:getZ(), NOISE_FAILURE + noiseModifier, 30);
    else
        -- Play world sound and add an attraction point for that sound to the world.
        getSoundManager():PlayWorldSound("crackwood", false, tile, 0, 10, 15, true);
        addSound(door, tile:getX(), tile:getY(), tile:getZ(), NOISE_SUCCESS + noiseModifier, 30);

        -- Open the door (silent).
        door:ToggleDoorSilent();

    end

    -- Damage weapon and update player stats.
    luautils.weaponLowerCondition(item, player, false);
    player:getStats():setEndurance(player:getStats():getEndurance() + 1.0);

    -- Re-equip the previous items after completing the action.
    luautils.equipItems(self.character, self.storedPrim, self.storedScnd);

    -- Remove Timed Action from stack.
    ISBaseTimedAction.perform(self);
end

---
-- Constructor
--
function TABreakDoorLock:new(character, object, time, primItem, scndItem)
    local o = {};
    setmetatable(o, self);
    self.__index = self;
    o.character = character;
    o.object = object;
    o.storedPrim = primItem;
    o.storedScnd = scndItem;
    o.stopOnWalk = true;
    o.stopOnRun = true;
    o.maxTime = time;
    return o;
end
