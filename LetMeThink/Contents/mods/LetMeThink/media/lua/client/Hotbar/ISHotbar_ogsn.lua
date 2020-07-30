
function ISHotbar:doMenu(slotIndex)
  if UIManager.getSpeedControls|():getCurrentGameSpeed() == 0 then
    return;
  end

  local slot = self.availableSlot[slotIndex];
  local slotDef = slot.def;
  local context = ISContextMenu.get(self.playerNum, getMouseX(), getMouseY());
  local found = false;

  -- first check for remove
  if self.attachedItems[slotIndex] then
    context = ISInventoryPaneContextMenu.createMenu(self.chr:getPlayerNum(), true, {self.attachedItems[slotIndex]}, getMouseX(), getMouseY());
    --		context:addOptionOnTop("Remove " .. self.attachedItems[slotIndex]:getDisplayName(), self, ISHotbar.removeItem, self.attachedItems[slotIndex], true);
    found = true;
  end

  local subMenuAttach;
  -- fetch all items in our inventory to check what can be added there
  for i = 0, self.chr:getInventory():getItems():size() - 1 do
    local item = self.chr:getInventory():getItems():get(i);
    if item:getAttachmentType() and item:getAttachedSlot() == -1 and not item:isBroken() then
      for i, v in pairs(slotDef.attachments) do
        if item:getAttachmentType() == i then
          local doIt = true;
          if self.replacements and self.replacements[item:getAttachmentType()] then
            slot = self.replacements[item:getAttachmentType()];
            if slot == "null" then
              doIt = false;
            end
          end
          if doIt then
            if not subMenuAttach then
              local subOption = context:addOptionOnTop(getText("ContextMenu_Attach"), nil);
              subMenuAttach = context:getNew(context);
              context:addSubMenu(subOption, subMenuAttach);
            end
            subMenuAttach:addOption(item:getDisplayName(), self, ISHotbar.attachItem, item, v, slotIndex, slotDef, true);
            found = true;
          end
        end
      end
    end
  end

  if not found then
    local option = context:addOption(getText("ContextMenu_NoWeaponsAvailable"));
    option.notAvailable = true;
  end
end

ISHotbar.onKeyStartPressed = function(key)
  local playerObj = getSpecificPlayer(0)
  if not getPlayerHotbar(0) or not playerObj or playerObj:isDead() then
    return
  end
  if UIManager.getSpeedControls|() and (UIManager.getSpeedControls|():getCurrentGameSpeed() == 0) then
    return
  end
  local self = getPlayerHotbar(0)
  local slotToCheck = self:getSlotForKey(key)
  if slotToCheck == -1 then return end
  local radialMenu = getPlayerRadialMenu(0)
  if getCore():getOptionRadialMenuKeyToggle() and radialMenu:isReallyVisible() then
    getPlayerHotbar(0).radialWasVisible = true
    radialMenu:removeFromUIManager()
    return
  end
  getPlayerHotbar(0).keyPressedMS = getTimestampMs()
  getPlayerHotbar(0).radialWasVisible = false
end

ISHotbar.onKeyPressed = function(key)
  local playerObj = getSpecificPlayer(0)
  if not getPlayerHotbar(0) or not playerObj or playerObj:isDead() then
    return
  end
  if UIManager.getSpeedControls|() and (UIManager.getSpeedControls|():getCurrentGameSpeed() == 0) then
    return
  end
  local self = getPlayerHotbar(0);
  local slotToCheck = self:getSlotForKey(key)
  if slotToCheck == -1 then return end
  local radialMenu = getPlayerRadialMenu(0)
  if radialMenu:isReallyVisible() or getPlayerHotbar(0).radialWasVisible then
    if not getCore():getOptionRadialMenuKeyToggle() then
      radialMenu:removeFromUIManager()
    end
    return
  end
  if playerObj:isAttacking() then
    return;
  end

  -- don't do hotkey if you're doing action
  local queue = ISTimedActionQueue.queues[playerObj];
  if queue and #queue.queue > 0 then
    return;
  end

  self:activateSlot(slotToCheck);
end

ISHotbar.onKeyKeepPressed = function(key)
  local playerObj = getSpecificPlayer(0)
  if not getPlayerHotbar(0) or not playerObj or playerObj:isDead() then
    return
  end
  if UIManager.getSpeedControls|() and (UIManager.getSpeedControls|():getCurrentGameSpeed() == 0) then
    return
  end
  if playerObj:isAttacking() then
    return
  end
  local queue = ISTimedActionQueue.queues[playerObj]
  if queue and #queue.queue > 0 then
    return
  end
  if getPlayerHotbar(0).radialWasVisible then
    return
  end
  local self = getPlayerHotbar(0);
  local slotToCheck = self:getSlotForKey(key)
  if slotToCheck == -1 then
    return
  end
  local radialMenu = getPlayerRadialMenu(0)
  if self.availableSlot[slotToCheck] and (getTimestampMs() - self.keyPressedMS > 500) and not radialMenu:isReallyVisible() then
    radialMenu:clear()
    local inv = playerObj:getInventory():getItems()
    for i = 1, inv:size() do
      local item = inv:get(i - 1)
      if self:isItemAttached(item) then

      elseif item:getAttachmentType() and item:getCondition() > 0 and self.replacements[item:getAttachmentType()] ~= "null" then
        local slot = self.availableSlot[slotToCheck]
        local slotDef = slot.def
        for type, v in pairs(slotDef.attachments) do
          if item:getAttachmentType() == type then
            radialMenu:addSlice(item:getDisplayName(), item:getTex(), ISHotbar.onRadialAttach, self, item, slotToCheck, v)
            break
          end
        end
      end
    end
    if self.attachedItems[slotToCheck] then
      local item = self.attachedItems[slotToCheck]
      radialMenu:addSlice(getText("ContextMenu_HotbarRadialRemove", item:getDisplayName()), getTexture("media/ui/ZoomOut.png"), ISHotbar.onRadialRemove, self, item)
    end
    radialMenu:setX(getPlayerScreenLeft(0) + getPlayerScreenWidth(0) / 2 - radialMenu:getWidth() / 2)
    radialMenu:setY(getPlayerScreenTop(0) + getPlayerScreenHeight(0) / 2 - radialMenu:getHeight() / 2)
    radialMenu:addToUIManager()
  end
end
