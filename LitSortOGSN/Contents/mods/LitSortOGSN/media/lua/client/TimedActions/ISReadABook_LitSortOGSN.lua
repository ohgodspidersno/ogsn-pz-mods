function ISReadABook:start()
    if __APROPRIATE___ then
      self.item:setJobType(getText("ContextMenu_Read") ..' '.. self.item:getName());
    elseif __TOO_ADVANCED___
      self.item:setJobType(getText("ContextMenu_DogEar") ..' '.. self.item:getName());
    end
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
