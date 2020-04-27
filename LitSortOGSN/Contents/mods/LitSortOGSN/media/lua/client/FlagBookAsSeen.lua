require "TimedActions/ISBaseTimedAction"

ISFlagABookAsSeen = ISBaseTimedAction:derive("ISFlagABookAsSeen");

function ISFlagABookAsSeen:isValid()
  -- player must have it, it must be a real valid book, and it must be totally unread
  return self.character:getInventory():contains(self.item)
      and self.item:getNumberOfPages() > 0
      and self.item:getAlreadyReadPages() < 1
      and not self.character:HasTrait("Illiterate")
end

function ISReadABook:start()
end
function ISReadABook:stop()
end
