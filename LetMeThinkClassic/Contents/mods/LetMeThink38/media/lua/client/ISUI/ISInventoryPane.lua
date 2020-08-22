--***********************************************************
--**               LEMMY/ROBERT JOHNSON                    **
--***********************************************************

require "ISUI/ISPanel"
require "ISUI/ISButton"
require "ISUI/ISMouseDrag"
require "TimedActions/ISTimedActionQueue"
require "TimedActions/ISEatFoodAction"



ISInventoryPane = ISPanel:derive("ISInventoryPane");


--************************************************************************--
--** ISInventoryPane:initialise
--**
--************************************************************************--

function ISInventoryPane:initialise()
  ISPanel.initialise(self);
end

--************************************************************************--
--** ISPanel:instantiate
--**
--************************************************************************--
function ISInventoryPane:createChildren()
  self.minimumHeight = 50;
  self.minimumWidth = 256;

  self.expandAll = ISButton:new(0, 0, 15, 17, "", self, ISInventoryPane.expandAll);
  self.expandAll:initialise();
  self.expandAll.borderColor.a = 0.0;
  --  self.expandAll.backgroundColorMouseOver.a = 0;
  self.expandAll:setImage(self.expandicon);

  self:addChild(self.expandAll);

  self.column2 = math.ceil(self.column2 * self.zoom);
  self.column3 = math.ceil(self.column3 * self.zoom);

  local categoryWid = math.max(100, self.column4 - self.column3 - 1)
  if self.column3 - 1 + categoryWid > self.width then
    self.column3 = self.width - categoryWid + 1
  end

  self.collapseAll = ISButton:new(15, 0, 15, 17, "", self, ISInventoryPane.collapseAll);
  self.collapseAll:initialise();
  self.collapseAll.borderColor.a = 0.0;
  -- self.collapseAll.backgroundColorMouseOver.a = 0;
  self.collapseAll:setImage(self.collapseicon);
  self:addChild(self.collapseAll);

  self.nameHeader = ISResizableButton:new(self.column2, 0, (self.column3 - self.column2), 16, getText("IGUI_invpanel_Type"), self, ISInventoryPane.sortByName);
  self.nameHeader:initialise();
  self.nameHeader.borderColor.a = 0.2;
  self.nameHeader.minimumWidth = 100
  self.nameHeader.onresize = { ISInventoryPane.onResizeColumn, self, self.nameHeader }
  self:addChild(self.nameHeader);

  self.typeHeader = ISResizableButton:new(self.column3 - 1, 0, self.column4 - self.column3 + 1, 16, getText("IGUI_invpanel_Category"), self, ISInventoryPane.sortByType);
  self.typeHeader.borderColor.a = 0.2;
  self.typeHeader.anchorRight = true;
  self.typeHeader.minimumWidth = 100
  self.typeHeader.resizeLeft = true
  self.typeHeader.onresize = { ISInventoryPane.onResizeColumn, self, self.typeHeader }
  self.typeHeader:initialise();
  self:addChild(self.typeHeader);

  local btnWid = math.ceil(55 * self.zoom)
  local btnHgt = math.ceil(17 * self.zoom)
  self.contextButton1 = ISButton:new(0, 0, btnWid, btnHgt, getText("ContextMenu_Grab"), self, ISInventoryPane.onContext);
  self.contextButton1:initialise();
  self:addChild(self.contextButton1);
  self.contextButton1:setVisible(false);
  self.contextButton1.borderColor.a = 0.3;

  self.contextButton2 = ISButton:new(0, 0, btnWid, btnHgt, getText("IGUI_invpanel_Pack"), self, ISInventoryPane.onContext);
  self.contextButton2:initialise();
  self:addChild(self.contextButton2);
  self.contextButton2:setVisible(false);
  self.contextButton2.borderColor.a = 0.3;

  self.contextButton3 = ISButton:new(0, 0, btnWid, btnHgt, getText("IGUI_invpanel_Pack"), self, ISInventoryPane.onContext);
  self.contextButton3:initialise();
  self:addChild(self.contextButton3);
  self.contextButton3:setVisible(false);
  self.contextButton3.borderColor.a = 0.3;


  self:addScrollBars();
end

function ISInventoryPane:onResizeColumn(button)
  if button == self.nameHeader then
    self.column3 = self.nameHeader.x + self.nameHeader.width
    self.typeHeader:setX(self.column3 - 1)
    self.typeHeader:setWidth(self.width - self.typeHeader.x)
  end
  if button == self.typeHeader then
    self.nameHeader:setWidth(self.typeHeader.x - self.column2 + 1)
    self.column3 = self.typeHeader.x
  end
end

function ISInventoryPane:onResize()
  ISPanel.onResize(self)
  if self.typeHeader:getWidth() == self.typeHeader.minimumWidth then
    self.column3 = self.width - self.typeHeader:getWidth() + 1
    self.nameHeader:setWidth(self.column3 - self.column2)
    self.typeHeader:setX(self.column3 - 1)
  end
  self.column4 = self.width
end

function ISInventoryPane:onContext(button)


  local playerInv = getSpecificPlayer(self.player):getInventory();
  local lootInv = getPlayerLoot(self.player).inventory;


  if button.mode == "unpack" then
    local k = self.items[self.buttonOption];
    if not instanceof(k, "InventoryItem") then
      for i2, k2 in ipairs(k.items) do
        -- first in a list is a dummy duplicate, so ignore it.
        if i2 ~= 1 and k2:getContainer() ~= getSpecificPlayer(self.player):getInventory() then
          ISTimedActionQueue.add(ISInventoryTransferAction:new(getSpecificPlayer(self.player), k2, k2:getContainer(), getSpecificPlayer(self.player):getInventory()));
        end

      end
    elseif k:getContainer() ~= getSpecificPlayer(self.player):getInventory() then
      ISTimedActionQueue.add(ISInventoryTransferAction:new(getSpecificPlayer(self.player), k, k:getContainer(), getSpecificPlayer(self.player):getInventory()));
    end
  end
  if button.mode == "grab" then
    local k = self.items[self.buttonOption];
    if not instanceof(k, "InventoryItem") then
      for i2, k2 in ipairs(k.items) do
        -- first in a list is a dummy duplicate, so ignore it.
        if i2 ~= 1 and k2:getContainer() ~= playerInv then
          ISTimedActionQueue.add(ISInventoryTransferAction:new(getSpecificPlayer(self.player), k2, k2:getContainer(), getPlayerInventory(self.player).inventory));
        end

      end
    elseif k:getContainer() ~= playerInv then
      ISTimedActionQueue.add(ISInventoryTransferAction:new(getSpecificPlayer(self.player), k, k:getContainer(), getPlayerInventory(self.player).inventory));
    end
  end
  if button.mode == "grab1" then

    local k = self.items[self.buttonOption];
    if not instanceof(k, "InventoryItem") then
      for i2, k2 in ipairs(k.items) do
        -- first in a list is a dummy duplicate, so ignore it.
        if i2 ~= 1 and k2:getContainer() ~= playerInv then
          ISTimedActionQueue.add(ISInventoryTransferAction:new(getSpecificPlayer(self.player), k2, k2:getContainer(), getPlayerInventory(self.player).inventory));
          return;
        end

      end
    elseif k:getContainer() ~= playerInv then
      ISTimedActionQueue.add(ISInventoryTransferAction:new(getSpecificPlayer(self.player), k, k:getContainer(), getPlayerInventory(self.player).inventory));
    end


  end
  if button.mode == "drop" then

    local k = self.items[self.buttonOption];
    if not instanceof(k, "InventoryItem") then
      for i2, k2 in ipairs(k.items) do
        -- first in a list is a dummy duplicate, so ignore it.
        if i2 ~= 1 and k2:getContainer() ~= lootInv then
          ISTimedActionQueue.add(ISInventoryTransferAction:new(getSpecificPlayer(self.player), k2, k2:getContainer(), lootInv));
        end

      end
    elseif k:getContainer() ~= lootInv then
      ISTimedActionQueue.add(ISInventoryTransferAction:new(getSpecificPlayer(self.player), k, k:getContainer(), lootInv));
    end


  end
  if button.mode == "drop1" then

    local k = self.items[self.buttonOption];
    if not instanceof(k, "InventoryItem") then
      for i2, k2 in ipairs(k.items) do
        -- first in a list is a dummy duplicate, so ignore it.
        if i2 ~= 1 and k2:getContainer() ~= lootInv then
          ISTimedActionQueue.add(ISInventoryTransferAction:new(getSpecificPlayer(self.player), k2, k2:getContainer(), lootInv));
          return;
        end

      end
    elseif k:getContainer() ~= lootInv then
      ISTimedActionQueue.add(ISInventoryTransferAction:new(getSpecificPlayer(self.player), k, k:getContainer(), lootInv));
    end


  end

  getPlayerLoot(self.player).inventoryPane.selected = {};
  getPlayerInventory(self.player).inventoryPane.selected = {};
end


function ISInventoryPane:collapseAll(button)
  for k, v in pairs(self.collapsed) do
    self.collapsed[k] = true;
  end
  self:refreshContainer();
end

function ISInventoryPane:expandAll(button)
  for k, v in pairs(self.collapsed) do
    self.collapsed[k] = false;
  end
  self:refreshContainer();
end

ISInventoryPane.itemSortByNameInc = function(a, b)
  if a.equipped and not b.equipped then return true end
  if b.equipped and not a.equipped then return false end
  return not string.sort(a.name, b.name);
end

ISInventoryPane.itemSortByNameDesc = function(a, b)
  if a.equipped and not b.equipped then return true end
  if b.equipped and not a.equipped then return false end
  return string.sort(a.name, b.name);
end

ISInventoryPane.itemSortByCatInc = function(a, b)
  if a.equipped and not b.equipped then return true end
  if b.equipped and not a.equipped then return false end
  if a.cat == b.cat then return not string.sort(a.name, b.name) end
  return not string.sort(a.cat, b.cat);
end

ISInventoryPane.itemSortByCatDesc = function(a, b)
  if a.equipped and not b.equipped then return true end
  if b.equipped and not a.equipped then return false end
  if a.cat == b.cat then return not string.sort(a.name, b.name) end
  return string.sort(a.cat, b.cat);
end

function ISInventoryPane:sortByName(button)
  if self.itemSortFunc == ISInventoryPane.itemSortByNameInc then
    self.itemSortFunc = ISInventoryPane.itemSortByNameDesc;
  else
    self.itemSortFunc = ISInventoryPane.itemSortByNameInc;
  end
  self:refreshContainer();
end

function ISInventoryPane:sortByType(button)
  if self.itemSortFunc == ISInventoryPane.itemSortByCatInc then
    self.itemSortFunc = ISInventoryPane.itemSortByCatDesc;
  else
    self.itemSortFunc = ISInventoryPane.itemSortByCatInc;
  end
  self:refreshContainer();
end

function ISInventoryPane:SaveLayout(name, layout)
  layout.column2 = self.nameHeader.width
  if self.itemSortFunc == self.itemSortByNameInc then layout.sortBy = "nameInc" end
  if self.itemSortFunc == self.itemSortByNameDesc then layout.sortBy = "nameDesc" end
  if self.itemSortFunc == self.itemSortByCatInc then layout.sortBy = "catInc" end
  if self.itemSortFunc == self.itemSortByCatDesc then layout.sortBy = "catDesc" end
end

function ISInventoryPane:RestoreLayout(name, layout)
  if layout.column2 and tonumber(layout.column2) then
    self.nameHeader:setWidth(tonumber(layout.column2))
    self:onResizeColumn(self.nameHeader)
  end
  if layout.sortBy == "nameInc" then self.itemSortFunc = self.itemSortByNameInc end
  if layout.sortBy == "nameDesc" then self.itemSortFunc = self.itemSortByNameDesc end
  if layout.sortBy == "catInc" then self.itemSortFunc = self.itemSortByCatInc end
  if layout.sortBy == "catDesc" then self.itemSortFunc = self.itemSortByCatDesc end
  self:refreshContainer()
end

function ISInventoryPane:rowAt(x, y)
  local headerHeight = 16
  local rowCount = math.floor((self:getScrollHeight() - headerHeight) / self.itemHgt)
  if rowCount > 0 then
    return math.floor((y) / self.itemHgt) + 1
  end
  return - 1
end

function ISInventoryPane:topOfItem(index)
  local headerHeight = 16
  local rowCount = math.floor((self:getScrollHeight() - headerHeight) / self.itemHgt)
  if rowCount > 0 then
    return (index - 1) * self.itemHgt
  end
  return - 1
end

function ISInventoryPane:onMouseWheel(del)
  if self.inventoryPage.isCollapsed then return false; end
  local yScroll = self.smoothScrollTargetY or self:getYScroll()
  local topRow = self:rowAt(0, - yScroll)
  if self.items[topRow] then
    if not self.smoothScrollTargetY then self.smoothScrollY = self:getYScroll() end
    local y = self:topOfItem(topRow)
    if del < 0 then
      if yScroll == -y and topRow > 1 then
        y = self:topOfItem(topRow - 1)
      end
      self.smoothScrollTargetY = -y;
    else
      self.smoothScrollTargetY = -(y + self.itemHgt);
    end
  else
    self:setYScroll(self:getYScroll() - (del * 9));
  end
  return true;
end

function ISInventoryPane:onMouseMoveOutside(dx, dy)
  local x = self:getMouseX();
  local y = self:getMouseY();
  self.buttonOption = 0;

  self.contextButton1:setVisible(false);
  self.contextButton2:setVisible(false);
  self.contextButton3:setVisible(false);

  if(self.draggingMarquis) then
    local x2 = self.draggingMarquisX;
    local y2 = self.draggingMarquisY;
    if(self:getMouseY() + self:getYScroll() > self:getHeight()) then
      self:setYScroll(self:getYScroll() - (9));
    end
    if(self:getMouseY() + self:getYScroll() < 0) then
      self:setYScroll(self:getYScroll() + (9));
    end

    if (x2 < x) then
      local xt = x;
      x = x2;
      x2 = xt;
    end
    if (y2 < y) then
      local yt = y;
      y = y2;
      y2 = yt;
    end

    if x > self.column3 then
      return;
    end

    local startY = math.floor((y - 16) / self.itemHgt) + 1;
    local endY = math.floor((((y2) - 16) / self.itemHgt)) + 1;

    if(startY < 1) then
      startY = 1;
    end

    self.selected = {}
    local c = 1;
    for i = startY, endY do
      --print("selected: "..i);
      self.selected[i] = self.items[i];
      if self.items[i] ~= nil then


        if not instanceof(self.items[i], "InventoryItem") and not self.collapsed[self.items[i].name] then
          local scount = 0;
          for k, v in ipairs(self.items[i].items) do
            if scount > 0 then
              self.selected[i + scount] = v;
            end

            scount = scount + 1;
          end
        end

        c = c + 1;
      end
    end


  end
  --[[
	if self.toolRender and not self.doController then
		self.toolRender:removeFromUIManager();
		self.toolRender:setVisible(false);
		self.toolRender = nil;
	end
]]--
end

function ISInventoryPane:hideButtons()
  self.contextButton1:setVisible(false);
  self.contextButton2:setVisible(false);
  self.contextButton3:setVisible(false);
end

function ISInventoryPane:doButtons(y)

  self.contextButton1:setVisible(false);
  self.contextButton2:setVisible(false);
  self.contextButton3:setVisible(false);

  if getPlayerContextMenu(self.player):getIsVisible() or
  getSpecificPlayer(self.player):isAsleep() then
    return
  end

  if ISMouseDrag.dragging and #ISMouseDrag.dragging > 0 then
    return
  end

  local count = 1;
  if not instanceof(self.items[y], "InventoryItem") then
    count = self.items[y].count - 1;
  end


  if self.inventory:isInCharacterInventory(getSpecificPlayer(self.player)) and self.inventory ~= getSpecificPlayer(self.player):getInventory() then
    -- unpack, drop
    self.contextButton1:setTitle(getText("IGUI_invpanel_unpack"));
    self.contextButton1.mode = "unpack";
    self.contextButton3:setVisible(false);
    if count == 1 then
      self.contextButton2:setTitle(getText("ContextMenu_Drop"));
      self.contextButton2.mode = "drop";
    else
      self.contextButton2:setTitle(getText("IGUI_invpanel_drop_all"));
      self.contextButton2.mode = "drop";
      self.contextButton3:setTitle(getText("IGUI_invpanel_drop_one"));
      self.contextButton3.mode = "drop1";
      --            self.contextButton3:setVisible(true);
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
        if not fav then
          self.contextButton2:setVisible(true);
          if count ~= 1 and not firstFav then
            self.contextButton3:setVisible(true);
          end
        end
      else
        if not self.items[y]:isFavorite() then
          self.contextButton2:setVisible(true);
          self.contextButton3:setVisible(true);
        end
      end
      self.contextButton1:setVisible(true);


    elseif self.inventory == getSpecificPlayer(self.player):getInventory() then
      self.contextButton2:setVisible(false);
      if count == 1 then
        self.contextButton1:setTitle(getText("ContextMenu_Drop"));
        self.contextButton1.mode = "drop";
      else
        self.contextButton1:setTitle(getText("IGUI_invpanel_drop_all"));
        self.contextButton1.mode = "drop";
        self.contextButton2:setTitle(getText("IGUI_invpanel_drop_one"));
        self.contextButton2.mode = "drop1";
        --            self.contextButton2:setVisible(true);
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
          if not fav then
            self.contextButton1:setVisible(true);
            if count ~= 1 and not firstFav then
              self.contextButton2:setVisible(true);
            end
          end

          if instanceof(self.items[y].items[1], "Moveable") then
            self.contextButton1:setVisible(false);
            self.contextButton2:setVisible(false);
          end
        else
          if not self.items[y]:isFavorite() then
            self.contextButton1:setVisible(true);
            if count ~= 1 then
              self.contextButton2:setVisible(true);
            end
          end
        end

        if instanceof(self.items[y], "Moveable") then
          self.contextButton1:setVisible(false);
          self.contextButton2:setVisible(false);
        end
      else
        self.contextButton1:setVisible(true);
        if count == 1 then
          self.contextButton1:setTitle(getText("ContextMenu_Grab"));
          self.contextButton1.mode = "grab";
          self.contextButton2:setVisible(false);
        else
          self.contextButton1:setTitle(getText("ContextMenu_Grab_all"));
          self.contextButton1.mode = "grab";
          self.contextButton2:setTitle(getText("ContextMenu_Grab_one"));
          self.contextButton2.mode = "grab1";
          self.contextButton2:setVisible(true);
        end


      end

      local ypos = ((y - 1) * self.itemHgt) + 16;

      ypos = ypos + self:getYScroll();

      self.contextButton1:setX(self.column3);
      self.contextButton1:setY(ypos);

      self.contextButton2:setX(self.column3 + self.contextButton1:getWidth() + 1);
      self.contextButton2:setY(ypos);


      self.contextButton3:setX(self.column3 + self.contextButton1:getWidth() + 1 + self.contextButton2:getWidth() + 1);
      self.contextButton3:setY(ypos);

      self.buttonOption = y;
    end

    function ISInventoryPane:toggleStove()
      local stove = self.inventory:getParent();
      stove:Toggle();
      return stove:Activated();
    end

    function ISInventoryPane:lootAll()
      --print("Looting all in container")
      local it = self.inventory:getItems();
      --print("Got item list.")
      for i = 0, it:size() - 1 do
        local item = it:get(i);
        ISTimedActionQueue.add(ISInventoryTransferAction:new(getSpecificPlayer(self.player), item, item:getContainer(), getPlayerInventory(self.player).inventory));
      end
      self.selected = {};
      getPlayerLoot(self.player).inventoryPane.selected = {};
      getPlayerInventory(self.player).inventoryPane.selected = {};
    end

    function ISInventoryPane:transferAll()
      local it = self.inventory:getItems();
      for i = 0, it:size() - 1 do
        local item = it:get(i);
        if not item:isEquipped() and item:getType() ~= "KeyRing" then
          ISTimedActionQueue.add(ISInventoryTransferAction:new(getSpecificPlayer(self.player), item, item:getContainer(), getPlayerLoot(self.player).inventory));
        end
      end
      self.selected = {};
      getPlayerLoot(self.player).inventoryPane.selected = {};
      getPlayerInventory(self.player).inventoryPane.selected = {};
    end

    function ISInventoryPane:onMouseMove(dx, dy)
      if self.player ~= 0 then return end

      local x = self:getMouseX();
      local y = self:getMouseY();

      self.contextButton1:setVisible(false);
      self.contextButton2:setVisible(false);
      self.contextButton3:setVisible(false);

      if(self.draggingMarquis) then
        local x2 = self.draggingMarquisX;
        local y2 = self.draggingMarquisY;

        if (x2 < x) then
          local xt = x;
          x = x2;
          x2 = xt;
        end
        if (y2 < y) then
          local yt = y;
          y = y2;
          y2 = yt;
        end

        if x > self.column3 then
          return;
        end

        local startY = math.floor((y - 16) / self.itemHgt) + 1;
        local endY = math.floor((((y2) - 16) / self.itemHgt)) + 1;

        if(startY < 1) then
          startY = 1;
        end

        self.selected = {}
        local c = 1;
        for i = startY, endY do
          --print("selected: "..i);
          self.selected[i] = self.items[i];
          if self.items[i] ~= nil then
            if not instanceof(self.items[i], "InventoryItem") and not self.collapsed[self.items[i].name] then
              local scount = 0;
              for k, v in ipairs(self.items[i].items) do
                if scount > 0 then
                  self.selected[i + scount] = v;
                end
                scount = scount + 1;
              end
            end
            c = c + 1;
          end
        end
      else
        if self.dragging == nil and x >= 0 and y >= 0 and x >= self.column3 and not isShiftKeyDown() then
          y = y - 16;
          y = y / self.itemHgt;
          y = math.floor(y + 1);
          local topOfRow = ((y - 1) * self.itemHgt) + self:getYScroll() + 16
          if self.items[y] and topOfRow >= 16 then
            self:doButtons(y);
          end
        end
        if self.dragging == nil and x >= 0 and y >= 0 and x < self.column3 then
          y = y - 16;
          y = y / self.itemHgt;
          y = math.floor(y + 1);
          self.mouseOverOption = y;
          --[[
			local item = nil;
			if self.items[self.mouseOverOption] then
				if not instanceof(self.items[self.mouseOverOption], "InventoryItem") then
					for k, v in ipairs(self.items[self.mouseOverOption].items) do
						item = v;
						break;
					end
				else
					item = self.items[self.mouseOverOption];
				end
			end
			if item then
				if self.toolRender and self.toolRender ~= nil then
					self.toolRender:setItem(item);
					-- don't show the tooltip if the context menu is showing
					if getPlayerContextMenu(self.player):getIsVisible() then
						self.toolRender:setVisible(false);
					else
						self.toolRender:setVisible(true);
						self.toolRender:addToUIManager();
						self.toolRender:bringToTop()
					end
				else
					self.toolRender = ISToolTipInv:new(item);
					self.toolRender:initialise();
					self.toolRender:addToUIManager();
					-- don't show the tooltip if the context menu is showing
					if not getPlayerContextMenu(self.player):getIsVisible() then
						self.toolRender:setVisible(true);
					end
					self.toolRender:setOwner(self)
					self.toolRender:setCharacter(getSpecificPlayer(self.player))
				end
			elseif self.toolRender then
				self.toolRender:removeFromUIManager();
				self.toolRender:setVisible(false);
				self.toolRender = nil;
			end
]]--
          --     local info = ISInfoWindow.getInstance();
          --   if instanceof(self.items[self.mouseOverOption], "InventoryItem") then
          --     info:setInfo(self.items[self.mouseOverOption]);
          --  else
          --     info:setInfo(self.items[self.mouseOverOption].items[1]);
          -- end

        else
          self.mouseOverOption = 0;
          --[[
			if self.toolRender then
				self.toolRender:removeFromUIManager();
				self.toolRender:setVisible(false);
				self.toolRender = nil;
			end
]]--
        end

      end
      --[[
	if self.toolRender and not self.doController then
		self.toolRender:setX(getMouseX());
		self.toolRender:setY(getMouseY());
	end
]]--
      if self.dragging and not self.dragStarted and (math.abs(x - self.draggingX) > 4 or math.abs(y - self.draggingY) > 4) then
        self.dragStarted = true
      end
    end

    function ISInventoryPane:updateTooltip()
      local item = nil
      if self.doController and self.joyselection then
        if self.joyselection < 0 then self.joyselection = #self.items - 1 end
        if self.joyselection >= #self.items then self.joyselection = 0 end
        item = self.items[self.joyselection + 1]
      end
      if not self.doController and not self.dragging and not self.draggingMarquis and self:isMouseOver() then
        local x = self:getMouseX()
        local y = self:getMouseY()
        if x < self.column3 and y + self:getYScroll() >= 16 then
          y = y - 16
          y = y / self.itemHgt
          self.mouseOverOption = math.floor(y + 1)
          item = self.items[self.mouseOverOption]
        end
      end
      if item and not instanceof(item, "InventoryItem") then
        for k, v in ipairs(item.items) do
          item = v
          break
        end
      end
      if item and self.toolRender and item == self.toolRender.item and self.toolRender:getIsVisible() then
        return
      end
      if item then
        if self.toolRender then
          self.toolRender:setItem(item)
          if getPlayerContextMenu(self.player):getIsVisible() then
            self.toolRender:setVisible(false)
          else
            self.toolRender:setVisible(true)
            self.toolRender:addToUIManager()
            self.toolRender:bringToTop()
          end
        else
          self.toolRender = ISToolTipInv:new(item)
          self.toolRender:initialise()
          self.toolRender:addToUIManager()
          if not getPlayerContextMenu(self.player):getIsVisible() then
            self.toolRender:setVisible(true)
          end
          self.toolRender:setOwner(self)
          self.toolRender:setCharacter(getSpecificPlayer(self.player))
          --			self.toolRender:setX(getPlayerScreenLeft(self.player) + 60)
          --			self.toolRender:setY(getPlayerScreenTop(self.player) + 60)
          self.toolRender:setX(self:getAbsoluteX() + self.column2)
          self.toolRender:setY(self:getAbsoluteY() - 150)
          self.toolRender.followMouse = not self.doController
        end
        if not self.doController then
          --			self.toolRender:setX(getMouseX())
          --			self.toolRender:setY(getMouseY())
        end
      elseif self.toolRender then
        self.toolRender:removeFromUIManager()
        self.toolRender:setVisible(false)
        self.toolRender = nil
      end
    end

    --************************************************************************--
    --** ISInventoryPane:onMouseUpOutside
    --**
    --************************************************************************--
    function ISInventoryPane:onMouseDownOutside(x, y)
      self.dragging = nil;
      self.selected = {};
    end

    function ISInventoryPane:onMouseUpOutside(x, y)
      self.draggingMarquis = false
      self.previousMouseUp = self.mouseOverOption
      self.selected = {};
    end

    function ISInventoryPane:onMouseDoubleClick(x, y)
      if not isShiftKeyDown() and self.items and self.mouseOverOption and self.previousMouseUp == self.mouseOverOption then
        local playerInv = getPlayerInventory(self.player).inventory;
        local lootInv = getPlayerLoot(self.player).inventory;
        local item = self.items[self.mouseOverOption];
        if item and not instanceof(item, "InventoryItem") then
          -- expand or collapse...
          if x < self.column2 then
            self.collapsed[item.name] = not self.collapsed[item.name];
            self:refreshContainer();
            return;
          end
          if item.items then
            for k, v in ipairs(item.items) do
              if k ~= 1 and v:getContainer() ~= playerInv then
                ISTimedActionQueue.add(ISInventoryTransferAction:new(getSpecificPlayer(self.player), v, v:getContainer(), playerInv));
                --~                 elseif v:getContainer() == playerInv and v:getCategory() == "Food" then
                --~ 					ISInventoryPaneContextMenu.eatItem(v, getSpecificPlayer(self.player));
                --~                     ISTimedActionQueue.add(ISInventoryTransferAction:new(getSpecificPlayer(self.player), v, v:getContainer(), lootInv));
                --~ 					break;
                --~ 				elseif ISInventoryPaneContextMenu.startWith(v:getType(), "Pills") then
                --~ 					ISInventoryPaneContextMenu.takePill(v, getSpecificPlayer(self.player));
                --~ 					break;
              end
            end
          end
        elseif item and item:getContainer() ~= playerInv then
          ISTimedActionQueue.add(ISInventoryTransferAction:new(getSpecificPlayer(self.player), item, item:getContainer(), playerInv));
          --~         elseif v:getContainer() == playerInv and item:getCategory() == "Food" then
          --~ 			ISInventoryPaneContextMenu.eatItem(item, getSpecificPlayer(self.player));
          --~ 			ISTimedActionQueue.add(ISInventoryTransferAction:new(getSpecificPlayer(self.player), item, item:getContainer(), lootInv));
          --~ 		elseif ISInventoryPaneContextMenu.startWith(item:getType(), "Pills") then
          --~ 			ISInventoryPaneContextMenu.takePill(item, getSpecificPlayer(self.player));
        end
        self.previousMouseUp = nil;
      end
    end

    function ISInventoryPane:onMouseUp(x, y)
      if self.player ~= 0 then return end

      self.previousMouseUp = self.mouseOverOption;
      if( not isShiftKeyDown()and not isCtrlKeyDown() and x >= self.column2 and x == self.downX and y == self.downY) and self.mouseOverOption ~= 0 and self.items[self.mouseOverOption] ~= nil then
        self.selected = {};
        --~         print ("Selecting "..self.mouseOverOption)
        self.selected[self.mouseOverOption] = self.items[self.mouseOverOption];
        --~         print ("Selected "..self.mouseOverOption)
        if not instanceof(self.items[self.mouseOverOption], "InventoryItem") and not self.collapsed[self.items[self.mouseOverOption].name] then
          --~             print ("Adding header to selection");
          local scount = 0;
          for k, v in ipairs(self.items[self.mouseOverOption].items) do
            --~                 print ("Adding item.");
            if scount > 0 then
              self.selected[self.mouseOverOption + scount] = v;
            end
            scount = scount + 1;
          end

        end

      end

      if ISMouseDrag.dragging ~= nil and ISMouseDrag.draggingFocus ~= self and ISMouseDrag.draggingFocus ~= nil then


        --print ("found to be dragging");
        local counta = 1;
        if self:canPutIn() then
          for i, v in ipairs(ISMouseDrag.dragging) do

            counta = 1;
            if instanceof(v, "InventoryItem") then
              ----print("Adding "..v:getName().." to queue.")
              if v:getContainer() == nil then
                --print("Item is not in container.")
              end
              if(not self.inventory:isInside(v)) then
                --InventoryTransferTimedAction.addToQueue(getSpecificPlayer(self.player), v, v:getContainer(), self.inventory);
                ISTimedActionQueue.add(ISInventoryTransferAction:new(getSpecificPlayer(self.player), v, v:getContainer(), self.inventory));
              end

            else
              -- collapsed, so transfer all the ones inside it.
              if v.invPanel.collapsed[v.name] then
                --print("found collapsed!")
                counta = 1;
                for i2, v2 in ipairs(v.items) do
                  --print("moving item "..counta)
                  -- only transfer if larger than one, since we have our dummy repeated object in there.
                  if (not self.inventory:isInside(v2)) and counta > 1 then
                    --InventoryTransferTimedAction.addToQueue(getSpecificPlayer(self.player), v, v:getContainer(), self.inventory);
                    ISTimedActionQueue.add(ISInventoryTransferAction:new(getSpecificPlayer(self.player), v2, v2:getContainer(), self.inventory));
                  end
                  counta = counta + 1;
                end
              else
                --print("not collapsed!")
              end
            end
          end
          self.selected = {};
          getPlayerLoot(self.player).inventoryPane.selected = {};
          getPlayerInventory(self.player).inventoryPane.selected = {};
        end
        ISMouseDrag.draggingFocus:onMouseUp(0, 0);
        ISMouseDrag.draggingFocus = nil;
        ISMouseDrag.dragging = nil;
        return;
      end

      self.dragging = nil;
      ISMouseDrag.dragging = nil;
      ISMouseDrag.draggingFocus = nil;

      if x >= 0 and y >= 0 and x < self.column3 then
        y = y - 16;
        y = y / self.itemHgt;
        y = math.floor(y + 1);
        self.mouseOverOption = y;
      end
      self.draggingMarquis = false;

      return true;
    end


    function ISInventoryPane:canPutIn()

      if self.inventory == nil then
        return false;
      end
      if self.inventory:getType() == "floor" then
        return true;
      end

      if self.inventory:getParent() == getSpecificPlayer(self.player) then
        return true;
      end

      -- we count the total weight of our container
      local totalWeight = ISInventoryPage.loadWeight(self.inventory);
      --~ 	self.mouseOverButton.inventory:getWeight();
      local counted = {};
      for i, v in ipairs(ISMouseDrag.dragging) do
        if instanceof(v, "InventoryItem") then
          -- you can't draw the container in himself
          --~ 			print(self.mouseOverButton.inventory);
          --~ 			print(v);
          if (self.inventory:isInside(v)) then
            return false;
          end
          local inv = self.inventory;
          if self.mouseOverButton and self.mouseOverButton.inventory then
            inv = self.mouseOverButton.inventory;
          end
          if inv:getOnlyAcceptCategory() and v:getCategory() ~= inv:getOnlyAcceptCategory() then
            return false;
          end
          if not counted[v] then
            counted[v] = true;
            totalWeight = totalWeight + v:getUnequippedWeight();
          end
          --~ 			totalWeight = totalWeight + v:getActualWeight();
        else
          for i2, v2 in ipairs(v.items) do
            --~ 				print("notinstanceitem");
            --~ 				print(v2);
            --~ 				print(self.mouseOverButton.inventory);
            -- you can't draw the container in himself
            if (self.inventory:isInside(v2)) then
              return false;
            end
            local inv = self.inventory;
            if self.mouseOverButton and self.mouseOverButton.inventory then
              inv = self.mouseOverButton.inventory;
            end
            if inv:getOnlyAcceptCategory() and v2:getCategory() ~= inv:getOnlyAcceptCategory() then
              return false;
            end
            -- first is a dummy
            if not counted[v2] then
              counted[v2] = true;
              totalWeight = totalWeight + v2:getUnequippedWeight();
            end
          end
        end
        --~ 		print(#v.items .. " " .. totalWeight);
      end
      if totalWeight and self.parent.capacity and totalWeight > self.parent.capacity then
        return false;
      else
        return true;
      end
    end

    function ISInventoryPane:doJoypadExpandCollapse()
      if not self.joyselection then return end
      if not self.items or not self.items[self.joyselection + 1] then return end
      if not instanceof(self.items[self.joyselection + 1], "InventoryItem") then
        self.collapsed[self.items[self.joyselection + 1].name] = not self.collapsed[self.items[self.joyselection + 1].name]
        self:refreshContainer()
      end
    end

    function ISInventoryPane:doGrabOnJoypadSelected()
      if getSpecificPlayer(self.player):isAsleep() then return end

      if #self.items == 0 then return end

      if self.joyselection ~= nil and self.doController then
        self.selected = {};
        --~         print ("Selecting "..self.mouseOverOption)
        self.selected[self.joyselection + 1] = self.items[self.joyselection + 1];
        --~         print ("Selected "..self.mouseOverOption)
        if not instanceof(self.items[self.joyselection + 1], "InventoryItem") and not self.collapsed[self.items[self.joyselection + 1].name] then
          --~             print ("Adding header to selection");
          local scount = 0;
          for k, v in ipairs(self.items[self.joyselection + 1].items) do
            --~                 print ("Adding item.");
            if scount > 0 then
              self.selected[self.joyselection + 1 + scount] = v;
            end
            scount = scount + 1;
          end

        end

      end

      local isInInv = false;
      if self.inventory:isInCharacterInventory(getSpecificPlayer(self.player)) then
        isInInv = true;
      end
      local contextMenuItems = {}
      for k, v in ipairs(self.items) do
        if self.selected[k] ~= nil then
          if instanceof(v, "InventoryItem") or self.collapsed[v.name] then
            table.insert(contextMenuItems, v);
          end
        end
      end
      if not isInInv then
        ISInventoryPaneContextMenu.onGrabItems(contextMenuItems, self.player);
      else
        ISInventoryPaneContextMenu.onDropItems(contextMenuItems, self.player);

      end
    end
    function ISInventoryPane:doContextOnJoypadSelected()
      if getSpecificPlayer(self.player):isAsleep() then return end

      if #self.items == 0 then return end

      if self.joyselection ~= nil and self.doController then
        self.selected = {};
        --~         print ("Selecting "..self.mouseOverOption)
        self.selected[self.joyselection + 1] = self.items[self.joyselection + 1];
        --~         print ("Selected "..self.mouseOverOption)
        if not instanceof(self.items[self.joyselection + 1], "InventoryItem") and not self.collapsed[self.items[self.joyselection + 1].name] then
          --~             print ("Adding header to selection");
          local scount = 0;
          for k, v in ipairs(self.items[self.joyselection + 1].items) do
            --~                 print ("Adding item.");
            if scount > 0 then
              self.selected[self.joyselection + 1 + scount] = v;
            end
            scount = scount + 1;
          end

        end

      end

      local isInInv = false;
      if self.inventory:isInCharacterInventory(getSpecificPlayer(self.player)) then
        isInInv = true;
      end
      local contextMenuItems = {}
      for k, v in ipairs(self.items) do
        if self.selected[k] ~= nil then
          if instanceof(v, "InventoryItem") or self.collapsed[v.name] then
            table.insert(contextMenuItems, v);
          end
        end
      end

      local menu = ISInventoryPaneContextMenu.createMenu(self.player, isInInv, contextMenuItems, self:getAbsoluteX() + 64, self:getAbsoluteY() + 8 + (self.joyselection * self.itemHgt) + self:getYScroll());
      menu.origin = self.inventoryPage;
      menu.mouseOver = 1;
      setJoypadFocus(self.player, menu)

    end

    function ISInventoryPane:onRightMouseUp(x, y)

      if self.player ~= 0 then return end

      if self.selected == nil then
        self.selected = {}
      end

      local selectedCount = 1;
      for i, k in pairs(self.selected) do
        selectedCount = selectedCount + 1;
      end

      if self.mouseOverOption ~= 0 and self.items[self.mouseOverOption] ~= nil and self.selected[self.mouseOverOption] == nil then
        self.selected = {};
        --~         print ("Selecting "..self.mouseOverOption)
        self.selected[self.mouseOverOption] = self.items[self.mouseOverOption];
        --~         print ("Selected "..self.mouseOverOption)
        if not instanceof(self.items[self.mouseOverOption], "InventoryItem") and not self.collapsed[self.items[self.mouseOverOption].name] then
          --~             print ("Adding header to selection");
          local scount = 0;
          for k, v in ipairs(self.items[self.mouseOverOption].items) do
            --~                 print ("Adding item.");
            if scount > 0 then
              self.selected[self.mouseOverOption + scount] = v;
            end
            scount = scount + 1;
          end

        end

      end

      local isInInv = false;
      if self.inventory:isInCharacterInventory(getSpecificPlayer(self.player)) then
        isInInv = true;
      end
      local contextMenuItems = {}
      for k, v in ipairs(self.items) do
        if self.selected[k] ~= nil then
          if instanceof(v, "InventoryItem") or self.collapsed[v.name] then
            table.insert(contextMenuItems, v);
          end
        end
      end

      if self.toolRender then
        self.toolRender:setVisible(false)
      end

      ISInventoryPaneContextMenu.createMenu(self.player, isInInv, contextMenuItems, self:getAbsoluteX() + x, self:getAbsoluteY() + y + self:getYScroll());

      return true;
    end

    function ISInventoryPane:onMouseDown(x, y)

      if self.player ~= 0 then return true end

      getSpecificPlayer(self.player):nullifyAiming();

      local count = 0;

      self.downX = x;
      self.downY = y;

      if self.selected == nil then
        self.selected = {}
      end

      if self.mouseOverOption ~= 0 and self.items[self.mouseOverOption] ~= nil then

        -- expand or collapse...
        if x < self.column2 then

          if not instanceof(self.items[self.mouseOverOption], "InventoryItem") then
            self.collapsed[self.items[self.mouseOverOption].name] = not self.collapsed[self.items[self.mouseOverOption].name];
            self:refreshContainer();
            self.selected = {};
            return;
          end
        end
        if not isShiftKeyDown() and not isCtrlKeyDown() and self.selected[self.mouseOverOption] == nil then
          self.selected = {};
          self.firstSelect = nil;
        end

        if not isShiftKeyDown() then
          self.firstSelect = self.mouseOverOption;
          if isCtrlKeyDown() then
            if self.selected[self.mouseOverOption] then
              self.selected[self.mouseOverOption] = nil;
            else
              self.selected[self.mouseOverOption] = self.items[self.mouseOverOption];
            end
          else
            self.selected[self.mouseOverOption] = self.items[self.mouseOverOption];
          end
        end
        if isShiftKeyDown() then
          if self.firstSelect then
            self.selected = {};
            if self.firstSelect < self.mouseOverOption then
              for i = self.firstSelect, self.mouseOverOption do
                self.selected[i] = self.items[i];
              end
            else
              for i = self.mouseOverOption, self.firstSelect do
                self.selected[i] = self.items[i];
              end
            end
          else
            self.firstSelect = self.mouseOverOption;
            self.selected[self.mouseOverOption] = self.items[self.mouseOverOption];
          end
        end
        --		if isShiftKeyDown() and self.selected[self.mouseOverOption] then
        --			self.selected[self.mouseOverOption] = nil
        --        else
        --            self.selected[self.mouseOverOption] =  self.items[self.mouseOverOption];
        --		end
        --~         print ("Selected "..self.mouseOverOption)
        if not instanceof(self.items[self.mouseOverOption], "InventoryItem") and not self.collapsed[self.items[self.mouseOverOption].name] then
          --~             print ("Adding header to selection");
          local scount = 0;
          for k, v in ipairs(self.items[self.mouseOverOption].items) do
            --~                 print ("Adding item.");
            if scount > 0 then
              self.selected[self.mouseOverOption + scount] = v;
            end
            scount = scount + 1;
          end

        end

        self.dragging = self.mouseOverOption;
        self.draggingX = x;
        self.draggingY = y;
        self.dragStarted = false
        --print ("Dragging "..self.selected);
        ISMouseDrag.dragging = {}
        ----print(self.selected[self.mouseOverOption]);
        for i, v in ipairs(self.items) do
          if self.selected[count + 1] ~= nil then
            table.insert(ISMouseDrag.dragging, v);
          end
          count = count + 1;
        end
        ISMouseDrag.draggingFocus = self;
        return;
      end
      if not isShiftKeyDown() and not isCtrlKeyDown() then
        self.selected = {};
        self.firstSelect = nil;
      end

      if self.dragging == nil and x >= 0 and y >= 0 and (x <= self.column3 and y <= self:getScrollHeight() - self.itemHgt) then

      elseif count == 0 then
        self.draggingMarquis = true;
        self.draggingMarquisX = x;
        self.draggingMarquisY = y;
        self.dragging = nil;
        ISMouseDrag.dragging = nil;
        ISMouseDrag.draggingFocus = nil;


      end

      if x < self.column2 and y < 16 then
        return false;
      end
      return true;
    end

    function ISInventoryPane:updateSmoothScrolling()
      if not self.smoothScrollTargetY or #self.items == 0 then return end
      local dy = self.smoothScrollTargetY - self.smoothScrollY
      local maxYScroll = self:getScrollHeight() - self:getHeight()
      local frameRateFrac = 30 / getPerformance():getFramerate()
      local itemHeightFrac = 160 / (self:getScrollHeight() / #self.items)
      local targetY = self.smoothScrollY + dy * math.min(0.5, 0.25 * frameRateFrac * itemHeightFrac)
      if targetY > 0 then targetY = 0 end
      if targetY < - maxYScroll then targetY = -maxYScroll end
      if math.abs(targetY - self.smoothScrollY) > 0.1 then
        self:setYScroll(targetY)
        self.smoothScrollY = targetY
      else
        self:setYScroll(self.smoothScrollTargetY)
        self.smoothScrollTargetY = nil
        self.smoothScrollY = nil
      end
    end

    --************************************************************************--
    --** ISInventoryPane:render
    --**
    --************************************************************************--
    function ISInventoryPane:prerender()
      local mouseY = self:getMouseY()
      self:updateSmoothScrolling()
      if mouseY ~= self:getMouseY() and self:isMouseOver() then
        self:onMouseMove(0, self:getMouseY() - mouseY)
      end

      self.nameHeader.maximumWidth = self.width - self.typeHeader.minimumWidth - self.column2
      self.typeHeader.maximumWidth = self.width - self.nameHeader.minimumWidth - self.column2 + 1
      --self:drawRectStatic(0, 0, self.width, self.height, self.backgroundColor.a, self.backgroundColor.r, self.backgroundColor.g, self.backgroundColor.b);
      --	self:drawRectStatic(0, 0, self.width, 1, self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b);
      --	self:drawRectStatic(0, self.height-1, self.width, 1, self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b);
      --	self:drawRectStatic(0, 0, 1, self.height, self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b);
      --	self:drawRectStatic(0+self.width-1, 0, 1, self.height, self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b);
      self:setStencilRect(0, 0, self.width - 1, self.height - 1);
      if self.mode == "icons" then
        self:rendericons();
      elseif self.mode == "details" then
        self:renderdetails(false);
      end

      self:updateScrollbars();

    end

    function ISInventoryPane:rendericons()
      local xpad = 10;
      local ypad = 10;
      local iw = 40;
      local ih = 40;
      local xmax = math.floor((self.width - (xpad * 2)) / iw);
      local ymax = math.floor((self.height - (ypad * 2)) / ih);
      local xcount = 0;
      local ycount = 0;
      local it = self.inventory:getItems();
      for i = 0, it:size() - 1 do
        local item = it:get(i);
        self:drawTexture(item:getTex(), (xcount * iw) + xpad + 4, (ycount * ih) + ypad + 4, 1, 1, 1, 1);

        xcount = xcount + 1;

        if xcount >= xmax then
          xcount = 0;
          ycount = ycount + 1;
        end
      end
    end

    function ISInventoryPane:update()

      if self.doController then
        --print("do controller!")
        self.selected = {}
        if self.joyselection == nil then
          self.joyselection = 0;
        end
      end
      self:updateTooltip()


      local remove = {}

      for i, v in pairs(self.selected) do
        if instanceof(v, "InventoryItem") then
          if v:getContainer() ~= self.inventory then
            remove[i] = i;
          end
        end
      end

      for i, v in pairs(remove) do
        self.selected[v] = nil;
      end



      -- Make it select the header if all sub items in expanded item are selected.
      for i, v in ipairs(self.items) do
        if not instanceof(v, "InventoryItem") and self.selected[i] == nil and not self.collapsed[v.name] then
          local count = i;
          local anyNot = false;
          local skip = false;
          for k2, v2 in ipairs(v.items) do
            if not skip then
              skip = true;
            else
              count = count + 1;
              if self.selected[count] == nil then
                anyNot = true;
              end
            end
          end

          if not anyNot then
            self.selected[i] = v;
          end
        end
      end

      -- If the user was dragging items from this pane and the mouse wasn't released over a valid drop location,
      -- then we must clear the drag info.  Additionally, if the mouse was released outside any UIElement, then
      -- we will drop the items onto the floor (unless this pane is displaying the floor container).
      -- NOTE: This only works because update() is called after all the mouse-event handling, so other UIElements
      -- have already had a chance to accept the drag.
      if ISMouseDrag.dragging ~= nil and ISMouseDrag.draggingFocus == self and not isMouseButtonDown(0) then
        local dragContainsMovables = false;
        local dragContainsNonMovables = false;
        local mx = getMouseX()
        local my = getMouseY()
        local uis = UIManager.getUI()
        local mouseOverUI
        for i = 0, uis:size() - 1 do
          local ui = uis:get(i)
          if ui:isVisible() and mx >= ui:getX() and my >= ui:getY() and
          mx < ui:getX() + ui:getWidth() and my < ui:getY() + ui:getHeight() then
            mouseOverUI = ui
            break
          end
        end
        if self.inventory:getType() ~= "floor" and not mouseOverUI then
          for i, v in ipairs(ISMouseDrag.dragging) do
            if instanceof(v, "InventoryItem") then
              if not self.inventory:isInside(v) then
                if not instanceof(v, "Moveable") then
                  ISTimedActionQueue.add(ISInventoryTransferAction:new(getSpecificPlayer(self.player), v, v:getContainer(), ISInventoryPage.floorContainer[self.player + 1]))
                  dragContainsNonMovables = true;
                else
                  dragContainsMovables = dragContainsMovables or v;
                end
              end
            else
              if v.invPanel.collapsed[v.name] then
                local counta = 1;
                for i2, v2 in ipairs(v.items) do
                  if (not self.inventory:isInside(v2)) and counta > 1 then
                    if not instanceof(v2, "Moveable") then
                      ISTimedActionQueue.add(ISInventoryTransferAction:new(getSpecificPlayer(self.player), v2, v2:getContainer(), ISInventoryPage.floorContainer[self.player + 1]))
                      dragContainsNonMovables = true;
                    else
                      dragContainsMovables = dragContainsMovables or v2;
                    end
                  end
                  counta = counta + 1
                end
              end
            end
          end
          self.selected = {}
          getPlayerLoot(self.player).inventoryPane.selected = {}
          getPlayerInventory(self.player).inventoryPane.selected = {}
        end
        self.dragging = nil
        ISMouseDrag.dragging = nil
        ISMouseDrag.draggingFocus = nil

        if dragContainsMovables and not dragContainsNonMovables then
          local mo = ISMoveableCursor:new(getSpecificPlayer(self.player));
          getCell():setDrag(mo, mo.player);
          mo:setMoveableMode("place");
          mo:tryInitialItem(dragContainsMovables);
        end
      end

      if isCtrlKeyDown() and isKeyDown(Keyboard.KEY_A) then
        if self.inventoryPage:isMouseOver() then
          local selectAllItems = false;
          if not self.inventoryPage.isCollapsed then
            for k, v in pairs(self.items) do
              if self.selected[k] ~= nil then
                selectAllItems = true
                break;
              end
            end

            if selectAllItems then
              self.selected = {}
              for k, v in pairs(self.items) do
                self.selected[k] = v
              end
              getCore():setIsSelectingAll(true)
            end
          end
        else
          self.selected = {}
        end
      end

    end

    function ISInventoryPane:refreshContainer()
      self.itemslist = {}
      self.itemindex = {}

      if self.collapsed == nil then
        self.collapsed = {}
      end
      local playerObj = getSpecificPlayer(self.player)
      local it = self.inventory:getItems();
      for i = 0, it:size() - 1 do
        local item = it:get(i);
        local itemName = item:getName();
        if instanceof(item, "Food") and item:getHerbalistType() and item:getHerbalistType() ~= "" then
          if playerObj:getKnownRecipes():contains("Herbalist") then
            if item:getHerbalistType() == "Berry" then
              itemName = (item:getPoisonPower() > 0) and getText("IGUI_PoisonousBerry") or getText("IGUI_Berry")
            end
            if item:getHerbalistType() == "Mushroom" then
              itemName = (item:getPoisonPower() > 0) and getText("IGUI_PoisonousMushroom") or getText("IGUI_Mushroom")
            end
          else
            if item:getHerbalistType() == "Berry" then
              itemName = getText("IGUI_UnknownBerry")
            end
            if item:getHerbalistType() == "Mushroom" then
              itemName = getText("IGUI_UnknownMushroom")
            end
          end
          if itemName ~= item:getName() then
            item:setName(itemName);
          end
        end
        local equipped = false
        if playerObj:isEquipped(item) then
          itemName = "equipped:"..itemName
          equipped = true
        elseif item:getType() == "KeyRing" and playerObj:getInventory():contains(item) then
          itemName = "keyring:"..itemName
          equipped = true
        end
        if self.itemindex[itemName] == nil then
          self.itemindex[itemName] = {};
          self.itemindex[itemName].items = {}
        end
        local ind = self.itemindex[itemName];
        ind.equipped = equipped

        table.insert(ind.items, item);

      end

      for k, v in pairs(self.itemindex) do

        if v ~= nil then
          table.insert(self.itemslist, v);
          local count = 1;
          for k2, v2 in ipairs(v.items) do
            if v2 == nil then
              table.remove(v.items, k2);
            else
              count = count + 1;
            end
          end
          v.count = count;
          v.invPanel = self;
          v.name = k -- v.items[1]:getName();
          v.cat = v.items[1]:getDisplayCategory() or v.items[1]:getCategory();
          if self.collapsed[v.name] == nil then
            self.collapsed[v.name] = true;
          end
        end
      end


      --print("Preparing to sort inv items");
      table.sort(self.itemslist, self.itemSortFunc );

      -- Adding the first item in list additionally at front as a dummy at the start, to be used in the details view as a header.
      for k, v in ipairs(self.itemslist) do
        local item = v.items[1];
        table.insert(v.items, 1, item);

      end

      -- if self.inventoryPage ~= nil then
      --     self.inventoryPage:refreshBackpacks();
      -- end
      self:updateScrollbars();
      self.inventory:setDrawDirty(false);
    end


    ISInventoryPane.highlightItem = nil;
    function ISInventoryPane:renderdetails(doDragged)

      self:updateScrollbars();

      self.items = {}
      if(self.inventory:isDrawDirty()) then
        self:refreshContainer();
      end

      local player = getSpecificPlayer(self.player)

      if not doDragged then
        -- background of item icon
        self:drawRectStatic(0, 0, self.column2, self.height, 0.6, 0, 0, 0);
      end
      local y = 0;
      local alt = false;
      if self.itemslist == nil then
        self:refreshContainer();
      end
      -- Go through all the stacks of items.
      for k, v in ipairs(self.itemslist) do
        local count = 1;
        -- Go through each item in stack..
        for k2, v2 in ipairs(v.items) do
          -- print("trace:a");
          local item = v2;
          local doIt = true;
          local xoff = 0;
          local yoff = 0;

          -- if its the first item, then store the category, otherwise the item
          if count == 1 then
            table.insert(self.items, v);
          else
            table.insert(self.items, item);
          end

          if instanceof(item, 'InventoryItem') then
            item:updateAge()
          end

          -- print("trace:b");
          local tex = item:getTex();
          if self.dragging ~= nil and self.selected[y + 1] ~= nil and self.dragStarted then
            xoff = self:getMouseX() - self.draggingX;
            yoff = self:getMouseY() - self.draggingY;
            if not doDragged then
              doIt = false;
            else
              self:suspendStencil();
            end
          else
            if doDragged then
              doIt = false;
            end
          end
          local topOfItem = y * self.itemHgt + self:getYScroll()
          if (topOfItem + self.itemHgt < 0) or (topOfItem > self:getHeight()) then
            doIt = false
          end
          -- print("trace:c");
          if doIt == true then
            -- print("trace:cc");
            --        print(count);
            if count == 1 then
              -- rect over the whole item line
              self:drawRect(1 + xoff, (y * self.itemHgt) + 16 + yoff, self:getWidth(), 1, 0.3, 0.0, 0.0, 0.0);
            end
            -- print("trace:d");

            -- do controller selection.
            if self.joyselection ~= nil and self.doController then
              --                    if self.joyselection < 0 then self.joyselection = (#self.itemslist) - 1; end
              --                    if self.joyselection >= #self.itemslist then self.joyselection = 0; end
              if self.joyselection == y then
                self:drawRect(1 + xoff, (y * self.itemHgt) + 16 + yoff, self:getWidth() - 1, self.itemHgt, 0.2, 0.2, 1.0, 1.0);
              end
            end
            -- print("trace:e");

            -- only do icon if header or dragging sub items without header.
            if tex ~= nil then
              local texDY = 1
              local texWH = math.min(self.itemHgt - 2, 32)
              local auxDXY = math.ceil(20 * self.texScale)
              if count == 1 then
                self:drawTextureScaledAspect(tex, 10 + xoff, (y * self.itemHgt) + 16 + texDY + yoff, texWH, texWH, 1, item:getR(), item:getG(), item:getB());
                if item == getSpecificPlayer(self.player):getPrimaryHandItem() or item == getSpecificPlayer(self.player):getSecondaryHandItem() or item == getSpecificPlayer(self.player):getClothingItem_Torso() or item == getSpecificPlayer(self.player):getClothingItem_Legs() or item == getSpecificPlayer(self.player):getClothingItem_Feet() or item == getSpecificPlayer(self.player):getClothingItem_Back() then
                  self:drawTexture(self.equippedItemIcon, (10 + auxDXY + xoff), (y * self.itemHgt) + 16 + auxDXY + yoff, 1, 1, 1, 1);
                end
                if item:isBroken() then
                  self:drawTexture(self.brokenItemIcon, (10 + auxDXY + xoff), (y * self.itemHgt) + 16 + auxDXY - 1 + yoff, 1, 1, 1, 1);
                end
                if instanceof(item, "Food") and item:isFrozen() then
                  self:drawTexture(self.frozenItemIcon, (10 + auxDXY + xoff), (y * self.itemHgt) + 16 + auxDXY - 1 + yoff, 1, 1, 1, 1);
                end
                if item:isTaintedWater() or player:isKnownPoison(item) then
                  self:drawTexture(self.poisonIcon, (10 + auxDXY + xoff), (y * self.itemHgt) + 16 + auxDXY - 1 + yoff, 1, 1, 1, 1);
                end
                if item:isFavorite() then
                  self:drawTexture(self.favoriteStar, (13 + auxDXY + xoff), (y * self.itemHgt) + auxDXY - 1 + yoff, 1, 1, 1, 1);
                end
              elseif v.count > 2 or (doDragged and count > 1 and self.selected[(y + 1) - (count - 1)] == nil) then
                self:drawTextureScaledAspect(tex, 10 + 16 + xoff, (y * self.itemHgt) + 16 + texDY + yoff, texWH, texWH, 0.3, item:getR(), item:getG(), item:getB());
                if item == getSpecificPlayer(self.player):getPrimaryHandItem() or item == getSpecificPlayer(self.player):getSecondaryHandItem() or item == getSpecificPlayer(self.player):getClothingItem_Torso() or item == getSpecificPlayer(self.player):getClothingItem_Legs() or item == getSpecificPlayer(self.player):getClothingItem_Feet() or item == getSpecificPlayer(self.player):getClothingItem_Back() then
                  self:drawTexture(self.equippedItemIcon, (10 + auxDXY + 16 + xoff), (y * self.itemHgt) + 16 + auxDXY + yoff, 1, 1, 1, 1);
                end
                if item:isBroken() then
                  self:drawTexture(self.brokenItemIcon, (10 + auxDXY + 16 + xoff), (y * self.itemHgt) + 16 + auxDXY - 1 + yoff, 1, 1, 1, 1);
                end
                if instanceof(item, "Food") and item:isFrozen() then
                  self:drawTexture(self.frozenItemIcon, (10 + auxDXY + 16 + xoff), (y * self.itemHgt) + 16 + auxDXY - 1 + yoff, 1, 1, 1, 1);
                end
                if item:isFavorite() then
                  self:drawTexture(self.favoriteStar, (13 + auxDXY + 16 + xoff), (y * self.itemHgt) + auxDXY - 1 + yoff, 1, 1, 1, 1);
                end
              end
            end
            -- print("trace:f");
            if count == 1 then
              if not doDragged then
                if not self.collapsed[v.name] then
                  self:drawTexture( self.treeexpicon, 2, (y * self.itemHgt) + 16 + 5 + yoff, 1, 1, 1, 0.8);
                  --                     self:drawText("+", 2, (y*18)+16+1+yoff, 0.7, 0.7, 0.7, 0.5);
                else
                  self:drawTexture( self.treecolicon, 2, (y * self.itemHgt) + 16 + 5 + yoff, 1, 1, 1, 0.8);
                end
              end
            end
            -- print("trace:g");

            if self.selected[y + 1] ~= nil and not self.highlightItem then -- clicked/dragged item
              if(((instanceof(item, "Food") or instanceof(item, "DrainableComboItem")) and item:getHeat() ~= 1) or item:getItemHeat() ~= 1) then
                if (((instanceof(item, "Food") or instanceof(item, "DrainableComboItem")) and item:getHeat() > 1) or item:getItemHeat() > 1) then
                  self:drawRect(1 + xoff, (y * self.itemHgt) + 16 + yoff, self.column4, self.itemHgt, 0.5, math.abs(item:getInvHeat()), 0.0, 0.0);
                else
                  self:drawRect(1 + xoff, (y * self.itemHgt) + 16 + yoff, self.column4, self.itemHgt, 0.5, 0.0, 0.0, math.abs(item:getInvHeat()));
                end
              else
                self:drawRect(1 + xoff, (y * self.itemHgt) + 16 + yoff, self:getWidth() - 1, self.itemHgt, 0.20, 1.0, 1.0, 1.0);
              end
            elseif self.mouseOverOption == y + 1 and not self.highlightItem then -- called when you mose over an element
              if(((instanceof(item, "Food") or instanceof(item, "DrainableComboItem")) and item:getHeat() ~= 1) or item:getItemHeat() ~= 1) then
                if (((instanceof(item, "Food") or instanceof(item, "DrainableComboItem")) and item:getHeat() > 1) or item:getItemHeat() > 1) then
                  self:drawRect(1 + xoff, (y * self.itemHgt) + 16 + yoff, self.column4, self.itemHgt, 0.3, math.abs(item:getInvHeat()), 0.0, 0.0);
                else
                  self:drawRect(1 + xoff, (y * self.itemHgt) + 16 + yoff, self.column4, self.itemHgt, 0.3, 0.0, 0.0, math.abs(item:getInvHeat()));
                end
              else
                self:drawRect(1 + xoff, (y * self.itemHgt) + 16 + yoff, self:getWidth() - 1, self.itemHgt, 0.05, 1.0, 1.0, 1.0);
              end
            else
              if count == 1 then -- normal background (no selected, no dragging..)
                -- background of item line
                if self.highlightItem and self.highlightItem == item:getType() then
                  if not self.blinkAlpha then self.blinkAlpha = 0.5; end
                  self:drawRect(1 + xoff, (y * self.itemHgt) + 16 + yoff, self.column4, self.itemHgt, self.blinkAlpha, 1, 1, 1);
                  if not self.blinkAlphaIncrease then
                    self.blinkAlpha = self.blinkAlpha - 0.05 * (30 / getPerformance():getFramerate());
                    if self.blinkAlpha < 0 then
                      self.blinkAlpha = 0;
                      self.blinkAlphaIncrease = true;
                    end
                  else
                    self.blinkAlpha = self.blinkAlpha + 0.05 * (30 / getPerformance():getFramerate());
                    if self.blinkAlpha > 0.5 then
                      self.blinkAlpha = 0.5;
                      self.blinkAlphaIncrease = false;
                    end
                  end
                else
                  if (((instanceof(item, "Food") or instanceof(item, "DrainableComboItem")) and item:getHeat() ~= 1) or item:getItemHeat() ~= 1) then
                    if (((instanceof(item, "Food") or instanceof(item, "DrainableComboItem")) and item:getHeat() > 1) or item:getItemHeat() > 1) then
                      if alt then
                        self:drawRect(1 + xoff, (y * self.itemHgt) + 16 + yoff, self.column4, self.itemHgt, 0.15, math.abs(item:getInvHeat()), 0.0, 0.0);
                      else
                        self:drawRect(1 + xoff, (y * self.itemHgt) + 16 + yoff, self.column4, self.itemHgt, 0.2, math.abs(item:getInvHeat()), 0.0, 0.0);
                      end
                    else
                      if alt then
                        self:drawRect(1 + xoff, (y * self.itemHgt) + 16 + yoff, self.column4, self.itemHgt, 0.15, 0.0, 0.0, math.abs(item:getInvHeat()));
                      else
                        self:drawRect(1 + xoff, (y * self.itemHgt) + 16 + yoff, self.column4, self.itemHgt, 0.2, 0.0, 0.0, math.abs(item:getInvHeat()));
                      end
                    end
                  else
                    if alt then
                      self:drawRect(1 + xoff, (y * self.itemHgt) + 16 + yoff, self.column4, self.itemHgt, 0.02, 1.0, 1.0, 1.0);
                    else
                      self:drawRect(1 + xoff, (y * self.itemHgt) + 16 + yoff, self.column4, self.itemHgt, 0.2, 0.0, 0.0, 0.0);
                    end
                  end
                end
              else
                if (((instanceof(item, "Food") or instanceof(item, "DrainableComboItem")) and item:getHeat() ~= 1) or item:getItemHeat() ~= 1) then
                  if (((instanceof(item, "Food") or instanceof(item, "DrainableComboItem")) and item:getHeat() > 1) or item:getItemHeat() > 1) then
                    self:drawRect(1 + xoff, (y * self.itemHgt) + 16 + yoff, self.column4, self.itemHgt, 0.2, math.abs(item:getInvHeat()), 0.0, 0.0);
                  else
                    self:drawRect(1 + xoff, (y * self.itemHgt) + 16 + yoff, self.column4, self.itemHgt, 0.2, 0.0, 0.0, math.abs(item:getInvHeat()));
                  end
                else
                  self:drawRect(1 + xoff, (y * self.itemHgt) + 16 + yoff, self.column4, self.itemHgt, 0.4, 0.0, 0.0, 0.0);
                end
              end
            end
            -- print("trace:h");

            -- divider between equipped and unequipped items
            if (self.collapsed[v.name] or k2 == #v.items) and k < #self.itemslist and not self.itemslist[k + 1].equipped and self.itemslist[k].equipped then
              self:drawRect(1, ((y + 1) * self.itemHgt) + 16 - 1, self.column4, 1, 0.2, 1, 1, 1);
            end

            if item:getJobDelta() > 0 and (count > 1 or self.collapsed[v.name]) then
              local displayWid = self.column4
              if self.vscroll and self.vscroll:getHeight() < self:getScrollHeight() then displayWid = displayWid - self.vscroll:getWidth() end
              self:drawRect(1 + xoff, (y * self.itemHgt) + 16 + yoff, displayWid * item:getJobDelta(), self.itemHgt, 0.2, 0.4, 1.0, 0.3);
            end
            -- print("trace:i");

            local textDY = (self.itemHgt - self.fontHgt) / 2

            --~ 				local redDetail = false;
            local itemName = item:getName();
            if count == 1 then

              -- if we're dragging something and want to put it in a container wich is full
              if doDragged and ISMouseDrag.dragging and #ISMouseDrag.dragging > 0 then
                local red = false;
                for i3, v3 in ipairs(ISMouseDrag.dragging) do
                  -- FIXME: set red=true at some point
                end
                if red then
                  if v.count > 2 then
                    self:drawText(itemName.." ("..(v.count - 1)..")", self.column2 + 8 + xoff, (y * self.itemHgt) + 16 + textDY + yoff, 0.7, 0.0, 0.0, 1.0, self.font);
                  else
                    self:drawText(itemName, self.column2 + 8 + xoff, (y * self.itemHgt) + 16 + textDY + yoff, 0.7, 0.0, 0.0, 1.0, self.font);
                  end
                else
                  if v.count > 2 then
                    self:drawText(itemName.." ("..(v.count - 1)..")", self.column2 + 8 + xoff, (y * self.itemHgt) + 16 + textDY + yoff, 0.7, 0.7, 0.7, 1.0, self.font);
                  else
                    self:drawText(itemName, self.column2 + 8 + xoff, (y * self.itemHgt) + 16 + textDY + yoff, 0.7, 0.7, 0.7, 1.0, self.font);
                  end
                end
              else
                local clipX = math.max(0, self.column2 + xoff)
                local clipY = math.max(0, (y * self.itemHgt) + 16 + yoff + self:getYScroll())
                local clipX2 = math.min(clipX + self.column3 - self.column2, self.width)
                local clipY2 = math.min(clipY + self.itemHgt, self.height)
                if clipX < clipX2 and clipY < clipY2 then
                  self:setStencilRect(clipX, clipY, clipX2 - clipX, clipY2 - clipY)
                  if v.count > 2 then
                    self:drawText(itemName.." ("..(v.count - 1)..")", self.column2 + 8 + xoff, (y * self.itemHgt) + 16 + textDY + yoff, 0.7, 0.7, 0.7, 1.0, self.font);
                  else
                    self:drawText(itemName, self.column2 + 8 + xoff, (y * self.itemHgt) + 16 + textDY + yoff, 0.7, 0.7, 0.7, 1.0, self.font);
                  end
                  self:clearStencilRect()
                  self:repaintStencilRect(clipX, clipY, clipX2 - clipX, clipY2 - clipY)
                end
              end
            end
            -- print("trace:j");

            --~ 				if self.mouseOverOption == y+1 and self.dragging and not self.parent:canPutIn(item) then
            --~ 							self:drawText(item:getName(), self.column2+8+xoff, (y*18)+16+1+yoff, 0.7, 0.0, 0.0, 1.0);
            --~ 						else

            if item:getJobDelta() > 0 then
              if (count > 1 or self.collapsed[v.name]) then
                if self.dragging == count then
                  self:drawText(item:getJobType(), self.column3 + 8 + xoff, (y * self.itemHgt) + 16 + textDY + yoff, 0.7, 0.0, 0.0, 1.0, self.font);
                else
                  self:drawText(item:getJobType(), self.column3 + 8 + xoff, (y * self.itemHgt) + 16 + textDY + yoff, 0.7, 0.7, 0.7, 1.0, self.font);
                end
              end

            else
              local redDetail = false;
              if count == 1 then
                if doDragged then
                  -- Don't draw the category when dragging
                elseif item:getDisplayCategory() then -- display the custom category set in items.txt
                  self:drawText(getText("IGUI_ItemCat_" .. item:getDisplayCategory()), self.column3 + 8 + xoff, (y * self.itemHgt) + 16 + textDY + yoff, 0.6, 0.6, 0.8, 1.0, self.font);
                else
                  self:drawText(getText("IGUI_ItemCat_" .. item:getCategory()), self.column3 + 8 + xoff, (y * self.itemHgt) + 16 + textDY + yoff, 0.6, 0.6, 0.8, 1.0, self.font);
                end
              else
                if ISMouseDrag.dragging and #ISMouseDrag.dragging > 0 then
                  for i3, v3 in ipairs(ISMouseDrag.dragging) do
                    if instanceof(v3, "InventoryItem") then
                      --	if v3 == item and not self.parent:canPutIn(false) then
                      --		redDetail = true;
                      --	end
                    end
                  end
                end
                self:drawItemDetails(item, y, xoff, yoff, redDetail);
              end

            end
            if self.selected ~= nil and self.selected[y + 1] ~= nil then
              self:resumeStencil();
            end

          end
          if count == 1 then
            if alt == nil then alt = false; end
            alt = not alt;
          end

          y = y + 1;

          if count == 1 and self.collapsed ~= nil and v.name ~= nil and self.collapsed[v.name] then
            break;
          end
          count = count + 1;
          -- print("trace:zz");
        end
      end

      self:setScrollHeight((y + 1) * self.itemHgt);
      self:setScrollWidth(0);

      if self.draggingMarquis then
        local w = self:getMouseX() - self.draggingMarquisX;
        local h = self:getMouseY() - self.draggingMarquisY;
        self:drawRectBorder(self.draggingMarquisX, self.draggingMarquisY, w, h, 0.4, 0.9, 0.9, 1);

      end


      if not doDragged then
        self:drawRectStatic(1, 0, self.width - 2, 16, 1, 0, 0, 0);
      end

    end

    function ISInventoryPane:drawProgressBar(x, y, w, h, f, fg)
      if f < 0.0 then f = 0.0 end
      if f > 1.0 then f = 1.0 end
      local done = math.floor(w * f)
      if f > 0 then done = math.max(done, 1) end
      self:drawRect(x, y, done, h, fg.a, fg.r, fg.g, fg.b);
      local bg = {r = 0.25, g = 0.25, b = 0.25, a = 1.0};
      self:drawRect(x + done, y, w - done, h, bg.a, bg.r, bg.g, bg.b);
    end

    function ISInventoryPane:drawItemDetails(item, y, xoff, yoff, red)

      if item == nil then
        return;
      end

      --~ 	print("renderdetail");
      --~ 	print(red);
      local hdrHgt = 16
      local top = hdrHgt + y * self.itemHgt + yoff
      local fgBar = {r = 0.0, g = 0.6, b = 0.0, a = 0.7}
      local fgText = {r = 0.6, g = 0.8, b = 0.5, a = 0.6}
      if red then fgText = {r = 0.0, g = 0.0, b = 0.5, a = 0.7} end
      if instanceof(item, "HandWeapon") then
        self:drawText(getText("IGUI_invpanel_Condition") .. ":", 40 + 30 + xoff, top + (self.itemHgt - self.fontHgt) / 2, fgText.a, fgText.r, fgText.g, fgText.b, self.font);
        self:drawProgressBar(40 + 120 + xoff, top + (self.itemHgt / 2) - 1, 100, 2, item:getCondition() / item:getConditionMax(), fgBar);
      elseif instanceof(item, "Drainable") then
        self:drawText(getText("IGUI_invpanel_Remaining") .. ":", 40 + 30 + xoff, top + (self.itemHgt - self.fontHgt) / 2, fgText.a, fgText.r, fgText.g, fgText.b, self.font);
        self:drawProgressBar(40 + 120 + xoff, top + (self.itemHgt / 2) - 1, 100, 2, item:getUsedDelta(), fgBar);
      elseif item:getMeltingTime() > 0 then
        self:drawText("Melting", 40 + 30 + xoff, top + (self.itemHgt - self.fontHgt) / 2, fgText.a, fgText.r, fgText.g, fgText.b, self.font);
        self:drawProgressBar(40 + 120 + xoff, top + (self.itemHgt / 2) - 1, 100, 2, item:getMeltingTime() / 100, fgBar);
      elseif instanceof(item, "Food") then
        if item:isIsCookable() and item:getHeat() > 1.6 then
          local ct = item:getCookingTime()
          local mtc = item:getMinutesToCook()
          local mtb = item:getMinutesToBurn()
          local f = ct / mtc;
          local s = getText("IGUI_invpanel_Cooking")
          if ct > mtb then
            s = getText("IGUI_invpanel_Burnt")
          elseif ct > mtc then
            s = getText("IGUI_invpanel_Burning")
            f = (ct - mtc) / (mtb - mtc);
            fgBar.r = 0.6
            fgBar.g = 0.0
            fgBar.b = 0.0
          end
          self:drawText(s, 40 + 30 + xoff, top + (self.itemHgt - self.fontHgt) / 2, fgText.a, fgText.r, fgText.g, fgText.b, self.font);
          if item:isBurnt() then return end
          self:drawProgressBar(40 + 120 + xoff, top + (self.itemHgt / 2) - 1, 100, 2, f, fgBar);
        elseif item:getFreezingTime() > 0 then
          self:drawText("Freezing time", 40 + 30 + xoff, top + (self.itemHgt - self.fontHgt) / 2, fgText.a, fgText.r, fgText.g, fgText.b, self.font);
          self:drawProgressBar(40 + 120 + xoff, top + (self.itemHgt / 2) - 1, 100, 2, item:getFreezingTime() / 100, fgBar);
        else
          local hunger = item:getHungerChange();
          if(hunger ~= 0) then
            local nut = (-hunger) / 1.0;
            self:drawText(getText("IGUI_invpanel_Nutrition") .. ":", 40 + 30 + xoff, top + (self.itemHgt - self.fontHgt) / 2, fgText.a, fgText.r, fgText.g, fgText.b, self.font);
            self:drawProgressBar(40 + 120 + xoff, top + (self.itemHgt / 2) - 1, 100, 2, nut, fgBar);
          else
            self:drawText(item:getName(), 40 + 30 + xoff, top + (self.itemHgt - self.fontHgt) / 2, fgText.a, fgText.r, fgText.g, fgText.b, self.font);
          end
        end
      else
        self:drawText(item:getName(), 40 + 30 + xoff, top + (self.itemHgt - self.fontHgt) / 2, fgText.a, fgText.r, fgText.g, fgText.b, self.font);
      end
    end

    function ISInventoryPane:render()

      if self.mode == "icons" then
        self:rendericons();
      elseif self.mode == "details" then
        self:renderdetails(true);
      end

      self:clearStencilRect();

      --self:clearStencilRect();

    end

    function ISInventoryPane:setMode(mode)
      self.mode = mode;

    end

    function ISInventoryPane:onInventoryFontChanged()
      local font = getCore():getOptionInventoryFont()
      if font == "Large" then
        self.font = UIFont.Large
      elseif font == "Small" then
        self.font = UIFont.Small
      else
        self.font = UIFont.Medium
      end
      self.fontHgt = getTextManager():getFontFromEnum(self.font):getLineHeight()
      self.itemHgt = math.ceil(math.max(18, self.fontHgt) * self.zoom)
      self.texScale = math.min(32, (self.itemHgt - 2)) / 32
    end

    --************************************************************************--
    --** ISInventoryPane:new
    --**
    --************************************************************************--
    function ISInventoryPane:new (x, y, width, height, inventory, zoom)
      local o = {}
      --o.data = {}
      o = ISPanel:new(x, y, width, height);
      setmetatable(o, self)
      self.__index = self
      o.x = x;
      o.y = y;
      o.borderColor = {r = 0.4, g = 0.4, b = 0.4, a = 1};
      o.backgroundColor = {r = 0, g = 0, b = 0, a = 0.5};
      o.width = width;
      o.height = height;
      o.anchorLeft = true;
      o.anchorRight = false;
      o.anchorTop = true;
      o.anchorBottom = false;
      o.inventory = inventory;
      o.zoom = zoom;
      o.mode = "details";
      o.column2 = 30;
      o.column3 = 140;
      o.column4 = o.width;
      o.items = {}
      o.selected = {}
      o.previousMouseUp = nil;
      local font = getCore():getOptionInventoryFont()
      if font == "Large" then
        o.font = UIFont.Large
      elseif font == "Small" then
        o.font = UIFont.Small
      else
        o.font = UIFont.Medium
      end
      if zoom > 1.5 then
        o.font = UIFont.Large;
      end
      o.fontHgt = getTextManager():getFontFromEnum(o.font):getLineHeight()
      o.itemHgt = math.ceil(math.max(18, o.fontHgt) * o.zoom)
      o.texScale = math.min(32, (o.itemHgt - 2)) / 32

      o.treeexpicon = getTexture("media/ui/TreeExpanded.png");
      o.treecolicon = getTexture("media/ui/TreeCollapsed.png");
      o.expandicon = getTexture("media/ui/TreeExpandAll.png");
      o.collapseicon = getTexture("media/ui/TreeCollapseAll.png");
      o.equippedItemIcon = getTexture("media/ui/icon.png");
      o.brokenItemIcon = getTexture("media/ui/icon_broken.png");
      o.frozenItemIcon = getTexture("media/ui/icon_frozen.png");
      o.poisonIcon = getTexture("media/ui/SkullPoison.png");
      o.itemSortFunc = ISInventoryPane.itemSortByNameInc; -- how to sort the items...
      o.favoriteStar = getTexture("media/ui/FavoriteStar.png");
      return o
    end
