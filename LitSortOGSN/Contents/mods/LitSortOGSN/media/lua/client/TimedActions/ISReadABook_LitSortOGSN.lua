local original_ISReadABookStart = ISReadABook.start

function ISReadABook:start(...)
    if item:getNumberOfPages() <= 0 then
        return
    end
    local skillBook = SkillBook[item:getSkillTrained()]
    local level = character:getPerkLevel(skillBook.perk)
    local appropriate = true
    if (item:getLvlSkillTrained() > level + 1) then
      appropriate = false
    end
    if appropriate then
      return original_ISReadABookStart(self, ...)
    else
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
