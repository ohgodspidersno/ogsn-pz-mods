-- Based on the fantastic "Maek One Page Readable" mod by RH4DB4
-- https://steamcommunity.com/sharedfiles/filedetails/?id=1928908192&searchtext=read+one+page

-- TimedActions\ISReadABook.lua
local originalISReadABookUpdate = ISReadABook.update
function ISReadABook:update(...)
	if SkillBook[self.item:getSkillTrained()]
	and self.item:getLvlSkillTrained() > (self.character:getPerkLevel(SkillBook[self.item:getSkillTrained()].perk) + 1)
	and self.item:getNumberOfPages() > 0 then
		local characterMetaTable = getmetatable(self.character)
		local originalSetAlreadyReadPages = characterMetaTable.__index.setAlreadyReadPages
		characterMetaTable.__index.setAlreadyReadPages = function(character, fullType, value, ...)
			if self.pageTimer == 0 and value == 0 then
					value = 1
			end
			return originalSetAlreadyReadPages(character, fullType, value, ...)
		end
		local result = originalISReadABookUpdate(self, ...)
		characterMetaTable.__index.setAlreadyReadPages = originalSetAlreadyReadPages
		return result
	end
	return originalISReadABookUpdate(self, ...)
end
