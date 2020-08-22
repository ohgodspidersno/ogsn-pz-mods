require "ISUI/ISPanelJoypad"

ISHealthPanel = ISPanelJoypad:derive("ISHealthPanel");


--************************************************************************--
--** ISPanel:initialise
--**
--************************************************************************--

ISHealthPanel.cheat = false;

function ISHealthPanel:initialise()
  ISPanelJoypad.initialise(self);
end

function ISHealthPanel:createChildren()
  self.listbox = ISScrollingListBox:new(180 - 15, 59, self.width - (180 - 15), self.height);
  self.listbox:initialise();
  self.listbox:instantiate();
  self.listbox:setAnchorLeft(true);
  self.listbox:setAnchorRight(true);
  self.listbox:setAnchorTop(true);
  self.listbox:setAnchorBottom(false);
  self.listbox.itemheight = 128;
  self.listbox.drawBorder = false
  self.listbox.backgroundColor.a = 0
  self.listbox.doDrawItem = ISHealthPanel.doDrawItem;
  self.listbox.onRightMouseUp = ISHealthPanel.onBodyPartListRightMouseUp
  self:addChild(self.listbox)
end

function ISHealthPanel:setVisible(visible)
  --    self.parent:setVisible(visible);
  --    self.doctorLevel = self.character:getPerkLevel(Perks.Doctor);
  self.otherPlayer = nil;
  self.javaObject:setVisible(visible);
  ISHealthPanel.cheat = self.character:getAccessLevel() ~= "None";
end

function ISHealthPanel:onBodyPartListRightMouseUp(x, y)
  local row = self:rowAt(x, y)
  if row < 1 or row > #self.items then return end
  self.selected = row
  local healthPanel = self.parent
  healthPanel:doBodyPartContextMenu(self.items[row].item.bodyPart, self:getX() + x, self:getY() + y)
end

function ISHealthPanel:toPlayerInventory(playerObj, item, bodyPart)
  if item:getContainer() ~= playerObj:getInventory() then
    local action = ISInventoryTransferAction:new(playerObj, item, item:getContainer(), playerObj:getInventory())
    ISTimedActionQueue.add(action)
    -- FIXME: ISHealthPanel.actions never gets cleared
    self.actions = self.actions or {}
    self.actions[action] = bodyPart
  end
end

ISHealthPanel.onCheat = function(bodyPart, action, player, otherPlayer)
  if action == "bleeding" then
    bodyPart:setBleedingTime((bodyPart:getBleedingTime() > 0) and 0 or 10)
  end
  if action == "bullet" then
    if bodyPart:haveBullet() then
      local deepWound = bodyPart:isDeepWounded()
      local deepWoundTime = bodyPart:getDeepWoundTime()
      local bleedTime = bodyPart:getBleedingTime()
      bodyPart:setHaveBullet(false, 0)
      bodyPart:setDeepWoundTime(deepWoundTime)
      bodyPart:setDeepWounded(deepWound)
      bodyPart:setBleedingTime(bleedTime)
    else
      bodyPart:setHaveBullet(true, 0)
    end
  end
  if action == "burned" then
    if bodyPart:getBurnTime() > 0 then
      bodyPart:setBurnTime(0)
    else
      bodyPart:setBurnTime(50)
    end
  end
  if action == "burnWash" then
    if bodyPart:getBurnTime() > 0 then
      bodyPart:setNeedBurnWash(not bodyPart:isNeedBurnWash())
    end
  end
  if action == "deepWound" then
    if bodyPart:getDeepWoundTime() > 0 then
      bodyPart:setDeepWoundTime(0)
      bodyPart:setDeepWounded(false)
    else
      bodyPart:setDeepWoundTime(10)
      bodyPart:setDeepWounded(true)
    end
  end
  if action == "fracture" then
    if bodyPart:getFractureTime() > 0 then
      bodyPart:setFractureTime(0)
    else
      bodyPart:setFractureTime(21)
    end
  end
  if action == "healthFull" then
    local bodyParts = player:getBodyDamage():getBodyParts()
    for i = 1, bodyParts:size() do
      local bodyPart = bodyParts:get(i - 1)
      bodyPart:SetHealth(100)
    end
  end
  if action == "glass" then
    bodyPart:setHaveGlass(not bodyPart:haveGlass())
  end
  if action == "infected" then
    if bodyPart:isInfectedWound() then
      bodyPart:setWoundInfectionLevel(-1)
    else
      bodyPart:setWoundInfectionLevel(10)
    end
  end
  if action == "scratched" then
    if bodyPart:getScratchTime() > 0 then
      bodyPart:setScratched(false)
      bodyPart:setScratchTime(0)
    else
      local bleedTime = bodyPart:getBleedingTime()
      local infected = bodyPart:IsInfected() -- zombie virus
      bodyPart:setScratched(true)
      bodyPart:setBleedingTime(bleedTime)
      bodyPart:SetInfected(infected) -- zombie virus
    end
  end
end

ISHealthPanel.onCheatItem = function(itemType, playerObj)
  playerObj:getInventory():AddItem(itemType)
end

function ISHealthPanel:update()
  ISPanelJoypad.update(self)
  if self.otherPlayer then
    -- ISCollapsableWindow:close() just hides the window
    if not self.parent:getIsVisible() then
      self.parent:removeFromUIManager()
      if self.joyfocus then self.joyfocus.focus = nil end
      self:getDoctor():stopReceivingBodyDamageUpdates(self:getPatient())
      return
    end
    if self:getDoctor():getAccessLevel() == "None" and (math.abs(self.otherPlayer:getX() - self.otherPlayerX) > 0.5 or
      math.abs(self.otherPlayer:getY() - self.otherPlayerY) > 0.5 or
      math.abs(self.character:getX() - self.characterX) > 0.5 or
    math.abs(self.character:getY() - self.characterY) > 0.5) then
      self.parent:removeFromUIManager()
      if self.joyfocus then self.joyfocus.focus = nil end
      self:getDoctor():stopReceivingBodyDamageUpdates(self:getPatient())
      return
    end
  end
  if self:getIsVisible() then
    self:updateBodyPartList()
    self:setWidthAndParentWidth(self.healthPanel:getWidth() + 100);
    ISHealthPanel.padBottom = ISHealthPanel.padBottom or 30
    self:setHeightAndParentHeight(math.max(self.healthPanel:getHeight(), self.allTextHeight or 0) + ISHealthPanel.padBottom);
    self.healthPanel:setX(self:getAbsoluteX());
    self.healthPanel:setY(self:getAbsoluteY() + 8);
  end
end

function ISHealthPanel:render()

  self.healthPanel:render();

  local y = 59;
  local x = 180;
  local fontHgt = getTextManager():getFontFromEnum(UIFont.Small):getLineHeight()
  local fgBar = {r = 0.5, g = 0.5, b = 0.5, a = 0.5}

  local doctor = self.otherPlayer or self.character

  if doctor:getJoypadBind() ~= -1 then
    self:drawTextureScaled(self.abutton, x - 15, 2, fontHgt, fontHgt, 1.0, 1.0, 1.0, 1.0);
    self:drawText(getText("IGUI_health_JoypadTreatment"), x - 15 + fontHgt + 2, 2, 1, 1, 1, 1, UIFont.Small);
  else
    self:drawText(getText("IGUI_health_RightClickTreatement"), x - 15, 2, 1, 1, 1, 1, UIFont.Small);
  end

  -- for each damaged body part, we gonna display the body part name + the damage type
  local painLevel = self:getPatient():getMoodles():getMoodleLevel(MoodleType.Pain)
  if isClient() and not self:getPatient():isLocalPlayer() then
    painLevel = self.character:getBodyDamageRemote():getRemotePainLevel()
  end
  if (self.doctorLevel > 4 or self.character == getPlayer() or ISHealthPanel.cheat) and painLevel > 0 then
    self:drawText(getText("Moodles_pain_lvl" .. painLevel), x - 15, y, 1, 1, 1, 1, UIFont.Small);
  end
  y = y + fontHgt;
  if self.cheat and self.character:getBodyDamage():getFakeInfectionLevel() > 0 then
    self:drawText("Fake infection level " .. self.character:getBodyDamage():getFakeInfectionLevel(), x - 15, y, 1, 1, 1, 1, UIFont.Small);
    y = y + fontHgt;
  end
  if self.cheat and self.character:getReduceInfectionPower() > 0 then
    self:drawText("Antibiotic level " .. self.character:getReduceInfectionPower(), x - 15, y, 1, 1, 1, 1, UIFont.Small);
    y = y + fontHgt;
  end

  local listItemsHeight = self.listbox:getScrollHeight()
  local myHeight = y + listItemsHeight + ISHealthPanel.padBottom
  local myY = self:getY()
  local parent = self.parent
  while parent and parent.parent do
    myY = myY + parent:getY()
    parent = parent.parent
  end
  if myY + myHeight > getCore():getScreenHeight() then
    myHeight = getCore():getScreenHeight() - myY
  end
  self.listbox:setY(y)
  self.listbox:setHeight(myHeight - y)
  self.listbox.vscroll:setHeight(self.listbox:getHeight())
  self.allTextHeight = myHeight - ISHealthPanel.padBottom
end

function ISHealthPanel:getDoctor()
  return self.otherPlayer or self.character
end

function ISHealthPanel:getPatient()
  return self.character
end

function ISHealthPanel:getDamagedParts()
  local result = {}
  local bodyParts = self:getPatient():getBodyDamage():getBodyParts()
  if isClient() and not self:getPatient():isLocalPlayer() then
    bodyParts = self:getPatient():getBodyDamageRemote():getBodyParts()
  end
  for i = 1, bodyParts:size() do
    local bodyPart = bodyParts:get(i - 1)
    local bodyPartAction = self.bodyPartAction and self.bodyPartAction[bodyPart]
    if ISHealthPanel.cheat or bodyPart:HasInjury() or bodyPart:bandaged() or bodyPart:stitched() or bodyPart:getSplintFactor() > 0 then
      table.insert(result, bodyPart)
    end
  end
  return result
end

function ISHealthPanel:updateBodyPartList()
  -- These aid in reloading the .lua when debugging
  self.listbox.doDrawItem = self.doDrawItem
  self.listbox.onRightMouseUp = ISHealthPanel.onBodyPartListRightMouseUp

  local damagedParts = self:getDamagedParts()
  local changed = false
  if #damagedParts == #self.damagedParts then
    for i = 1, #damagedParts do
      if damagedParts[i] ~= self.damagedParts[i] then
        changed = true
        break
      end
    end
  else
    changed = true
  end
  if not changed then
    return
  end

  self.listbox:clear()
  for i = 1, #damagedParts do
    local bodyPart = damagedParts[i]
    local data = {}
    data.bodyPart = bodyPart
    self.listbox:addItem('dummy', data)
  end
  self.damagedParts = damagedParts
end

function ISHealthPanel:doDrawItem(y, item, alt)
  local healthPanel = self.parent
  local bodyPart = item.item.bodyPart;
  local bodyPartAction = healthPanel.bodyPartAction and healthPanel.bodyPartAction[bodyPart]
  local x = 15;
  local fontHgt = getTextManager():getFontFromEnum(UIFont.Small):getLineHeight()
  local fgBar = {r = 0.5, g = 0.5, b = 0.5, a = 0.5}
  if item.itemindex == self.selected then
    self:drawRect(0, y, self:getWidth(), item.height, 0.1, 1.0, 1.0, 1.0);
  elseif item.itemindex == self.mouseoverselected then
    self:drawRect(0, y, self:getWidth(), item.height, 0.05, 1.0, 1.0, 1.0);
  end
  if ISHealthPanel.cheat then
    self:drawText(BodyPartType.getDisplayName(bodyPart:getType()) .. " (health=" .. round(bodyPart:getHealth(), 4) .. ")", x - 15, y, 1, 1, 1, 1, UIFont.Small);
  else
    self:drawText(BodyPartType.getDisplayName(bodyPart:getType()), x - 15, y, 1, 1, 1, 1, UIFont.Small);
  end
  y = y + fontHgt;
  if bodyPartAction then
    self:drawProgressBar(x, y, self.width - 10 - x, fontHgt, bodyPartAction.delta, fgBar)
    self:drawText(bodyPartAction.jobType, x + 4, y, 0.8, 0.8, 0.8, 1, UIFont.Small)
    y = y + fontHgt
  else
    local actionQueue = ISTimedActionQueue.getTimedActionQueue(healthPanel.otherPlayer or healthPanel.character);
    if actionQueue and actionQueue.queue and healthPanel.actions and healthPanel.actions[actionQueue.queue[1]] == bodyPart then
      self:drawProgressBar(x, y, self.width - 10 - x, fontHgt, actionQueue.queue[1]:getJobDelta(), fgBar);
      self:drawText(actionQueue.queue[1].jobType, x + 4, y, 0.8, 0.8, 0.8, 1, UIFont.Small); -- jobType is a hack for CraftingUI as well
      y = y + fontHgt
    end
  end
  if bodyPart:getPlantainFactor() > 0 then
    self:drawText("- " .. getText("ContextMenu_PlantainCataplasm"), x, y, 0.28, 0.89, 0.28, 1, UIFont.Small);
    y = y + fontHgt;
    if ISHealthPanel.cheat then
      self:drawText("     - factor " .. round(bodyPart:getPlantainFactor(), 2), x, y, 0.89, 0.28, 0.28, 1, UIFont.Small);
      y = y + fontHgt;
    end
  end
  if bodyPart:getComfreyFactor() > 0 then
    self:drawText("- " .. getText("ContextMenu_ComfreyCataplasm"), x, y, 0.28, 0.89, 0.28, 1, UIFont.Small);
    y = y + fontHgt;
    if ISHealthPanel.cheat then
      self:drawText("     - factor " .. round(bodyPart:getComfreyFactor(), 2), x, y, 0.89, 0.28, 0.28, 1, UIFont.Small);
      y = y + fontHgt;
    end
  end
  if bodyPart:getGarlicFactor() > 0 then
    self:drawText("- " .. getText("ContextMenu_GarlicCataplasm"), x, y, 0.28, 0.89, 0.28, 1, UIFont.Small);
    y = y + fontHgt;
    if ISHealthPanel.cheat then
      self:drawText("     - factor " .. round(bodyPart:getGarlicFactor(), 2), x, y, 0.89, 0.28, 0.28, 1, UIFont.Small);
      y = y + fontHgt;
    end
  end
  if bodyPart:scratched() then
    local text = "";
    if healthPanel.doctorLevel > 2 or ISHealthPanel.cheat then -- a doctor will evaluate the wound
      if bodyPart:getScratchTime() > 17 then
        text = " (" .. getText("IGUI_health_Severe") ..")";
      elseif bodyPart:getScratchTime() > 14 then
        text = " (" .. getText("IGUI_health_Moderate") ..")";
      end
    end
    self:drawText("- " .. getText("IGUI_health_Scratched") .. text, x, y, 0.89, 0.28, 0.28, 1, UIFont.Small);
    y = y + fontHgt;
    if ISHealthPanel.cheat then
      if(bodyPart:getScratchTime() > 0) then
        self:drawText("     - scratch Time " .. round(bodyPart:getScratchTime(), 2), x, y, 0.89, 0.28, 0.28, 1, UIFont.Small);
        y = y + fontHgt;
      end
    end
  end
  if bodyPart:deepWounded() then
    local text = "";
    if healthPanel.doctorLevel > 4 or ISHealthPanel.cheat then -- a doctor will evaluate the wound
      if bodyPart:getDeepWoundTime() > 10 then
        text = " (" .. getText("IGUI_health_Severe") ..")";
      elseif bodyPart:getDeepWoundTime() > 8 then
        text = " (" .. getText("IGUI_health_Moderate") ..")";
      end
    end
    self:drawText("- " .. getText("IGUI_health_DeepWound") .. " " .. text, x, y, 0.89, 0.28, 0.28, 1, UIFont.Small);
    y = y + fontHgt;
    if ISHealthPanel.cheat then
      self:drawText("     - deepWound Time " .. round(bodyPart:getDeepWoundTime(), 2), x, y, 0.89, 0.28, 0.28, 1, UIFont.Small);
      y = y + fontHgt;
    end
  end
  if bodyPart:bitten() then
    self:drawText("- " .. getText("IGUI_health_Bitten"), x, y, 0.89, 0.28, 0.28, 1, UIFont.Small);
    y = y + fontHgt;
    if ISHealthPanel.cheat then
      self:drawText("     - bite Time " .. round(bodyPart:getBiteTime(), 2), x, y, 0.89, 0.28, 0.28, 1, UIFont.Small);
      y = y + fontHgt;
    end
  end
  if bodyPart:bleeding() then
    self:drawText("- " .. getText("IGUI_health_Bleeding"), x, y, 0.89, 0.28, 0.28, 1, UIFont.Small);
    y = y + fontHgt;
    if ISHealthPanel.cheat then
      self:drawText("     - bleeding Time " .. round(bodyPart:getBleedingTime(), 2), x, y, 0.89, 0.28, 0.28, 1, UIFont.Small);
      y = y + fontHgt;
    end
  end
  if bodyPart:getFractureTime() > 0 and bodyPart:getSplintFactor() == 0 then
    local text = "";
    if healthPanel.doctorLevel > 6 or ISHealthPanel.cheat then -- a doctor will evaluate the wound
      if bodyPart:getFractureTime() > 50 then
        text = " (" .. getText("IGUI_health_Severe") ..")";
      elseif bodyPart:getFractureTime() > 20 then
        text = " (" .. getText("IGUI_health_Moderate") ..")";
      end
    end
    self:drawText("- " .. getText("IGUI_health_Fracture") .. " " .. text, x, y, 0.89, 0.28, 0.28, 1, UIFont.Small);
    y = y + fontHgt;
    if ISHealthPanel.cheat then
      self:drawText("     - fracture Time " .. round(bodyPart:getFractureTime(), 2), x, y, 0.89, 0.28, 0.28, 1, UIFont.Small);
      y = y + fontHgt;
    end
  end
  if bodyPart:getSplintFactor() > 0 then
    local text = "";
    if healthPanel.doctorLevel > 4 or ISHealthPanel.cheat then -- a doctor will evaluate the wound
      if bodyPart:getSplintFactor() > 4 then
        text = " (" .. getText("IGUI_health_Good") ..")";
      elseif bodyPart:getFractureTime() > 2 then
        text = " (" .. getText("IGUI_health_Moderate") ..")";
      end
    end
    self:drawText("- " .. getText("IGUI_health_Splinted") .. " " .. text, x, y, 0.28, 0.89, 0.28, 1, UIFont.Small);
    y = y + fontHgt;
    if ISHealthPanel.cheat then
      self:drawText("     - splint Factor " .. round(bodyPart:getSplintFactor(), 2), x, y, 0.89, 0.28, 0.28, 1, UIFont.Small);
      y = y + fontHgt;
    end
  end
  if bodyPart:bandaged() then
    if bodyPart:getBandageLife() > 0 then
      self:drawText("- " .. getText("IGUI_health_Bandaged"), x, y, 0.28, 0.89, 0.28, 1, UIFont.Small);
    else
      self:drawText("- " .. getText("IGUI_health_DirtyBandage"), x, y, 1, 0.28, 0, 1, UIFont.Small);
    end
    y = y + fontHgt;
    if ISHealthPanel.cheat then
      if(bodyPart:getBandageLife() > 0) then
        self:drawText("     - Bandage Life " .. round(bodyPart:getBandageLife(), 4), x, y, 0.28, 0.89, 0.28, 1, UIFont.Small);
        y = y + fontHgt;
      end
      if(bodyPart:getBleedingTime() > 0) then
        self:drawText("     - bleeding Time " .. round(bodyPart:getBleedingTime(), 4), x, y, 0.28, 0.89, 0.28, 1, UIFont.Small);
        y = y + fontHgt;
      end
      if(bodyPart:getScratchTime() > 0) then
        self:drawText("     - scratch Time " .. round(bodyPart:getScratchTime(), 4), x, y, 0.28, 0.89, 0.28, 1, UIFont.Small);
        y = y + fontHgt;
      end
      if(bodyPart:getDeepWoundTime() > 0) then
        self:drawText("     - deep-wound Time " .. round(bodyPart:getDeepWoundTime(), 4), x, y, 0.28, 0.89, 0.28, 1, UIFont.Small);
        y = y + fontHgt;
      end
    end
  end
  if bodyPart:isInfectedWound() and not bodyPart:bandaged() then
    if healthPanel.doctorLevel > 8 or (bodyPart:getWoundInfectionLevel() * 10 >= (2.5 - healthPanel.doctorLevel)) or ISHealthPanel.cheat then -- only a good doctor will know fast if a wound is infected or not
      self:drawText("- " .. getText("IGUI_health_Infected"), x, y, 1, 0.28, 0, 1, UIFont.Small);
      y = y + fontHgt;
      if ISHealthPanel.cheat then
        self:drawText("     - infection Time " .. round(bodyPart:getWoundInfectionLevel(), 4), x, y, 1, 0.28, 0, 1, UIFont.Small);
        y = y + fontHgt;
      end
    end
  end
  if bodyPart:haveBullet() and not bodyPart:bandaged() then
    self:drawText("- " .. getText("IGUI_health_LodgedBullet"), x, y, 0.89, 0.28, 0.28, 1, UIFont.Small);
    y = y + fontHgt;
  end
  if bodyPart:getBurnTime() > 0 and not bodyPart:bandaged() then
    local burnText = "";
    if (healthPanel.doctorLevel > 4 or ISHealthPanel.cheat) and bodyPart:isNeedBurnWash() then
      burnText = " (" .. getText("IGUI_health_NeedCleaning") ..")";
    end
    self:drawText("- " .. getText("IGUI_health_Burned") .. burnText, x, y, 0.89, 0.28, 0.28, 1, UIFont.Small);
    y = y + fontHgt;
    if ISHealthPanel.cheat then
      self:drawText("     - burn Time " .. round(bodyPart:getBurnTime(), 4) .. "(" .. bodyPart:getLastTimeBurnWash() .. ")", x, y, 1, 0.28, 0, 1, UIFont.Small);
      y = y + fontHgt;
    end
  end
  if bodyPart:stitched() then
    local text = "";
    if healthPanel.doctorLevel > 6 or ISHealthPanel.cheat then -- show if the stitch can be removed
      if bodyPart:getStitchTime() > 40 then
        text = " (" .. getText("IGUI_health_Good") ..")";
      else
        text = " (" .. getText("IGUI_health_NeedTime") ..")";
      end
    end
    self:drawText("- " .. getText("IGUI_health_Stitched") ..text, x, y, 0.28, 0.89, 0.28, 1, UIFont.Small);
    y = y + fontHgt;
    if ISHealthPanel.cheat then
      self:drawText("     - stitch Time " .. round(bodyPart:getStitchTime(), 4), x, y, 0.28, 0.89, 0.28, 1, UIFont.Small);
      y = y + fontHgt;
    end
  end
  if bodyPart:haveGlass() and not bodyPart:bandaged() then
    self:drawText("- " .. getText("IGUI_health_LodgedGlassShards"), x, y, 0.89, 0.28, 0.28, 1, UIFont.Small);
    y = y + fontHgt;
  end
  y = y + 5;
  return y;
end

function ISHealthPanel.setBodyPartActionForPlayer(playerObj, bodyPart, action, jobType, args)
  if not playerObj or playerObj:isDead() then return end
  if args then
    args.jobType = jobType
    args.delta = action:getJobDelta()
  end
  if playerObj:isLocalPlayer() then
    local infoPanel = getPlayerInfoPanel(playerObj:getPlayerNum())
    if infoPanel then
      infoPanel.healthView:setBodyPartAction(bodyPart, args)
    end
  end
  -- Handle coop and remote players
  local window = ISMedicalCheckAction.getHealthWindowForPlayer(playerObj)
  if window then
    window.nested:setBodyPartAction(bodyPart, args)
  end
end

function ISHealthPanel:setBodyPartAction(bodyPart, args)
  self.bodyPartAction = self.bodyPartAction or {}
  self.bodyPartAction[bodyPart] = args
end

function ISHealthPanel:setOtherPlayer(playerObj)
  self.characterX = self.character:getX()
  self.characterY = self.character:getY()

  self.otherPlayer = playerObj
  self.otherPlayerX = playerObj:getX()
  self.otherPlayerY = playerObj:getY()
end

function ISHealthPanel:onGainJoypadFocus(joypadData)
  ISPanel.onGainJoypadFocus(self, joypadData)
  if self.otherPlayer then
    self.parent.drawJoypadFocus = true
  end
end

function ISHealthPanel:onLoseJoypadFocus(joypadData)
  ISPanel.onLoseJoypadFocus(self, joypadData)
  if self.otherPlayer then
    self.parent.drawJoypadFocus = false
  end
end

function ISHealthPanel:onJoypadDown(button)
  if self.otherPlayer then
    if button == Joypad.BButton then
      self.parent:removeFromUIManager()
      setJoypadFocus(self.joyfocus.player, nil)
      self:getDoctor():stopReceivingBodyDamageUpdates(self:getPatient())
    end
    if button == Joypad.AButton then
      local listItem = self.listbox.items[self.listbox.selected]
      if listItem then
        self:doBodyPartContextMenu(listItem.item.bodyPart, 50, 50)
      end
    end
    return
  end
  if button == Joypad.BButton then
    getPlayerInfoPanel(self.playerNum):toggleView(xpSystemText.health)
    setJoypadFocus(self.playerNum, nil)
  end
  if button == Joypad.LBumper then
    getPlayerInfoPanel(self.playerNum):onJoypadDown(button)
  end
  if button == Joypad.RBumper then
    getPlayerInfoPanel(self.playerNum):onJoypadDown(button)
  end
  if button == Joypad.AButton then
    local listItem = self.listbox.items[self.listbox.selected]
    if listItem then
      self:doBodyPartContextMenu(listItem.item.bodyPart, 50, 50)
    end
  end
end

function ISHealthPanel:onJoypadDirUp()
  self.listbox:onJoypadDirUp()
end

function ISHealthPanel:onJoypadDirDown()
  self.listbox:onJoypadDirDown()
end

function ISHealthPanel:new (player, x, y, width, height)
  local o = {};
  o = ISPanelJoypad:new(x, y, width, height);
  setmetatable(o, self);
  self.__index = self;
  o.otherPlayer = nil;
  o.progressBarLoaded = false;
  o.character = player;
  o.playerNum = player:getPlayerNum()
  o.healthPanel = NewHealthPanel.new(20, 20, o.character);
  o.healthPanel:setVisible(true);
  o.doctorLevel = player:getPerkLevel(Perks.Doctor);
  o:noBackground();
  o.abutton = getTexture("media/ui/abutton.png")
  o.damagedParts = {}
  ISHealthPanel.instance = o;
  return o;
end

-----

HealthPanelAction = ISBaseTimedAction:derive("HealthPanelAction")

function HealthPanelAction:isValid()
  local valid = self.handler:isValid(self.args[1], self.args[2], self.args[3], self.args[4], self.args[5], self.args[6], self.args[7], self.args[8])
  --    print(self.handler.Type .. "["..tostring(self.handler).. "].isValid() == " .. tostring(valid))
  if valid == true or valid == false then return valid end
  return valid ~= nil
end

function HealthPanelAction:start()
end

function HealthPanelAction:update()
  self:forceComplete()
end

function HealthPanelAction:stop()
  ISBaseTimedAction.stop(self)
end

function HealthPanelAction:perform()
  --    print(self.handler.Type .. "["..tostring(self.handler).. "].perform()")
  self.handler:perform(self, self.args[1], self.args[2], self.args[3], self.args[4], self.args[5], self.args[6], self.args[7], self.args[8])

  -- needed to remove from queue / start next.
  ISBaseTimedAction.perform(self)
end

function HealthPanelAction:new(character, handler, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)
  local o = ISBaseTimedAction.new(self, character)
  o.stopOnWalk = true
  o.stopOnRun = true
  o.maxTime = -1
  o.handler = handler
  o.args = { arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8 }
  return o
end

-----

local BaseHandler = ISBaseObject:derive("BaseHandler")

function BaseHandler:new(panel, bodyPart)
  local o = {}
  setmetatable(o, self)
  self.__index = self
  o.panel = panel
  o.bodyPart = bodyPart
  o.items = {}
  return o
end

function BaseHandler:isInjured()
  local bodyPart = self.bodyPart
  return (bodyPart:HasInjury() or bodyPart:stitched() or bodyPart:getSplintFactor() > 0) and not bodyPart:bandaged()
end

function BaseHandler:checkItems()
  local items = {}
  for k, v in pairs(self.items) do
    items[k] = {}
  end
  self.items = items

  local containers = ISInventoryPaneContextMenu.getContainers(self:getDoctor())
  for i = 1, containers:size() do
    local container = containers:get(i - 1)
    for j = 1, container:getItems():size() do
      local item = container:getItems():get(j - 1)
      if instanceof(item, "InventoryContainer") and item:getType() == "FirstAidKit" then
        for k = 1, item:getItemContainer():getItems():size() do
          local item2 = item:getItemContainer():getItems():get(k - 1)
          self:checkItem(item2)
        end
      else
        self:checkItem(item)
      end
    end
  end
end

function BaseHandler:addItem(items, item)
  table.insert(items, item)
end

function BaseHandler:getAllItemTypes(items)
  local done = {}
  local types = {}
  for _, item in ipairs(items) do
    if not done[item:getFullType()] then
      table.insert(types, item:getFullType())
      done[item:getFullType()] = true
    end
  end
  return types
end

function BaseHandler:getItemOfType(items, type)
  for _, item in ipairs(items) do
    if item:getFullType() == type then
      return item
    end
  end
  return nil
end

function BaseHandler:getAllItemsOfType(items, type)
  local items = {}
  for _, item in ipairs(items) do
    if item:getFullType() == type then
      table.insert(items, item)
    end
  end
  return items
end

function BaseHandler:onMenuOptionSelected(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)
  ISTimedActionQueue.add(HealthPanelAction:new(self:getDoctor(), self, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8))
end

function BaseHandler:toPlayerInventory(item, previousAction)
  if item:getContainer() ~= self:getDoctor():getInventory() then
    local action = ISInventoryTransferAction:new(self:getDoctor(), item, item:getContainer(), self:getDoctor():getInventory())
    ISTimedActionQueue.addAfter(previousAction, action)
    -- FIXME: ISHealthPanel.actions never gets cleared
    self.panel.actions = self.panel.actions or {}
    self.panel.actions[action] = self.bodyPart
    return action
  end
  return previousAction
end

function BaseHandler:getDoctor()
  return self.panel.otherPlayer or self.panel.character
end

function BaseHandler:getPatient()
  return self.panel.character
end

-----

local HApplyBandage = BaseHandler:derive("HApplyBandage")

function HApplyBandage:new(panel, bodyPart)
  local o = BaseHandler.new(self, panel, bodyPart)
  o.items.ITEMS = {}
  return o
end

function HApplyBandage:checkItem(item)
  if item:getBandagePower() > 0 then
    self:addItem(self.items.ITEMS, item)
  end
end

function HApplyBandage:addToMenu(context)
  local types = self:getAllItemTypes(self.items.ITEMS)
  if #types > 0 and self:isInjured() then
    local option = context:addOption(getText("ContextMenu_Bandage"), nil)
    local subMenu = context:getNew(context)
    context:addSubMenu(option, subMenu)
    for i = 1, #types do
      local item = self:getItemOfType(self.items.ITEMS, types[i])
      subMenu:addOption(item:getName(), self, self.onMenuOptionSelected, types[i])
    end
  end
end

function HApplyBandage:isValid(itemType)
  self:checkItems()
  return self:getItemOfType(self.items.ITEMS, itemType) and self:isInjured()
end

function HApplyBandage:perform(previousAction, itemType)
  local item = self:getItemOfType(self.items.ITEMS, itemType)
  previousAction = self:toPlayerInventory(item, previousAction)
  local action = ISApplyBandage:new(self:getDoctor(), self:getPatient(), item, self.bodyPart, true)
  ISTimedActionQueue.addAfter(previousAction, action)
end

-----

local HRemoveBandage = BaseHandler:derive("HRemoveBandage")

function HRemoveBandage:new(panel, bodyPart)
  local o = BaseHandler.new(self, panel, bodyPart)
  return o
end

function HRemoveBandage:checkItem(item)
end

function HRemoveBandage:addToMenu(context)
  if self.bodyPart:bandaged() then
    context:addOption(getText("ContextMenu_Remove_Bandage"), self, self.onMenuOptionSelected)
  end
end

function HRemoveBandage:isValid()
  return self.bodyPart:bandaged()
end

function HRemoveBandage:perform(previousAction)
  local action = ISApplyBandage:new(self:getDoctor(), self:getPatient(), nil, self.bodyPart, false)
  ISTimedActionQueue.addAfter(previousAction, action)
end

-----

local HApplyPoultice = BaseHandler:derive("HApplyPoultice")

function HApplyPoultice:new(panel, bodyPart, itemType, menuLabel, actionClass)
  local o = BaseHandler.new(self, panel, bodyPart)
  o.items.ITEMS = {}
  o.itemType = itemType
  o.menuLabel = menuLabel
  o.actionClass = actionClass
  return o
end

function HApplyPoultice:checkItem(item)
  if item:getType() == self.itemType then
    self:addItem(self.items.ITEMS, item)
  end
end

function HApplyPoultice:addToMenu(context)
  local types = self:getAllItemTypes(self.items.ITEMS)
  if #types > 0 and self:isInjured() and
  self.bodyPart:getPlantainFactor() == 0 and
  self.bodyPart:getComfreyFactor() == 0 and
  self.bodyPart:getGarlicFactor() == 0 then
    local option = context:addOption(getText(self.menuLabel), nil)
    local subMenu = context:getNew(context)
    context:addSubMenu(option, subMenu)
    for i = 1, #types do
      local item = self:getItemOfType(self.items.ITEMS, types[i])
      subMenu:addOption(item:getName(), self, self.onMenuOptionSelected, types[i])
    end
  end
end

function HApplyPoultice:isValid(itemType)
  self:checkItems()
  return self:getItemOfType(self.items.ITEMS, itemType) and self:isInjured() and
  self.bodyPart:getPlantainFactor() == 0 and
  self.bodyPart:getComfreyFactor() == 0 and
  self.bodyPart:getGarlicFactor() == 0
end

function HApplyPoultice:perform(previousAction, itemType)
  local item = self:getItemOfType(self.items.ITEMS, itemType)
  previousAction = self:toPlayerInventory(item, previousAction)
  local action = self.actionClass:new(self:getDoctor(), self:getPatient(), item, self.bodyPart)
  ISTimedActionQueue.addAfter(previousAction, action)
end

-----

local HApplyComfrey = HApplyPoultice:derive("HApplyComfrey")

function HApplyComfrey:new(panel, bodyPart)
  return HApplyPoultice.new(self, panel, bodyPart, "ComfreyCataplasm", "ContextMenu_ComfreyCataplasm", ISComfreyCataplasm)
end

-----

local HApplyGarlic = HApplyPoultice:derive("HApplyGarlic")

function HApplyGarlic:new(panel, bodyPart)
  return HApplyPoultice.new(self, panel, bodyPart, "WildGarlicCataplasm", "ContextMenu_GarlicCataplasm", ISGarlicCataplasm)
end

-----

local HApplyPlantain = HApplyPoultice:derive("HApplyPlantain")

function HApplyPlantain:new(panel, bodyPart)
  return HApplyPoultice.new(self, panel, bodyPart, "PlantainCataplasm", "ContextMenu_PlantainCataplasm", ISPlantainCataplasm)
end

-----

local HDisinfect = BaseHandler:derive("HDisinfect")

function HDisinfect:new(panel, bodyPart)
  local o = BaseHandler.new(self, panel, bodyPart)
  o.items.ITEMS = {}
  return o
end

function HDisinfect:checkItem(item)
  if item:getAlcoholPower() > 0 then
    self:addItem(self.items.ITEMS, item)
  end
end

function HDisinfect:addToMenu(context)
  local types = self:getAllItemTypes(self.items.ITEMS)
  if #types > 0 and self:isInjured() then
    local option = context:addOption(getText("ContextMenu_Disinfect"), nil)
    local subMenu = context:getNew(context)
    context:addSubMenu(option, subMenu)
    for i = 1, #types do
      local item = self:getItemOfType(self.items.ITEMS, types[i])
      subMenu:addOption(item:getName(), self, self.onMenuOptionSelected, types[i])
    end
  end
end

function HDisinfect:isValid(itemType)
  self:checkItems()
  return self:getItemOfType(self.items.ITEMS, itemType) and self:isInjured()
end

function HDisinfect:perform(previousAction, itemType)
  local item = self:getItemOfType(self.items.ITEMS, itemType)
  previousAction = self:toPlayerInventory(item, previousAction)
  local action = ISDisinfect:new(self:getDoctor(), self:getPatient(), item, self.bodyPart)
  ISTimedActionQueue.addAfter(previousAction, action)
end

-----

local HStitch = BaseHandler:derive("HStitch")

function HStitch:new(panel, bodyPart)
  local o = BaseHandler.new(self, panel, bodyPart)
  o.items.ITEMS = {}
  return o
end

function HStitch:checkItem(item)
  if item:getType() == "Needle" then
    self:addItem(self.items.ITEMS, item)
  end
  if item:getType() == "Thread" and item:getUsedDelta() >= 0 then
    self:addItem(self.items.ITEMS, item)
  end
  if item:getType() == "SutureNeedle" then
    self:addItem(self.items.ITEMS, item)
  end
end

function HStitch:addToMenu(context)
  if not self:isInjured() or not self.bodyPart:isDeepWounded() or self.bodyPart:haveGlass() then
    return false
  end
  local needle = self:getItemOfType(self.items.ITEMS, "Base.Needle")
  local thread = self:getItemOfType(self.items.ITEMS, "Base.Thread")
  local needlePlusThread = self:getItemOfType(self.items.ITEMS, "Base.SutureNeedle")
  if (needle and thread) or needlePlusThread then
    local option = context:addOption(getText("ContextMenu_Stitch"), nil)
    local subMenu = context:getNew(context)
    context:addSubMenu(option, subMenu)
    if needlePlusThread then
      subMenu:addOption(needlePlusThread:getName(), self, self.onMenuOptionSelected, needlePlusThread:getFullType(), needlePlusThread:getFullType())
    end
    if needle and thread then
      local text = needle:getName() .. " + " .. thread:getName()
      subMenu:addOption(text, self, self.onMenuOptionSelected, needle:getFullType(), thread:getFullType())
    end
  end
end

function HStitch:isValid(needleType, threadType)
  if not self:isInjured() or not self.bodyPart:isDeepWounded() or self.bodyPart:haveGlass() then
    return false
  end
  self:checkItems()
  if needleType == threadType then
    local needlePlusThread = self:getItemOfType(self.items.ITEMS, needleType)
    return needlePlusThread ~= nil
  else
    local needle = self:getItemOfType(self.items.ITEMS, needleType)
    local thread = self:getItemOfType(self.items.ITEMS, threadType)
    return (needle and thread) ~= nil
  end
end

function HStitch:perform(previousAction, needleType, threadType)
  if needleType == threadType then
    local needle = self:getItemOfType(self.items.ITEMS, needleType)
    previousAction = self:toPlayerInventory(needle, previousAction)
    local action = ISStitch:new(self:getDoctor(), self:getPatient(), needle, self.bodyPart, true)
    ISTimedActionQueue.addAfter(previousAction, action)
  else
    local needle = self:getItemOfType(self.items.ITEMS, needleType)
    local thread = self:getItemOfType(self.items.ITEMS, threadType)
    previousAction = self:toPlayerInventory(needle, previousAction)
    previousAction = self:toPlayerInventory(thread, previousAction)
    local action = ISStitch:new(self:getDoctor(), self:getPatient(), thread, self.bodyPart, true)
    ISTimedActionQueue.addAfter(previousAction, action)
  end
end

-----

local HRemoveStitch = BaseHandler:derive("HRemoveStitch")

function HRemoveStitch:new(panel, bodyPart)
  local o = BaseHandler.new(self, panel, bodyPart)
  return o
end

function HRemoveStitch:checkItem(item)
end

function HRemoveStitch:addToMenu(context)
  if self.bodyPart:stitched() then
    context:addOption(getText("ContextMenu_Remove_Stitch"), self, self.onMenuOptionSelected)
  end
end

function HRemoveStitch:isValid()
  return self.bodyPart:stitched()
end

function HRemoveStitch:perform(previousAction)
  local action = ISStitch:new(self:getDoctor(), self:getPatient(), nil, self.bodyPart, false)
  ISTimedActionQueue.addAfter(previousAction, action)
end

-----

local HRemoveGlass = BaseHandler:derive("HRemoveGlass")

function HRemoveGlass:new(panel, bodyPart)
  local o = BaseHandler.new(self, panel, bodyPart)
  o.items.ITEMS = {}
  return o
end

function HRemoveGlass:checkItem(item)
  if item:getType() == "SutureNeedleHolder" or item:getType() == "Tweezers" then
    self:addItem(self.items.ITEMS, item)
  end
end

function HRemoveGlass:addToMenu(context)
  local types = self:getAllItemTypes(self.items.ITEMS)
  if #types > 0 and self:isInjured() and self.bodyPart:haveGlass() then
    local option = context:addOption(getText("ContextMenu_Remove_Glass"), nil)
    local subMenu = context:getNew(context)
    context:addSubMenu(option, subMenu)
    for i = 1, #types do
      local item = self:getItemOfType(self.items.ITEMS, types[i])
      subMenu:addOption(item:getName(), self, self.onMenuOptionSelected, types[i])
    end
  end
end

function HRemoveGlass:isValid(itemType)
  self:checkItems()
  return self:getItemOfType(self.items.ITEMS, itemType) and self:isInjured() and self.bodyPart:haveGlass()
end

function HRemoveGlass:perform(previousAction, itemType)
  local item = self:getItemOfType(self.items.ITEMS, itemType)
  previousAction = self:toPlayerInventory(item, previousAction)
  local action = ISRemoveGlass:new(self:getDoctor(), self:getPatient(), self.bodyPart)
  ISTimedActionQueue.addAfter(previousAction, action)
end

-----

local HSplint = BaseHandler:derive("HSplint")

function HSplint:new(panel, bodyPart)
  local o = BaseHandler.new(self, panel, bodyPart)
  o.items.splint = {}
  o.items.plank = {}
  o.items.rippedSheet = {}
  return o
end

function HSplint:checkItem(item)
  if item:getType() == "Splint" then
    self:addItem(self.items.splint, item)
  end
  if item:getType() == "Plank" or item:getType() == "TreeBranch" or item:getType() == "WoodenStick" then
    self:addItem(self.items.plank, item)
  end
  if item:getType() == "RippedSheets" then
    self:addItem(self.items.rippedSheet, item)
  end
end

function HSplint:addToMenu(context)
  if not self:isInjured() or self.bodyPart:getFractureTime() <= 0 or self.bodyPart:getSplintFactor() > 0 then
    return false
  end
  local splintType = self:getAllItemTypes(self.items.splint)
  local plankType = self:getAllItemTypes(self.items.plank)
  local rippedSheetType = self:getAllItemTypes(self.items.rippedSheet)
  if #splintType > 0 or (#plankType > 0 and #rippedSheetType > 0) then
    local option = context:addOption(getText("ContextMenu_Splint"), nil)
    local subMenu = context:getNew(context)
    context:addSubMenu(option, subMenu)
    for i = 1, #splintType do
      local item = self:getItemOfType(self.items.splint, splintType[i])
      subMenu:addOption(item:getName(), self, self.onMenuOptionSelected, nil, item:getFullType())
    end
    if #plankType > 0 and #rippedSheetType > 0 then
      local rippedSheet = self:getItemOfType(self.items.rippedSheet, rippedSheetType[1])
      for i = 1, #plankType do
        local plank = self:getItemOfType(self.items.plank, plankType[i])
        local text = plank:getName() .. " + " .. rippedSheet:getName()
        subMenu:addOption(text, self, self.onMenuOptionSelected, rippedSheet:getFullType(), plank:getFullType())
      end
    end
  end
end

function HSplint:isValid(rippedSheetType, plankType)
  if not self:isInjured() or self.bodyPart:getFractureTime() <= 0 or self.bodyPart:getSplintFactor() > 0 then
    return false
  end
  self:checkItems()
  local splints = self.items.splint
  local planks = self.items.plank
  local rippedSheets = self.items.rippedSheet
  return #splints > 0 or (#planks > 0 and #rippedSheets > 0)
end

function HSplint:perform(previousAction, rippedSheetType, plankType)
  if rippedSheetType then
    local rippedSheet = self:getItemOfType(self.items.rippedSheet, rippedSheetType)
    local plank = self:getItemOfType(self.items.plank, plankType)
    previousAction = self:toPlayerInventory(rippedSheet, previousAction)
    previousAction = self:toPlayerInventory(plank, previousAction)
    local action = ISSplint:new(self:getDoctor(), self:getPatient(), rippedSheet, plank, self.bodyPart, true)
    ISTimedActionQueue.addAfter(previousAction, action)
  else
    local splint = self:getItemOfType(self.items.splint, plankType)
    previousAction = self:toPlayerInventory(splint, previousAction)
    local action = ISSplint:new(self:getDoctor(), self:getPatient(), nil, splint, self.bodyPart, true)
    ISTimedActionQueue.addAfter(previousAction, action)
  end
end

-----

local HRemoveSplint = BaseHandler:derive("HRemoveSplint")

function HRemoveSplint:new(panel, bodyPart)
  local o = BaseHandler.new(self, panel, bodyPart)
  return o
end

function HRemoveSplint:checkItem(item)
end

function HRemoveSplint:addToMenu(context)
  if self:isInjured() and self.bodyPart:getSplintFactor() > 0 then
    context:addOption(getText("ContextMenu_Remove_Splint"), self, self.onMenuOptionSelected)
  end
end

function HRemoveSplint:isValid()
  return self:isInjured() and self.bodyPart:getSplintFactor() > 0
end

function HRemoveSplint:perform(previousAction)
  local action = ISSplint:new(self:getDoctor(), self:getPatient(), nil, nil, self.bodyPart, false)
  ISTimedActionQueue.addAfter(previousAction, action)
end

-----

local HRemoveBullet = BaseHandler:derive("HRemoveBullet")

function HRemoveBullet:new(panel, bodyPart)
  local o = BaseHandler.new(self, panel, bodyPart)
  o.items.ITEMS = {}
  return o
end

function HRemoveBullet:checkItem(item)
  if item:getType() == "Tweezers" or item:getType() == "SutureNeedleHolder" then
    self:addItem(self.items.ITEMS, item)
  end
end

function HRemoveBullet:addToMenu(context)
  local types = self:getAllItemTypes(self.items.ITEMS)
  if #types > 0 and self:isInjured() and self.bodyPart:haveBullet() then
    local option = context:addOption(getText("ContextMenu_Remove_Bullet"), nil)
    local subMenu = context:getNew(context)
    context:addSubMenu(option, subMenu)
    for i = 1, #types do
      local item = self:getItemOfType(self.items.ITEMS, types[i])
      subMenu:addOption(item:getName(), self, self.onMenuOptionSelected, item:getFullType())
    end
  end
end

function HRemoveBullet:isValid(itemType)
  return self:isInjured() and self.bodyPart:haveBullet() and self:getItemOfType(self.items.ITEMS, itemType)
end

function HRemoveBullet:perform(previousAction, itemType)
  local item = self:getItemOfType(self.items.ITEMS, itemType)
  previousAction = self:toPlayerInventory(item, previousAction)
  local action = ISRemoveBullet:new(self:getDoctor(), self:getPatient(), self.bodyPart)
  ISTimedActionQueue.addAfter(previousAction, action)
end

-----

local HCleanBurn = BaseHandler:derive("HCleanBurn")

function HCleanBurn:new(panel, bodyPart)
  local o = BaseHandler.new(self, panel, bodyPart)
  o.items.ITEMS = {}
  return o
end

function HCleanBurn:checkItem(item)
  if item:getBandagePower() >= 2 then
    self:addItem(self.items.ITEMS, item)
  end
end

function HCleanBurn:addToMenu(context)
  local types = self:getAllItemTypes(self.items.ITEMS)
  if #types > 0 and self:isInjured() and self.bodyPart:isNeedBurnWash() then
    local option = context:addOption(getText("ContextMenu_Clean_Burn"), nil)
    local subMenu = context:getNew(context)
    context:addSubMenu(option, subMenu)
    for i = 1, #types do
      local item = self:getItemOfType(self.items.ITEMS, types[i])
      subMenu:addOption(item:getName(), self, self.onMenuOptionSelected, item:getFullType())
    end
  end
end

function HCleanBurn:isValid(itemType)
  return self:isInjured() and self.bodyPart:isNeedBurnWash() and self:getItemOfType(self.items.ITEMS, itemType)
end

function HCleanBurn:perform(previousAction, itemType)
  local item = self:getItemOfType(self.items.ITEMS, itemType)
  previousAction = self:toPlayerInventory(item, previousAction)
  local action = ISCleanBurn:new(self:getDoctor(), self:getPatient(), item, self.bodyPart)
  ISTimedActionQueue.addAfter(previousAction, action)
end

-----

function ISHealthPanel:doBodyPartContextMenu(bodyPart, x, y)
  local playerNum = self.otherPlayer and self.otherPlayer:getPlayerNum() or self.character:getPlayerNum()
  local context = ISContextMenu.get(playerNum, x + self:getAbsoluteX(), y + self:getAbsoluteY());

  local handlers = {}
  table.insert(handlers, HRemoveBandage:new(self, bodyPart))
  table.insert(handlers, HApplyPlantain:new(self, bodyPart))
  table.insert(handlers, HApplyComfrey:new(self, bodyPart))
  table.insert(handlers, HApplyGarlic:new(self, bodyPart))
  table.insert(handlers, HApplyBandage:new(self, bodyPart))
  table.insert(handlers, HDisinfect:new(self, bodyPart))
  table.insert(handlers, HStitch:new(self, bodyPart))
  table.insert(handlers, HRemoveStitch:new(self, bodyPart))
  table.insert(handlers, HRemoveGlass:new(self, bodyPart))
  table.insert(handlers, HSplint:new(self, bodyPart))
  table.insert(handlers, HRemoveSplint:new(self, bodyPart))
  table.insert(handlers, HRemoveBullet:new(self, bodyPart))
  table.insert(handlers, HCleanBurn:new(self, bodyPart))

  local containers = ISInventoryPaneContextMenu.getContainers(self.otherPlayer or self.character)
  for i = 1, containers:size() do
    local container = containers:get(i - 1)
    for j = 1, container:getItems():size() do
      local item = container:getItems():get(j - 1)
      for _, handler in ipairs(handlers) do
        if instanceof(item, "InventoryContainer") and item:getType() == "FirstAidKit" then
          for k = 1, item:getItemContainer():getItems():size() do
            local item2 = item:getItemContainer():getItems():get(k - 1)
            handler:checkItem(item2)
          end
        else
          handler:checkItem(item)
        end
      end
    end
  end

  for _, handler in ipairs(handlers) do
    handler:addToMenu(context)
  end

  if ISHealthPanel.cheat then
    if not isClient() or self:getPatient():isLocalPlayer() then
      local option = context:addOption("Cheat", nil);
      local subMenu = context:getNew(context);
      context:addSubMenu(option, subMenu);
      subMenu:addOption("Toggle Bleeding", bodyPart, ISHealthPanel.onCheat, "bleeding", self.character, self.otherPlayer);
      subMenu:addOption("Toggle Bullet", bodyPart, ISHealthPanel.onCheat, "bullet", self.character, self.otherPlayer);
      subMenu:addOption("Toggle Burned", bodyPart, ISHealthPanel.onCheat, "burned", self.character, self.otherPlayer);
      subMenu:addOption("Toggle Burn Needs Wash", bodyPart, ISHealthPanel.onCheat, "burnWash", self.character, self.otherPlayer);
      subMenu:addOption("Toggle Deep Wound", bodyPart, ISHealthPanel.onCheat, "deepWound", self.character, self.otherPlayer);
      subMenu:addOption("Toggle Fracture", bodyPart, ISHealthPanel.onCheat, "fracture", self.character, self.otherPlayer);
      subMenu:addOption("Toggle Glass Shards", bodyPart, ISHealthPanel.onCheat, "glass", self.character, self.otherPlayer);
      subMenu:addOption("Toggle Infected", bodyPart, ISHealthPanel.onCheat, "infected", self.character, self.otherPlayer);
      subMenu:addOption("Toggle Scratched", bodyPart, ISHealthPanel.onCheat, "scratched", self.character, self.otherPlayer);
      subMenu:addOption("Health Full", bodyPart, ISHealthPanel.onCheat, "healthFull", self.character, self.otherPlayer);
    end

    local option = context:addOption("Cheat Item", nil);
    local subMenu = context:getNew(context)
    context:addSubMenu(option, subMenu)
    local types = { "Base.Bandage", "Base.Bandaid", "Base.RippedSheets", "Base.Needle", "Base.Thread", "Base.SutureNeedle", "Base.Tweezers", "Base.SutureNeedleHolder", "Base.Splint", "Base.TreeBranch", "Base.WoodenStick", "Base.PlantainCataplasm", "Base.WildGarlicCataplasm", "Base.ComfreyCataplasm" }
    for _, type in ipairs(types) do
      local scriptItem = getScriptManager():FindItem(type)
      local name = scriptItem and scriptItem:getDisplayName() or type
      subMenu:addOption(name, type, ISHealthPanel.onCheatItem, self.otherPlayer or self.character)
    end
  end

  if context:isEmpty() then
    context:setVisible(false);
  end

  if JoypadState.players[playerNum + 1] and context:getIsVisible() then
    context.mouseOver = 1
    context.origin = self
    JoypadState.players[playerNum + 1].focus = context
    updateJoypadFocus(JoypadState.players[playerNum + 1])
  end
end
