--***********************************************************
--**                    ROBERT JOHNSON                     **
--***********************************************************

require "TimedActions/ISBaseTimedAction"

ISReadABook = ISBaseTimedAction:derive("ISReadABook");


function ISReadABook:isValid()
    local vehicle = self.character:getVehicle()
    if vehicle and vehicle:isDriver(self.character) then
        return not vehicle:isEngineRunning()	
    end
    return self.character:getInventory():contains(self.item) and ((self.item:getNumberOfPages() > 0 and self.item:getAlreadyReadPages() <= self.item:getNumberOfPages()) or self.item:getNumberOfPages() < 0);
end

function ISReadABook:update()
    ISReadABook.pageTimer = ISReadABook.pageTimer + 1;
    self.item:setJobDelta(self:getJobDelta());

    if self.item:getNumberOfPages() > 0 then
        local pagesDifference = self.item:getNumberOfPages() - self.startPage
        local pagesRead = math.floor(pagesDifference * self:getJobDelta())
        self.item:setAlreadyReadPages(self.startPage + pagesRead);
        if self.item:getAlreadyReadPages() > self.item:getNumberOfPages() then
            self.item:setAlreadyReadPages(self.item:getNumberOfPages());
        end
        self.character:setAlreadyReadPages(self.item:getFullType(), self.item:getAlreadyReadPages())
    end
    if SkillBook[self.item:getSkillTrained()] then
        if self.item:getLvlSkillTrained() > self.character:getPerkLevel(SkillBook[self.item:getSkillTrained()].perk) + 1 or self.character:HasTrait("Illiterate") then
            if ISReadABook.pageTimer >= 150 then
                ISReadABook.pageTimer = 0;
                local txtRandom = ZombRand(3);
                if txtRandom == 0 then
                    self.character:Say(getText("IGUI_PlayerText_DontGet"));
                elseif txtRandom == 1 then
                    self.character:Say(getText("IGUI_PlayerText_TooComplicated"));
                else
                    self.character:Say(getText("IGUI_PlayerText_DontUnderstand"));
                end
            end
        elseif self.item:getMaxLevelTrained() < self.character:getPerkLevel(SkillBook[self.item:getSkillTrained()].perk) + 1 then
            if ISReadABook.pageTimer >= 150 then
                ISReadABook.pageTimer = 0;
                local txtRandom = ZombRand(2);
                if txtRandom == 0 then
                    self.character:Say(getText("IGUI_PlayerText_KnowSkill"));
                else
                    self.character:Say(getText("IGUI_PlayerText_BookObsolete"));
                end
            end
        else
            ISReadABook.checkMultiplier(self);
        end
    end

	if self.character:getVehicle() ~= nil and self.character:getVehicle():isEngineRunning() then
		ISBaseTimedAction.stop(self)
	end

end

-- get how much % of the book we already read, then we apply a multiplier depending on the book read progress
ISReadABook.checkMultiplier = function(self)
-- get all our info in the map
    local trainedStuff = SkillBook[self.item:getSkillTrained()];
    if trainedStuff then
        -- every 10% we add 10% of the max multiplier
        local readPercent = (self.item:getAlreadyReadPages() / self.item:getNumberOfPages()) * 100;
        if readPercent > 100 then
            readPercent = 100;
        end
        -- apply the multiplier to the skill
        local multiplier = (math.floor(readPercent/10) * (self.maxMultiplier/10));
        if multiplier > self.character:getXp():getMultiplier(trainedStuff.perk) then
            self.character:getXp():addXpMultiplier(trainedStuff.perk, multiplier, self.item:getLvlSkillTrained(), self.item:getMaxLevelTrained());
        end
    end
end

function ISReadABook:start()
    self.item:setJobType(getText("ContextMenu_Read") ..' '.. self.item:getName());
    self.item:setJobDelta(0.0);
    self.startTimeHours = getGameTime():getTimeOfDay()
    --self.character:SetPerformingAction(GameCharacterActions.Reading, nil, self.item)
    if (self.item:getType() == "Newspaper") then
        self:setAnimVariable("ReadType", "newspaper")
    else
        self:setAnimVariable("ReadType", "book")
    end
    self:setActionAnim(CharacterActionAnims.Read);
    self:setOverrideHandModels(nil, self.item);
    self.character:setReading(true)
end

function ISReadABook:stop()
    ISBaseTimedAction.stop(self);
    if self.item:getNumberOfPages() > 0 and self.item:getAlreadyReadPages() >= self.item:getNumberOfPages() then
        self.item:setAlreadyReadPages(self.item:getNumberOfPages());
    end
    self.character:setReading(false);
    self.item:setJobDelta(0.0);
end

function ISReadABook:perform()
    self.character:setReading(false);
    self.item:getContainer():setDrawDirty(true);
    self.item:setJobDelta(0.0);
    if not SkillBook[self.item:getSkillTrained()] then
        self.character:ReadLiterature(self.item);
    elseif self.item:getAlreadyReadPages() >= self.item:getNumberOfPages() then
--        self.character:ReadLiterature(self.item);
        self.item:setAlreadyReadPages(0);
    end
--    if self.item:getTeachedRecipes() and not self.item:getTeachedRecipes():isEmpty() then
--        for i=0, self.item:getTeachedRecipes():size() - 1 do
--           if not self.character:getKnownRecipes():contains(self.item:getTeachedRecipes():get(i)) then
--               self.character:getKnownRecipes():add(self.item:getTeachedRecipes():get(i));
--           else
--               self.character:Say(getText("IGUI_PlayerText_KnowSkill"));
--           end
--        end
--    end
    -- needed to remove from queue / start next.
    ISBaseTimedAction.perform(self);
end

function ISReadABook:new(character, item, time)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = character;
    o.item = item;
    o.stopOnWalk = true;
    o.stopOnRun = true;
    o.stopOnAim = true;

    -- if the books have pages, the time needed to read it is number of page * 30 (lot of time !)
    if item:getNumberOfPages() > 0 then
        item:setAlreadyReadPages(character:getAlreadyReadPages(item:getFullType()))
        if isClient() then
            o.minutesPerPage = getServerOptions():getFloat("MinutesPerPage") or 1.0
            if o.minutesPerPage < 0.0 then o.minutesPerPage = 1.0 end
        else
            o.minutesPerPage = 2.0
        end
        o.startPage = item:getAlreadyReadPages()
        local f = 1 / getGameTime():getMinutesPerDay() / 2
        time = ((item:getNumberOfPages() - item:getAlreadyReadPages())) * o.minutesPerPage / f
    end

    if(character:HasTrait("FastReader")) then
        time = time * 0.7;
    end
    if(character:HasTrait("SlowReader")) then
        time = time * 1.3;
    end
	if(character:HasTrait("Bookworm")) then
        time = time * 0.3;
    end
	if(character:HasTrait("Bookworm")) then
	    o.stopOnWalk = false;
    end

    if SkillBook[item:getSkillTrained()] then
        if item:getLvlSkillTrained() == 1 then
            o.maxMultiplier = SkillBook[item:getSkillTrained()].maxMultiplier1;
        elseif item:getLvlSkillTrained() == 3 then
            o.maxMultiplier = SkillBook[item:getSkillTrained()].maxMultiplier2;
        elseif item:getLvlSkillTrained() == 5 then
            o.maxMultiplier = SkillBook[item:getSkillTrained()].maxMultiplier3;
        elseif item:getLvlSkillTrained() == 7 then
            o.maxMultiplier = SkillBook[item:getSkillTrained()].maxMultiplier4;
        elseif item:getLvlSkillTrained() == 9 then
            o.maxMultiplier = SkillBook[item:getSkillTrained()].maxMultiplier5;
        else
            o.maxMultiplier = 1
            print('ERROR: book has unhandled skill level ' .. item:getLvlSkillTrained())
        end
    end
    ISReadABook.pageTimer = 0;
    o.ignoreHandsWounds = true;
    o.maxTime = time;
    o.caloriesModifier = 0.5;
    if character:getAccessLevel() ~= "None" then
        o.maxTime = 1;
    end

    return o;
end
