
local ISInventoryPane_doButtons_original = ISInventoryPane.doButtons
function ISInventoryPane:doButtons(y, ...)

  self.contextButton1:setVisible(false);
  self.contextButton2:setVisible(false);
  self.contextButton3:setVisible(false);

  if UIManager.getSpeedControls|():getCurrentGameSpeed() ~= 0
    ISInventoryPane_doButtons_original(self, y, ...)
  end
  if getPlayerContextMenu(self.player):isAnyVisible() or
  getSpecificPlayer(self.player):isAsleep() then
    return
  end

  if ISMouseDrag.dragging and #ISMouseDrag.dragging > 0 then
    return
  end

  local count = 1;
  local item = self.items[y]
  if not instanceof(item, "InventoryItem") then
    count = item.count - 1;
    item = item.items[1]
  end
  local isNoDropMoveable = instanceof(item, "Moveable") and not item:CanBeDroppedOnFloor()

  local mode1, mode2, mode3 = nil, nil, nil
  local label1, label2, label3 = nil, nil, nil

  if self.inventory:isInCharacterInventory(getSpecificPlayer(self.player)) and self.inventory ~= getSpecificPlayer(self.player):getInventory() then
    -- unpack, drop
    mode1, label1 = "unpack", getText("IGUI_invpanel_unpack")
    if isNoDropMoveable then
      -- No 'Drop' option
    elseif count == 1 then
      mode2, label2 = "drop", getText("ContextMenu_Drop")
    else
      mode2, label2 = "drop", getText("IGUI_invpanel_drop_all")
      mode3, label3 = "drop1", getText("IGUI_invpanel_drop_one")
    end
    if not instanceof(self.items[y], "InventoryItem") then
      local fav = true;
      local firstFav = true;
      for i, v in ipairs(self.items[y].items) do
        if i == 1 then firstFav = v:isFavorite() end;
          if not v:isFavorite() then
            fav = false;
          end
        end
        if fav then
          mode2 = nil
          mode3 = nil
        elseif count > 1 and firstFav then
          mode3 = nil
        end
      else
        if self.items[y]:isFavorite() then
          mode2 = nil
          mode3 = nil
        end
      end
    elseif self.inventory == getSpecificPlayer(self.player):getInventory() then
      if isNoDropMoveable then
        -- No 'Drop' option
      elseif count == 1 then
        mode1, label1 = "drop", getText("ContextMenu_Drop")
      else
        mode1, label1 = "drop", getText("IGUI_invpanel_drop_all")
        mode2, label2 = "drop1", getText("IGUI_invpanel_drop_one")
      end
      if not instanceof(self.items[y], "InventoryItem") then
        local fav = true;
        local firstFav = true;
        for i, v in ipairs(self.items[y].items) do
          if i == 1 then firstFav = v:isFavorite() end;
            if not v:isFavorite() then
              fav = false;
            end
          end
          if fav then
            mode1 = nil
            mode2 = nil
          elseif count > 1 and firstFav then
            mode2 = nil
          end
        else
          if self.items[y]:isFavorite() then
            mode1 = nil
            mode2 = nil
          end
        end

        if instanceof(item, "Moveable") then
          if mode1 and mode2 then
            mode3, label3 = "place", getText("IGUI_Place")
          elseif mode1 then
            mode2, label2 = "place", getText("IGUI_Place")
          else
            mode1, label1 = "place", getText("IGUI_Place")
          end
        end
      else
        if count == 1 then
          mode1, label1 = "grab", getText("ContextMenu_Grab")
        else
          mode1, label1 = "grab", getText("ContextMenu_Grab_all")
          mode2, label2 = "grab1", getText("ContextMenu_Grab_one")
        end
      end

      local ypos = ((y - 1) * self.itemHgt) + self.headerHgt;
      ypos = ypos + self:getYScroll();

      if getCore():getGameMode() ~= "Tutorial" then
        if mode1 then
          self.contextButton1:setTitle(label1)
          self.contextButton1.mode = mode1
          self.contextButton1:setWidthToTitle()
          self.contextButton1:setX(self.column3)
          self.contextButton1:setY(ypos)
          self.contextButton1:setVisible(true)
        end
        if mode2 then
          self.contextButton2:setTitle(label2)
          self.contextButton2.mode = mode2
          self.contextButton2:setWidthToTitle()
          self.contextButton2:setX(self.contextButton1:getRight() + 1)
          self.contextButton2:setY(ypos)
          self.contextButton2:setVisible(true)
        end
        if mode3 then
          self.contextButton3:setTitle(label3)
          self.contextButton3.mode = mode3
          self.contextButton3:setWidthToTitle()
          self.contextButton3:setX(self.contextButton2:getRight() + 1)
          self.contextButton3:setY(ypos)
          self.contextButton3:setVisible(true)
        end
      end

      self.buttonOption = y;
    end

    function ISInventoryPane:toggleStove()
      local stove = self.inventory:getParent();
      stove:Toggle();
      return stove:Activated();
    end

    function ISInventoryPane:sortItemsByType(items)
      table.sort(items, function(a, b)
        if a:getContainer() and a:getContainer() == b:getContainer() and a:getDisplayName() == b:getDisplayName() then
        return a:getContainer():getItems():indexOf(a) < b:getContainer():getItems():indexOf(b)
      end
      return not string.sort(a:getType(), b:getType())
    end)
  end

  function ISInventoryPane:sortItemsByWeight(items)
    table.sort(items, function(a, b)
      if a:getContainer() and a:getContainer() == b:getContainer() and a:getDisplayName() == b:getDisplayName() then
      return a:getContainer():getItems():indexOf(a) < b:getContainer():getItems():indexOf(b)
    end
    return a:getUnequippedWeight() < b:getUnequippedWeight()
  end)
end

local ISInventoryPane_doContextOnJoypadSelected_original = ISInventoryPane.doContextOnJoypadSelected
function ISInventoryPane:doContextOnJoypadSelected()
  if JoypadState.disableInvInteraction then
    return;
  end
  if UIManager.getSpeedControls|() and UIManager.getSpeedControls|():getCurrentGameSpeed() ~= 0 then
    ISInventoryPane_doContextOnJoypadSelected_original
  end

  local playerObj = getSpecificPlayer(self.player)
  if playerObj:isAsleep() then return end

  local isInInv = self.inventory:isInCharacterInventory(playerObj)

  if #self.items == 0 then
    local menu = ISInventoryPaneContextMenu.createMenuNoItems(self.player, not isInInv, self:getAbsoluteX() + 64, self:getAbsoluteY() + 64)
    if menu then
      menu.origin = self.inventoryPage
      menu.mouseOver = 1
      setJoypadFocus(self.player, menu)
    end
    return
  end

  if self.joyselection == nil then return end
  if not self.doController then return end

  self:selectIndex(self.joyselection + 1);
  local item = self.items[self.joyselection + 1];

  local contextMenuItems = {}
  for k, v in ipairs(self.items) do
    if self.selected[k] ~= nil then
      if instanceof(v, "InventoryItem") or self.collapsed[v.name] then
        table.insert(contextMenuItems, v);
      end
    end
  end

  local menu = nil;
  if getCore():getGameMode() == "Tutorial" then
    menu = Tutorial1.createInventoryContextMenu(self.player, isInInv, contextMenuItems, self:getAbsoluteX() + 64, self:getAbsoluteY() + 8 + (self.joyselection * self.itemHgt) + self:getYScroll());
  else
    menu = ISInventoryPaneContextMenu.createMenu(self.player, isInInv, contextMenuItems, self:getAbsoluteX() + 64, self:getAbsoluteY() + 8 + (self.joyselection * self.itemHgt) + self:getYScroll());
  end
  menu.origin = self.inventoryPage;
  menu.mouseOver = 1;
  if menu.numOptions > 1 then
    setJoypadFocus(self.player, menu)
  end
end
