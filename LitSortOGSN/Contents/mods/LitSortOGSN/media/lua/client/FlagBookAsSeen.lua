require "TimedActions/ISBaseTimedAction"

ISFlagABookAsSeen = ISBaseTimedAction:derive("ISFlagABookAsSeen");

function ISFlagABookAsSeen:isValid()
  -- player must have it, it must be a real valid book, and it must be totally unread
  return self.character:getInventory():contains(self.item)
      and self.item:getNumberOfPages() > 0
      and self.item:getAlreadyReadPages() < 1
      and not self.character:HasTrait("Illiterate")
end

function ISFlagABookAsSeen:start()
  self.item:setJobType(getText("ContextMenu_FlagBook") ..' '.. self.item:getName());
  self.item:setJobDelta(0.0);
  -- self.startTimeHours = getGameTime():getTimeOfDay()
  self:setAnimVariable("ReadType", "book")
  self:setActionAnim(CharacterActionAnims.Read);
  self:setOverrideHandModels(nil, self.item);
  -- self.character:setReading(true) -- not sure if I want or need this...
end

function ISFlagABookAsSeen:stop()
  if self.item:getNumberOfPages() > 0 then -- check if valid

    if self.item:getAlreadyReadPages() > 1 then
      -- if they've somehow read more than 1 page, don't do anything
      print('player had already read some of it. how did they get here?')
    else
      -- otherwise, immediately set the number of read pages to 1
      self.item:setAlreadyReadPages(1)
    end
    -- then stop the action
    self.item:setJobDelta(0.0);
    ISBaseTimedAction.stop(self);
  end
end

function ISFlagABookAsSeen:update()
	self.item:setJobDelta(self:getJobDelta());
end

function ISFlagABookAsSeen:perform()
  ISBaseTimedAction.perform(self);
end
end
