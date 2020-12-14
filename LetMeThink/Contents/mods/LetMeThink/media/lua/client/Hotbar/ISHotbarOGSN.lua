function ISHotbar:doMenu(slotIndex)
  if UIManager.getSpeedControls():getCurrentGameSpeed() == 0 then
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
