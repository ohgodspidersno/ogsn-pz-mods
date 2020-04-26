-- Based on the fantastic "Maek One Page Readable" mod by RH4DB4
-- https://steamcommunity.com/sharedfiles/filedetails/?id=1928908192&searchtext=read+one+page
-- TimedActions\ISReadABook.lua
local originalISReadABookUpdate = ISReadABook.update

function ISReadABook:update(...)
	if self.item:getNumberOfPages() > 0 and
	SkillBook[self.item:getSkillTrained()] and
	self.item:getLvlSkillTrained() > self.character:getPerkLevel(SkillBook[self.item:getSkillTrained()].perk) + 1 or self.character:HasTrait("Illiterate") then
	-- this hits the requirements to burrow down into the 'i can't read this' block
			self.pageTimer = 0;
			local txtRandom = ZombRand(3);
			if txtRandom == 0 then
					self.character:Say(getText("IGUI_PlayerText_FlaggedBook1"));
			elseif txtRandom == 1 then
					self.character:Say(getText("IGUI_PlayerText_FlaggedBook2"));
			else
					self.character:Say(getText("IGUI_PlayerText_FlaggedBook3"));
			end
			if self.item:getNumberOfPages() > 0 then
					self.character:setAlreadyReadPages(self.item:getFullType(), 1)
					self:forceStop()
			end
	else
		return originalISReadABookUpdate(self, ...)
	end
end
