require('TimedActions/ISBaseTimedAction');
require('luautils');

-- ------------------------------------------------
-- Global Variables
-- ------------------------------------------------

TABreakWindowLock = ISBaseTimedAction:derive("TABreakWindowLock");

-- ------------------------------------------------
-- Constants
-- ------------------------------------------------

local BASE_CHANCE = 5;
local NOISE_SUCCESS = 15;
local NOISE_FAILURE = 20;

-- ------------------------------------------------
-- Local Functions
-- ------------------------------------------------

---
-- This function modifies the chance of breaking the lock successfully.
-- The higher the chance value, the higher is the chance of success.
-- @param - The player trying to break the lock.
-- Chance to destroy lock affected by:
--    Perks:
--    Traits: nimblefingers, lucky
--
local function calculateChance(player)
    local chance = BASE_CHANCE;
    if player:HasTrait('nimblefingers') or (player:HasTrait('nimblefingers2')) then
        chance = chance + 1;
    end
    if player:HasTrait('Lucky') then
        chance = chance + 2;
    elseif player:HasTrait('Unlucky') then
        chance = chance - 2;
    end
    return chance;
end

---
-- This function calculates a noise modifer based on the player's traits.
-- @param - The player trying to break the lock.
-- Sound volume lock affected by:
--    Traits: nimblefingers, noiseiness
local function calculateNoiseModifier(player)
    local noiseModifier = 0;
    if player:HasTrait('nimblefingers') or (player:HasTrait('nimblefingers2')) then
        noiseModifier = noiseModifier - 3;
    end
    if player:HasTrait('Clumsy') then
        noiseModifier = noiseModifier + 5;
    elseif player:HasTrait('Graceful') then
        noiseModifier = noiseModifier - 5;
    end
    return noiseModifier;
end

-- ------------------------------------------------
-- Public Functions
-- ------------------------------------------------

---
-- The condition which tells the timed action if it
-- is still valid.
--
function TABreakWindowLock:isValid()
    return self.character:getPrimaryHandItem():getName() ==  Translator.getDisplayItemName("Crowbar");
end

---
-- Stops the Timed Action.
--
function TABreakWindowLock:stop()
    luautils.equipItems(self.character, self.storedPrim);
    ISBaseTimedAction.stop(self);
end

---
-- Is called when the time has passed.
--
function TABreakWindowLock:perform()
    local window = self.object;
    local player = self.character;
    local weapon = player:getPrimaryHandItem();
    local chance = calculateChance(player);
    local noiseModifier = calculateNoiseModifier(player);

    if ZombRand(chance) == 0 then
        -- We store the original door damage in a temporary variable.
        -- Then we set it to a high level to make sure the window is smashed.
        -- Finally we reset it to its original value.
        local temp = weapon:getDoorDamage();
        weapon:setDoorDamage(100);
        window:WeaponHit(player, weapon);
        weapon:setDoorDamage(temp);

        -- Add sound to the world so zombies get attracted.
        addSound(window, window:getSquare():getX(), window:getSquare():getY(), window:getSquare():getZ(), NOISE_FAILURE + noiseModifier, 20);
    else
        -- Play custom mod-sound.
        getSoundManager():PlayWorldSound("FMJ_forceWindow2", false, window:getSquare(), 0, 15, 20, true);
        addSound(window, window:getSquare():getX(), window:getSquare():getY(), window:getSquare():getZ(), NOISE_SUCCESS + noiseModifier, 20);

        -- Unlock window & open it.
        window:setIsLocked(false);
        window:ToggleWindow(player);

        -- Make window unusable.
        window:setPermaLocked(true);
    end

    -- Add exhaustion to the character when he breaks a lock and damage his weapons.
    player:getStats():setEndurance(player:getStats():getEndurance() + 0.7);
    luautils.weaponLowerCondition(weapon, player, false);

    -- Re-equip the previous items after completing the action.
     luautils.equipItems(self.character, self.storedPrim, self.storedScnd);

    -- Remove Timed Action from stack.
    ISBaseTimedAction.perform(self);
end

---
-- Constructor
--
function TABreakWindowLock:new(player, window, time, storePrim)
    local o = {};
    setmetatable(o, self);
    self.__index = self;
    o.character = player;
    o.object = window;
    o.storedPrim = storePrim;
    o.stopOnWalk = true;
    o.stopOnRun = true;
    o.maxTime = time;
    return o;
end
