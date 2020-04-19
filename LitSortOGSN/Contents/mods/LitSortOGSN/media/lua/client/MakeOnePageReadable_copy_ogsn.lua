-- Based on the fantastic "Maek One Page Readable" mod by RH4DB4
-- https://steamcommunity.com/sharedfiles/filedetails/?id=1928908192&searchtext=read+one+page
-- TimedActions\ISReadABook.lua
local originalISReadABookUpdate = ISReadABook.update

function ISReadABook:update(...)
	if self.item:getNumberOfPages() > 0 and SkillBook[self.item:getSkillTrained()] then  -- it's a valid skillbook
				if self.item:getAlreadyReadPages() == 0 then	-- if the player hasn't read it yet at all...
						self.character:setAlreadyReadPages(self.item:getFullType(), 1)	-- ... they get the first page for free
				end
				if self.item:getLvlSkillTrained() > self.character:getPerkLevel(SkillBook[self.item:getSkillTrained()].perk) + 1 or self.character:HasTrait("Illiterate") then
				-- this if statement hits the requirements to burrow down into the 'i can't read this' block, so we can replace it
				-- it's basically the same except I've removed the changes that already happened up to this point
						self.pageTimer = 0;
						if txtRandom == 0 then
								self.character:Say(getText("IGUI_PlayerText_DontGet"));
						elseif txtRandom == 1 then
								self.character:Say(getText("IGUI_PlayerText_TooComplicated"));
						else
								self.character:Say(getText("IGUI_PlayerText_DontUnderstand"));
						end
						self:forceStop()
				else
					-- if they can read it, use the original function
					return originalISReadABookUpdate(self, ...)
				end
	end
	return originalISReadABookUpdate(self, ...) -- it'll probably never get here but just in case, throw it back to the original
end

--
--
-- function ISReadABook:update(...)
-- 			if SkillBook[self.item:getSkillTrained()] and self.item:getLvlSkillTrained() > (self.character:getPerkLevel(SkillBook[self.item:getSkillTrained()].perk) + 1) and self.item:getNumberOfPages() > 0 then
-- 						local characterMetaTable = getmetatable(self.character)
-- 						local originalSetAlreadyReadPages = characterMetaTable.__index.setAlreadyReadPages
-- 						characterMetaTable.__index.setAlreadyReadPages = function(character, fullType, value, ...)
-- 									if value == 0 then -- if self.pageTimer == 0 and value == 0 then
-- 												value = 1
-- 									end
-- 									return originalSetAlreadyReadPages(character, fullType, value, ...)
-- 						end
-- 						local result = originalISReadABookUpdate(self, ...)
-- 						characterMetaTable.__index.setAlreadyReadPages = originalSetAlreadyReadPages
-- 						return result
-- 			end
-- 			return originalISReadABookUpdate(self, ...)
-- end
