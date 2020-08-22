
--***********************************************************
--**               LEMMY/ROBERT JOHNSON                    **
--***********************************************************

require "ISUI/ISPanel"
require "ISUI/ISButton"
require "ISUI/ISInventoryPane"
require "ISUI/ISResizeWidget"
require "ISUI/ISMouseDrag"
require "ISUI/ISLayoutManager"

require "defines"

ISInventoryPage = ISPanel:derive("ISInventoryPage");


--************************************************************************--
--** ISInventoryPage:initialise
--**
--************************************************************************--

function ISInventoryPage:initialise()
  ISPanel.initialise(self);
end

function ISInventoryPage:onChangeFilter(selected)

end

function ISInventoryPage:titleBarHeight(selected)
  return math.max(16, self.titleFontHgt + 1)
end

--************************************************************************--
--** ISPanel:instantiate
--**
--************************************************************************--
function ISInventoryPage:createChildren()

  self.minimumHeight = 100;
  -- This must be 32 pixels wider than InventoryPane's minimum width
  -- TODO: parent widgets respect min size of child widgets.
  self.minimumWidth = 256 + 32;

  local titleBarHeight = self:titleBarHeight()
  local closeBtnSize = titleBarHeight
  local lootButtonHeight = titleBarHeight

  local panel2 = ISInventoryPane:new(0, titleBarHeight, self.width - 32, self.height - titleBarHeight - 9, self.inventory, self.zoom);
  panel2.anchorBottom = true;
  panel2.anchorRight = true;
  panel2.player = self.player;
  panel2:initialise();

  panel2:setMode("details");

  panel2.inventoryPage = self;
  self:addChild(panel2);

  self.inventoryPane = panel2;
  self.lootAll = ISButton:new(3 + closeBtnSize * 2 + 1, 0, 50, lootButtonHeight, getText("IGUI_invpage_Loot_all"), self, ISInventoryPage.lootAll);
  self.lootAll:initialise();
  self.lootAll.borderColor.a = 0.0;
  self.lootAll.backgroundColor.a = 0.0;
  self.lootAll.backgroundColorMouseOver.a = 0.7;
  self:addChild(self.lootAll);
  self.lootAll:setVisible(false);

  local textWid = getTextManager():MeasureStringX(UIFont.Small, getText("IGUI_invpage_Transfer_all"))
  self.transferAll = ISButton:new(self.width - 3 - closeBtnSize - 90 - textWid, 0, textWid, lootButtonHeight, getText("IGUI_invpage_Transfer_all"), self, ISInventoryPage.transferAll);
  self.transferAll:initialise();
  self.transferAll.borderColor.a = 0.0;
  self.transferAll.backgroundColor.a = 0.0;
  self.transferAll.backgroundColorMouseOver.a = 0.7;
  self:addChild(self.transferAll);
  self.transferAll:setVisible(false);

  self.toggleStove = ISButton:new(45 + getTextManager():MeasureStringX(UIFont.Small, getText("IGUI_invpage_Loot_all")), 0, 50, lootButtonHeight, getText("ContextMenu_Turn_On"), self, ISInventoryPage.toggleStove);
  self.toggleStove:initialise();
  self.toggleStove.borderColor.a = 0.0;
  self.toggleStove.backgroundColor.a = 0.0;
  self.toggleStove.backgroundColorMouseOver.a = 0.7;
  self:addChild(self.toggleStove);
  self.toggleStove:setVisible(false);

  --	local filter = ISRadioOption:new(0, 15, 150, 150, "Filter", self, ISInventoryPage.onChangeFilter);
  --	filter:addOption("All");
  --	filter:addOption("Weapons/Ammo");
  --	filter:addOption("Food/Cooking");
  --	filter:addOption("Clothing");
  --	filter:addOption("Building");
  --	self:addChild(filter);

  -- Do corner x + y widget
  local resizeWidget = ISResizeWidget:new(self.width - 10, self.height - 10, 10, 10, self);
  resizeWidget:initialise();
  self:addChild(resizeWidget);

  self.resizeWidget = resizeWidget;

  -- Do bottom y widget
  resizeWidget = ISResizeWidget:new(0, self.height - 10, self.width - 10, 10, self, true);
  resizeWidget.anchorLeft = true;
  resizeWidget.anchorRight = true;
  resizeWidget:initialise();
  self:addChild(resizeWidget);

  self.resizeWidget2 = resizeWidget;


  self.closeButton = ISButton:new(3, 0, closeBtnSize, closeBtnSize, "", self, ISInventoryPage.close);
  self.closeButton:initialise();
  self.closeButton.borderColor.a = 0.0;
  self.closeButton.backgroundColor.a = 0;
  self.closeButton.backgroundColorMouseOver.a = 0;
  self.closeButton:setImage(self.closebutton);
  self:addChild(self.closeButton);
  if getCore():getGameMode() == "Tutorial" then
    self.closeButton:setVisible(false)
  end

  self.infoButton = ISButton:new(self.closeButton:getRight() + 1, 0, closeBtnSize, closeBtnSize, "", self, ISInventoryPage.onInfo);
  self.infoButton:initialise();
  self.infoButton.borderColor.a = 0.0;
  self.infoButton.backgroundColor.a = 0.0;
  self.infoButton.backgroundColorMouseOver.a = 0.7;
  self.infoButton:setImage(self.infoBtn);
  self:addChild(self.infoButton);
  self.infoButton:setVisible(false);

  --  --print("adding pin button");
  self.pinButton = ISButton:new(self.width - closeBtnSize - 3, 0, closeBtnSize, closeBtnSize, "", self, ISInventoryPage.setPinned);
  self.pinButton.anchorRight = true;
  self.pinButton.anchorLeft = false;
  --  --print("initialising pin button");
  self.pinButton:initialise();
  self.pinButton.borderColor.a = 0.0;
  self.pinButton.backgroundColor.a = 0;
  self.pinButton.backgroundColorMouseOver.a = 0;
  -- --print("setting pin button image");
  self.pinButton:setImage(self.pinbutton);
  --  --print("adding pin button to panel");
  self:addChild(self.pinButton);
  --  --print("set pin button invisible.");
  self.pinButton:setVisible(false);

  -- --print("adding collapse button");
  self.collapseButton = ISButton:new(self.pinButton:getX(), 0, closeBtnSize, closeBtnSize, "", self, ISInventoryPage.collapse);
  self.collapseButton.anchorRight = true;
  self.collapseButton.anchorLeft = false;
  self.collapseButton:initialise();
  self.collapseButton.borderColor.a = 0.0;
  self.collapseButton.backgroundColor.a = 0;
  self.collapseButton.backgroundColorMouseOver.a = 0;
  self.collapseButton:setImage(self.collapsebutton);
  self:addChild(self.collapseButton);
  if getCore():getGameMode() == "Tutorial" then
    self.collapseButton:setVisible(false);
  end
  -- load the current weight of the container
  self.totalWeight = ISInventoryPage.loadWeight(self.inventory);

  self:refreshBackpacks();

  self:collapse();
end

function ISInventoryPage:refreshWeight()
  return;
  --~ 	for i,v in ipairs(self.backpacks) do
  --~ 		v:setOverlayText(ISInventoryPage.loadWeight(v.inventory) .. "/" .. v.capacity);
  --~ 	end
end

function ISInventoryPage:lootAll()
  self.inventoryPane:lootAll();
end

function ISInventoryPage:transferAll()
  self.inventoryPane:transferAll();
end

function ISInventoryPage:toggleStove()
  if self.inventoryPane:toggleStove() then
    self.toggleStove:setTitle(getText("ContextMenu_Turn_Off"));
  else
    self.toggleStove:setTitle(getText("ContextMenu_Turn_On"));
  end
end

function ISInventoryPage:syncToggleStove()
  local isVisible = self.toggleStove:getIsVisible()
  local shouldBeVisible = false
  local stove = nil
  if self.inventoryPane.inventory then
    stove = self.inventoryPane.inventory:getParent()
    if instanceof(stove, "IsoStove") and
    stove:getContainer() and
    stove:getContainer():isPowered() then
      shouldBeVisible = true
    end
  end
  local containerButton
  for _, cb in ipairs(self.backpacks) do
    if cb.inventory == self.inventoryPane.inventory then
      containerButton = cb
      break
    end
  end
  if not containerButton then
    shouldBeVisible = false
  end
  if isVisible ~= shouldBeVisible then
    self.toggleStove:setVisible(shouldBeVisible)
  end
  if shouldBeVisible then
    if stove:Activated() then
      self.toggleStove:setTitle(getText("ContextMenu_Turn_Off"))
    else
      self.toggleStove:setTitle(getText("ContextMenu_Turn_On"))
    end
  end
end

function ISInventoryPage:setInfo(text)
  self.infoButton:setVisible(true);
  self.infoText = text;
end

function ISInventoryPage:onInfo()
  if not self.infoRichText then
    self.infoRichText = ISModalRichText:new(getCore():getScreenWidth() / 2 - 300, getCore():getScreenHeight() / 2 - 300, 600, 600, self.infoText, false);
    self.infoRichText:initialise();
    self.infoRichText.backgroundColor = {r = 0, g = 0, b = 0, a = 0.9};
    self.infoRichText.chatText:paginate();
    self.infoRichText:setHeightToContents()
    self.infoRichText:setY(getCore():getScreenHeight() / 2 - self.infoRichText:getHeight() / 2);
    self.infoRichText:setVisible(true);
    self.infoRichText:addToUIManager();
  elseif self.infoRichText:isReallyVisible() then
    self.infoRichText:removeFromUIManager()
  else
    self.infoRichText:setVisible(true)
    self.infoRichText:addToUIManager()
  end
  --    self.infoRichText:paginate();
end

function ISInventoryPage:collapse()
  if ISMouseDrag.dragging and #ISMouseDrag.dragging > 0 then
    return;
  end
  self.pin = false;
  self.collapseButton:setVisible(false);
  self.pinButton:setVisible(true);
  self.pinButton:bringToTop();
end

function ISInventoryPage:setPinned()
  self.pin = true;
  self.collapseButton:setVisible(true);
  self.pinButton:setVisible(false);
  self.collapseButton:bringToTop();
end

function ISInventoryPage:update()

  if self.coloredInv and (self.inventory ~= self.coloredInv or self.isCollapsed) then
    if self.coloredInv:getParent() then
      self.coloredInv:getParent():setHighlighted(false)
    end
    self.coloredInv = nil;
  end

  if not self.isCollapsed then
    --        print(self.inventory:getParent());
    if self.inventory:getParent() and (instanceof(self.inventory:getParent(), "IsoObject") or instanceof(self.inventory:getParent(), "IsoDeadBody")) then
      self.inventory:getParent():setHighlighted(true, false);
      self.inventory:getParent():setHighlightColor(getCore():getObjectHighlitedColor());
      --             self.inventory:getParent():setHighlightColor(ColorInfo.new(0.3,0.3,0.3,1));
      --            self.inventory:getParent():setBlink(true);
      --            self.inventory:getParent():setCustomColor(0.98,0.56,0.11,1);
      self.coloredInv = self.inventory;
    end
  end

  if ISMouseDrag.dragging ~= nil and #ISMouseDrag.dragging > 0 then
    self.collapseCounter = 0;
    if isClient() and self.isCollapsed then
      self.inventoryPane.inventory:requestSync();
    end
    self.isCollapsed = false;
    self:clearMaxDrawHeight();
    self.collapseCounter = 0;

  end

  if not self.onCharacter then
    local playerObj = getSpecificPlayer(self.player)
    if self.lastDir ~= playerObj:getDir() then
      self.lastDir = playerObj:getDir()
      self:refreshBackpacks()
    elseif self.lastSquare ~= playerObj:getCurrentSquare() then
      self.lastSquare = playerObj:getCurrentSquare()
      self:refreshBackpacks()
    end

    -- If the currently-selected container is locked to the player, select another container.
    local object = self.inventory and self.inventory:getParent() or nil
    if #self.backpacks > 1 and instanceof(object, "IsoThumpable") and object:isLockedToCharacter(playerObj) then
      local currentIndex = self:getCurrentBackpackIndex()
      local unlockedIndex = self:prevUnlockedContainer(currentIndex, false)
      if unlockedIndex == -1 then
        unlockedIndex = self:nextUnlockedContainer(currentIndex, false)
      end
      if unlockedIndex ~= -1 then
        self:selectContainer(self.backpacks[unlockedIndex])
        if playerObj:getJoypadBind() ~= -1 then
          self.backpackChoice = unlockedIndex
        end
      end
    end
  end

  self:syncToggleStove()
end

--************************************************************************--
--** ISInventoryPage:render
--**
--************************************************************************--
function ISInventoryPage:prerender()

  if self.blinkContainer then
    if not self.blinkAlphaContainer then self.blinkAlphaContainer = 0.7; self.blinkAlphaIncreaseContainer = false; end
    if not self.blinkAlphaIncreaseContainer then
      self.blinkAlphaContainer = self.blinkAlphaContainer - 0.02 * (30 / getPerformance():getUIRenderFPS());
      if self.blinkAlphaContainer < 0.3 then
        self.blinkAlphaContainer = 0.3;
        self.blinkAlphaIncreaseContainer = true;
      end
    else
      self.blinkAlphaContainer = self.blinkAlphaContainer + 0.02 * (30 / getPerformance():getUIRenderFPS());
      if self.blinkAlphaContainer > 0.7 then
        self.blinkAlphaContainer = 0.7;
        self.blinkAlphaIncreaseContainer = false;
      end
    end
    for i, v in ipairs(self.backpacks) do
      v.backgroundColor = {r = self.blinkAlphaContainer, g = self.blinkAlphaContainer, b = self.blinkAlphaContainer, a = 1.0};
    end
  end

  local titleBarHeight = self:titleBarHeight()
  local height = self:getHeight();
  if self.isCollapsed then
    height = titleBarHeight;
  end

  self:drawRect(0, 0, self:getWidth(), height, self.backgroundColor.a, self.backgroundColor.r, self.backgroundColor.g, self.backgroundColor.b);

  if not self.blink then
    self:drawTextureScaled(self.titlebarbkg, 2, 1, self:getWidth() - 4, titleBarHeight - 2, 1, 1, 1, 1);
  else
    if not self.blinkAlpha then self.blinkAlpha = 1; end
    self:drawRect(2, 1, self:getWidth() - 4, 14, self.blinkAlpha, 1, 1, 1);
    --        self:drawTextureScaled(self.titlebarbkg, 2, 1, self:getWidth() - 4, 14, self.blinkAlpha, 1, 1, 1);

    if not self.blinkAlphaIncrease then
      self.blinkAlpha = self.blinkAlpha - 0.1 * (30 / getPerformance():getUIRenderFPS());
      if self.blinkAlpha < 0 then
        self.blinkAlpha = 0;
        self.blinkAlphaIncrease = true;
      end
    else
      self.blinkAlpha = self.blinkAlpha + 0.1 * (30 / getPerformance():getUIRenderFPS());
      if self.blinkAlpha > 1 then
        self.blinkAlpha = 1;
        self.blinkAlphaIncrease = false;
      end
    end
  end
  self:drawRectBorder(0, 0, self:getWidth(), titleBarHeight, self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b);

  if not self.isCollapsed then
    -- Draw border for backpack area...
    self:drawRect(self:getWidth() - 32, titleBarHeight, 32, height - titleBarHeight - 7, self.backgroundColor.a, self.backgroundColor.r, self.backgroundColor.g, self.backgroundColor.b);
  end

  --~ 	if not self.title then
  --~ 		self.title = getSpecificPlayer(self.player):getDescriptor():getForename().." "..getSpecificPlayer(self.player):getDescriptor():getSurname().."'s Inventory";
  --~ 	end

  if self.title and not self.lootAll:getIsVisible() then
    self:drawText(self.title, self.infoButton:getRight() + 1, 0, 1, 1, 1, 1);
  end
  if self.title and self.lootAll:getIsVisible() then
    self:drawText(self.title, self.lootAll:getRight() + 8, 0, 1, 1, 1, 1);
  end

  -- load the current weight of the container
  self.totalWeight = ISInventoryPage.loadWeight(self.inventoryPane.inventory);

  local roundedWeight = round(self.totalWeight, 2)
  if self.capacity then
    if self.inventoryPane.inventory == getSpecificPlayer(self.player):getInventory() then
      self:drawTextRight(roundedWeight .. " / " .. getSpecificPlayer(self.player):getMaxWeight(), self.pinButton:getX(), 0, 1, 1, 1, 1);
    else
      self:drawTextRight(roundedWeight .. " / " .. self.capacity, self.pinButton:getX(), 0, 1, 1, 1, 1);
    end
  else
    self:drawTextRight(roundedWeight .. "", self.width - 20, 0, 1, 1, 1, 1);
  end

  local weightWid = getTextManager():MeasureStringX(UIFont.Small, "99.99 / 99")
  weightWid = math.max(90, weightWid)
  self.transferAll:setX(self.pinButton:getX() - weightWid - getTextManager():MeasureStringX(UIFont.Small, getText("IGUI_invpage_Transfer_all")));
  if not self.onCharacter or self.width < 370 then
    self.transferAll:setVisible(false)
  else
    self.transferAll:setVisible(true)
  end


  -- self:drawRectBorder(self:getWidth()-32, 15, 32, self:getHeight()-16-6, self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b);
  self:setStencilRect(0, 0, self.width + 1, height);

  if ISInventoryPage.renderDirty then
    ISInventoryPage.renderDirty = false;
    ISInventoryPage.dirtyUI();
  end
end

function ISInventoryPage:close()
  ISPanel.close(self)
  if JoypadState.players[self.player + 1] then
    setJoypadFocus(self.player, nil)
  end
end

function ISInventoryPage:onLoseJoypadFocus(joypadData)
  ISPanel.onLoseJoypadFocus(self, joypadData)

  self.inventoryPane.doController = false;
  local inv = getPlayerInventory(self.player);
  local loot = getPlayerLoot(self.player);
  if inv.joyfocus or loot.joyfocus then
    --  self.inventoryPane.doController = false;
    return;
  end

  if getFocusForPlayer(self.player) == nil then
    inv:setVisible(false);
    loot:setVisible(false);
    local playerObj = getSpecificPlayer(self.player)
    if playerObj:getVehicle() and playerObj:getVehicle():isDriver(playerObj) then
      getPlayerVehicleDashboard(self.player):addToUIManager()
    end
    --  self.inventoryPane.doController = false;
  end

end

function ISInventoryPage:onGainJoypadFocus(joypadData)
  ISPanel.onGainJoypadFocus(self, joypadData)

  local inv = getPlayerInventory(self.player);
  local loot = getPlayerLoot(self.player);
  inv:setVisible(true);
  loot:setVisible(true);
  getPlayerVehicleDashboard(self.player):removeFromUIManager()
  self.inventoryPane.doController = true;
end

function ISInventoryPage:getCurrentBackpackIndex()
  for index, backpack in ipairs(self.backpacks) do
    if backpack.inventory == self.inventory then
      return index
    end
  end
  return - 1
end

function ISInventoryPage:prevUnlockedContainer(index, wrap)
  local playerObj = getSpecificPlayer(self.player)
  for i = index - 1, 1, - 1 do
    local backpack = self.backpacks[i]
    local object = backpack.inventory:getParent()
    if not (instanceof(object, "IsoThumpable") and object:isLockedToCharacter(playerObj)) then
      return i
    end
  end
  return wrap and self:prevUnlockedContainer(#self.backpacks + 1, false) or - 1
end

function ISInventoryPage:nextUnlockedContainer(index, wrap)
  if index < 0 then -- User clicked a container that isn't displayed
    return wrap and self:nextUnlockedContainer(0, false) or - 1
  end
  local playerObj = getSpecificPlayer(self.player)
  for i = index + 1, #self.backpacks do
    local backpack = self.backpacks[i]
    local object = backpack.inventory:getParent()
    if not (instanceof(object, "IsoThumpable") and object:isLockedToCharacter(playerObj)) then
      return i
    end
  end
  return wrap and self:nextUnlockedContainer(0, false) or - 1
end

function ISInventoryPage:onJoypadDown(button)
  ISContextMenu.globalPlayerContext = self.player;
  local playerObj = getSpecificPlayer(self.player)

  if button == Joypad.AButton then
    self.inventoryPane:doContextOnJoypadSelected();
  end

  if button == Joypad.BButton then
    if isPlayerDoingActionThatCanBeCancelled(playerObj) then
      playerObj:StopAllActionQueue()
      return
    end
    self.inventoryPane:doJoypadExpandCollapse()
  end
  if button == Joypad.XButton then
    self.inventoryPane:doGrabOnJoypadSelected();
  end
  if button == Joypad.YButton then
    setJoypadFocus(self.player, nil);
  end

  if button == Joypad.LBumper then
    local inv = getPlayerInventory(self.player);
    inv.backpackChoice = inv:nextUnlockedContainer(inv.backpackChoice, true);

    local but = inv.backpacks[inv.backpackChoice];
    if but == nil or inv.backpackChoice > #inv.backpacks then
      inv.backpackChoice = 1;
      but = inv.backpacks[inv.backpackChoice];
    end
    inv.inventoryPane.inventory = but.inventory;
    inv.inventory = but.inventory;
    inv.capacity = but.capacity
    --inv.inventoryPane:refreshContainer();
    inv:refreshBackpacks();
  end
  if button == Joypad.RBumper then
    local inv = getPlayerLoot(self.player);
    inv.backpackChoice = inv:nextUnlockedContainer(inv.backpackChoice, true);

    local but = inv.backpacks[inv.backpackChoice];
    if but == nil then
      inv.backpackChoice = 1;
      but = inv.backpacks[inv.backpackChoice];
    end
    inv.inventoryPane.inventory = but.inventory;
    inv.inventory = but.inventory;
    if not but.inventory:isExplored() then
      if not isClient() then
        ItemPicker.fillContainer(but.inventory, self.player);
      else
        but.inventory:requestServerItemsForContainer();
      end

      but.inventory:setExplored(true);
    end
    inv.capacity = but.capacity
    -- inv.inventoryPane:refreshContainer();
    inv:refreshBackpacks();
  end
end

function ISInventoryPage:onJoypadDirUp()
  self.inventoryPane.joyselection = self.inventoryPane.joyselection - 1;
  self:ensureVisible(self.inventoryPane.joyselection + 1)
end

function ISInventoryPage:onJoypadDirDown()
  self.inventoryPane.joyselection = self.inventoryPane.joyselection + 1;
  self:ensureVisible(self.inventoryPane.joyselection + 1)
end

function ISInventoryPage:ensureVisible(index)
  local lb = self.inventoryPane
  -- Wrap index same as ISInventoryPane:renderdetails does
  if index < 1 then index = #lb.items end
  if index > #lb.items then index = 1 end
  local headerHgt = 17
  local y = headerHgt + lb.itemHgt * (index - 1)
  local height = lb.itemHgt
  if y < 0 - lb:getYScroll() + headerHgt then
    lb:setYScroll(0 - y + headerHgt)
  elseif y + height > 0 - lb:getYScroll() + (lb.height - headerHgt) then
    lb:setYScroll(0 - (y + height - lb.height))
  end
end

function ISInventoryPage:onJoypadDirLeft()
  local inv = getPlayerInventory(self.player);
  local loot = getPlayerLoot(self.player);

  if self == loot then
    setJoypadFocus(self.player, inv);
  elseif self == inv then
    setJoypadFocus(self.player, loot);
  end
end

function ISInventoryPage:onJoypadDirRight()
  local inv = getPlayerInventory(self.player);
  local loot = getPlayerLoot(self.player);

  if self == loot then
    setJoypadFocus(self.player, inv);
  elseif self == inv then
    setJoypadFocus(self.player, loot);
  end
end



function ISInventoryPage:render()
  local titleBarHeight = self:titleBarHeight()
  local height = self:getHeight();
  if self.isCollapsed then
    height = titleBarHeight
  end
  -- Draw backpack border over backpacks....
  if not self.isCollapsed then
    self:drawRectBorder(self:getWidth() - 32, titleBarHeight - 1, 32, height - titleBarHeight - 7, self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b);
    --self:drawRect(0, 0, self.width-32, self.height, 1, 1, 1, 1);
    self:drawRectBorder(0, height - 9, self:getWidth(), 9, self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b);
    self:drawTextureScaled(self.statusbarbkg, 2, height - 7, self:getWidth() - 4, 6, 1, 1, 1, 1);
    self:drawTexture(self.resizeimage, self:getWidth() - 9, height - 8, 1, 1, 1, 1);
  end

  self:clearStencilRect();
  self:drawRectBorder(0, 0, self:getWidth(), height, self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b);


  if self.joyfocus then
    self:drawRectBorder(0, 0, self:getWidth(), self:getHeight(), 0.4, 0.2, 1.0, 1.0);
    self:drawRectBorder(1, 1, self:getWidth() - 2, self:getHeight() - 2, 0.4, 0.2, 1.0, 1.0);
  end

end
function ISInventoryPage:selectContainer(button)
  if ISMouseDrag.dragging ~= nil then

    local playerObj = getSpecificPlayer(self.player)

    local counta = 1;


    if self:canPutIn(false) then
      local dragging = ISInventoryPane.getActualItems(ISMouseDrag.dragging)
      for i, v in ipairs(dragging) do
        local transfer = v:getContainer() and not button.inventory:isInside(v)
        if v:isFavorite() and not button.inventory:isInCharacterInventory(playerObj) then
          transfer = false
        end
        if transfer then
          ISTimedActionQueue.add(ISInventoryTransferAction:new(playerObj, v, v:getContainer(), button.inventory))
        end
      end
      self.inventoryPane.selected = {};
      getPlayerLoot(self.player).inventoryPane.selected = {};
      getPlayerInventory(self.player).inventoryPane.selected = {};
    end

    if ISMouseDrag.draggingFocus then
      ISMouseDrag.draggingFocus:onMouseUp(0, 0);
      ISMouseDrag.draggingFocus = nil;
      ISMouseDrag.dragging = nil;
    end
    self:refreshWeight();
    return;
  end
  --

  if button.inventory ~= self.inventoryPane.lastinventory then
    if button.inventory:getOpenSound() then
      getSpecificPlayer(self.player):getEmitter():playSound(button.inventory:getOpenSound())
    end

    if not button.inventory:getOpenSound() and self.inventoryPane.lastinventory:getCloseSound() then
      getSpecificPlayer(self.player):getEmitter():playSound(self.inventoryPane.lastinventory:getCloseSound())
    end
  end

  self.inventoryPane.lastinventory = button.inventory;
  self.inventoryPane.inventory = button.inventory;
  self.inventoryPane.selected = {}
  if not button.inventory:isExplored() then
    if not isClient() then
      ItemPicker.fillContainer(button.inventory, self.player);
    else
      button.inventory:requestServerItemsForContainer();
    end
    button.inventory:setExplored(true);
  end

  self.title = button.name;

  self.capacity = button.capacity;

  self:refreshBackpacks();
  --self:refreshBackpacks();
  --~ 	self.inventoryPane.selected = {};
  --~ 	getPlayerLoot(self.player).inventoryPane.selected = {};
  --~ 	getPlayerInventory(self.player).inventoryPane.selected = {};
end

function ISInventoryPage:setNewContainer(inventory)
  self.inventoryPane.inventory = inventory;
  self.inventory = inventory;
  self.inventoryPane:refreshContainer();

  local playerObj = getSpecificPlayer(self.player)
  self.capacity = inventory:getEffectiveCapacity(playerObj);

  -- highlight the container if it is in the list
  for i, containerButton in ipairs(self.backpacks) do
    if containerButton.inventory == inventory then
      containerButton.backgroundColor = {r = 0.7, g = 0.7, b = 0.7, a = 1.0}
    else
      containerButton.backgroundColor.a = 0.0
    end
  end

  self:syncToggleStove()
end

function ISInventoryPage.loadWeight(inv)
  if inv == nil then return 0; end;

    return inv:getCapacityWeight();
  end

  --************************************************************************--
  --** ISButton:onMouseMove
  --**
  --************************************************************************--
  function ISInventoryPage:onMouseMove(dx, dy)
    self.mouseOver = true;

    --    print(self:getMouseX(), self:getMouseY(), self:getWidth(), self:getHeight())

    if self.moving then
      self:setX(self.x + dx);
      self:setY(self.y + dy);

    end

    if not isMouseButtonDown(0) and not isMouseButtonDown(1) and not isMouseButtonDown(2) then

      self.collapseCounter = 0;
      if self.isCollapsed and self:getMouseY() < self:titleBarHeight() then
        self.isCollapsed = false;
        if isClient() then
          self.inventoryPane.inventory:requestSync();
        end
        self:clearMaxDrawHeight();
        self.collapseCounter = 0;
      end
    end
  end

  --************************************************************************--
  --** ISButton:onMouseMoveOutside
  --**
  --************************************************************************--
  function ISInventoryPage:onMouseMoveOutside(dx, dy)
    self.mouseOver = false;

    if self.moving then
      self:setX(self.x + dx);
      self:setY(self.y + dy);
    end

    if ISMouseDrag.dragging ~= true and not self.pin and (self:getMouseX() < 0 or self:getMouseY() < 0 or self:getMouseX() > self:getWidth() or self:getMouseY() > self:getHeight()) then

      self.collapseCounter = self.collapseCounter + getGameTime():getMultiplier() / 0.8;
      local bDo = false;
      if ISMouseDrag.dragging == nil then
        bDo = true;
      else
        for i, k in ipairs(ISMouseDrag.dragging) do
          bDo = true;
          break;
        end
      end
      if ISMouseDrag.dragging and #ISMouseDrag.dragging > 0 then
        bDo = false;
      end
      if self.collapseCounter > 120 and not self.isCollapsed and bDo then

        self.isCollapsed = true;
        self:setMaxDrawHeight(self:titleBarHeight());

      end
    end
  end

  --************************************************************************--
  --** ISButton:onMouseUp
  --**
  --************************************************************************--
  function ISInventoryPage:onMouseUp(x, y)
    if not self:getIsVisible() then
      return;
    end
    --~ 	print ("Mouse up on inventory page. Uhoh");

    --	ISMouseDrag = {}
    self.moving = false;
    self:setCapture(false);
  end

  function ISInventoryPage:onMouseDown(x, y)

    if not self:getIsVisible() then
      return;
    end

    getSpecificPlayer(self.player):nullifyAiming();

    self.downX = self:getMouseX();
    self.downY = self:getMouseY();
    self.moving = true;
    self:setCapture(true);
  end

  function ISInventoryPage:onRightMouseDownOutside(x, y)
    if((self:getMouseX() < 0 or self:getMouseY() < 0 or self:getMouseX() > self:getWidth() or self:getMouseY() > self:getHeight()) and not self.pin) then
      self.isCollapsed = true;
      self:setMaxDrawHeight(self:titleBarHeight());
    end
  end
  function ISInventoryPage:onMouseDownOutside(x, y)
    if((self:getMouseX() < 0 or self:getMouseY() < 0 or self:getMouseX() > self:getWidth() or self:getMouseY() > self:getHeight()) and not self.pin) then
      self.isCollapsed = true;
      self:setMaxDrawHeight(self:titleBarHeight());
    end
  end

  function ISInventoryPage:onMouseUpOutside(x, y)
    if not self:getIsVisible() then
      return;
    end

    --	ISMouseDrag = {}
    self.moving = false;
    self:setCapture(false);
  end

  function ISInventoryPage:onMouseWheel(del)
    if self:getMouseX() < self:getWidth() - 32 then
      return false
    end
    local currentIndex = self:getCurrentBackpackIndex()
    local unlockedIndex = -1
    if del < 0 then
      unlockedIndex = self:prevUnlockedContainer(currentIndex, true)
    else
      unlockedIndex = self:nextUnlockedContainer(currentIndex, true)
    end
    if unlockedIndex ~= -1 then
      self:selectContainer(self.backpacks[unlockedIndex])
      local playerObj = getSpecificPlayer(self.player)
      if playerObj and playerObj:getJoypadBind() ~= -1 then
        self.backpackChoice = unlockedIndex
      end
    end
    return true
  end

  ISInventoryPage.dirtyUI = function ()
    -- ISInventoryPage.playerInventory.inventoryPane:refreshContainer();
    for i = 0, getNumActivePlayers() - 1 do
      local pdata = getPlayerData(i)
      if pdata and pdata.playerInventory then
        pdata.playerInventory:refreshBackpacks()
        pdata.lootInventory:refreshBackpacks()
      end
    end
  end

  function ISInventoryPage:onBackpackMouseDown(button, x, y)
    ISMouseDrag = {}
    if not isKeyDown(getCore():getKey("Melee")) then
      getSpecificPlayer(self.player):nullifyAiming();
    end
  end

  local sqsContainers = {}
  local sqsVehicles = {}

  function ISInventoryPage:refreshBackpacks()
    for i, v in ipairs(self.backpacks) do
      self:removeChild(v);
    end

    if ISInventoryPage.floorContainer == nil then
      ISInventoryPage.floorContainer = {}
    end
    if ISInventoryPage.floorContainer[self.player + 1] == nil then
      ISInventoryPage.floorContainer[self.player + 1] = ItemContainer.new("floor", nil, nil, 10, 10);
      ISInventoryPage.floorContainer[self.player + 1]:setExplored(true)
    end

    self.inventoryPane.lastinventory = self.inventoryPane.inventory;

    self.inventoryPane:hideButtons()

    local oldNumBackpacks = #self.backpacks
    if self.backpacks == nil then
      self.backpacks = {}
    else
      local count = #self.backpacks;
      for i = 0, count do self.backpacks[i] = nil; end
    end

    local found = false;
    local c = 1;
    local foundIndex = -1;
    local containerButton = nil;

    local playerObj = getSpecificPlayer(self.player)

    if self.onCharacter then
      containerButton = ISButton:new(self:getWidth() - 32, ((c - 1) * 32) + 15, 32, 32, "", self, ISInventoryPage.selectContainer, ISInventoryPage.onBackpackMouseDown, true);
      containerButton.anchorBottom = false;
      containerButton.anchorRight = true;
      containerButton.anchorTop = false;
      containerButton.anchorLeft = false;
      containerButton.name = getText("IGUI_InventoryName", getSpecificPlayer(self.player):getDescriptor():getForename(), getSpecificPlayer(self.player):getDescriptor():getSurname());
      if not self.title then
        self.title = containerButton.name;
      end
      containerButton:setOnMouseOverFunction(ISInventoryPage.onMouseOverButton);
      containerButton:setOnMouseOutFunction(ISInventoryPage.onMouseOutButton);
      containerButton:initialise();
      containerButton.borderColor.a = 0.0;
      containerButton.capacity = self.inventory:getMaxWeight();
      if not self.capacity then
        self.capacity = containerButton.capacity;
      end
      containerButton.backgroundColor.a = 0.0;
      containerButton.backgroundColorMouseOver = {r = 0.3, g = 0.3, b = 0.3, a = 1.0};
      containerButton:setImage(self.invbasic);

      containerButton.inventory = getSpecificPlayer(self.player):getInventory();

      if self.inventoryPane.inventory == containerButton.inventory then
        containerButton.backgroundColor = {r = 0.7, g = 0.7, b = 0.7, a = 1.0};
        foundIndex = c
        found = true;
      end
      self:addChild(containerButton);
      self.backpacks[c] = containerButton;
      c = c + 1;
      local it = getSpecificPlayer(self.player):getInventory():getItems();
      for i = 0, it:size() - 1 do
        local item = it:get(i);

        if item:getCategory() == "Container" and getSpecificPlayer(self.player):isEquipped(item) or item:getType() == "KeyRing" then
          -- found a container, so create a button for it...
          local containerButton = ISButton:new(self.width - 32, ((c - 1) * 32) + 15, 32, 32, "", self, ISInventoryPage.selectContainer, ISInventoryPage.onBackpackMouseDown, true);
          containerButton:setImage(item:getTex());
          containerButton:forceImageSize(30, 30)
          containerButton.anchorBottom = false;
          containerButton:setOnMouseOverFunction(ISInventoryPage.onMouseOverButton);
          containerButton:setOnMouseOutFunction(ISInventoryPage.onMouseOutButton);
          containerButton.anchorRight = true;
          containerButton.anchorTop = false;
          containerButton.anchorLeft = false;
          containerButton:initialise();
          containerButton.borderColor.a = 0.0;
          containerButton.backgroundColor.a = 0.0;
          containerButton.backgroundColorMouseOver = {r = 0.3, g = 0.3, b = 0.3, a = 1.0};
          containerButton.inventory = item:getInventory();
          containerButton.capacity = item:getEffectiveCapacity(playerObj);
          containerButton.name = item:getName();
          if self.inventoryPane.inventory == containerButton.inventory then
            containerButton.backgroundColor = {r = 0.7, g = 0.7, b = 0.7, a = 1.0};
            foundIndex = c;
            found = true;
          end
          self:addChild(containerButton);
          self.backpacks[c] = containerButton;
          c = c + 1;
          self.backpacks[c] = nil
        end

      end
    elseif playerObj:getVehicle() then
      local vehicle = playerObj:getVehicle()
      for partIndex = 1, vehicle:getPartCount() do
        local vehiclePart = vehicle:getPartByIndex(partIndex - 1)
        if vehiclePart:getItemContainer() and vehicle:canAccessContainer(partIndex - 1, playerObj) then
          local containerButton = ISButton:new(self.width - 32, ((c - 1) * 32) + 15, 32, 32, "", self, ISInventoryPage.selectContainer, ISInventoryPage.onBackpackMouseDown, true);
          containerButton.anchorBottom = false;
          containerButton:setOnMouseOverFunction(ISInventoryPage.onMouseOverButton);
          containerButton:setOnMouseOutFunction(ISInventoryPage.onMouseOutButton);
          containerButton.anchorRight = true;
          containerButton.anchorTop = false;
          containerButton.anchorLeft = false;
          containerButton:initialise();
          containerButton.borderColor.a = 0.0;
          containerButton.backgroundColor.a = 0.0;
          containerButton.backgroundColorMouseOver = {r = 0.3, g = 0.3, b = 0.3, a = 1.0};
          containerButton.inventory = vehiclePart:getItemContainer();
          containerButton.capacity = containerButton.inventory:getEffectiveCapacity(playerObj);
          if self.containerIconMaps[containerButton.inventory:getType()] ~= nil then
            containerButton:setImage(self.containerIconMaps[containerButton.inventory:getType()]);
          else
            containerButton:setImage(self.conDefault);
          end
          containerButton:forceImageSize(30, 30)
          containerButton.name = "";
          containerButton.tooltip = getText("IGUI_VehiclePart" .. containerButton.inventory:getType());
          if self.inventoryPane.inventory == containerButton.inventory then
            containerButton.backgroundColor = {r = 0.7, g = 0.7, b = 0.7, a = 1.0};
            foundIndex = c;
            found = true;
          end
          if not containerButton.inventory:isExplored() then
            if not isClient() then
              ItemPicker.fillContainer(containerButton.inventory, self.player);
            else
              containerButton.inventory:requestServerItemsForContainer();
            end
            containerButton.inventory:setExplored(true);
          end
          self:addChild(containerButton);
          self.backpacks[c] = containerButton;
          c = c + 1;
          self.backpacks[c] = nil
        end
      end
    else
      --  print("a");
      local cx = getSpecificPlayer(self.player):getX();
      local cy = getSpecificPlayer(self.player):getY();
      local cz = getSpecificPlayer(self.player):getZ();
      --  print("b");
      -- Do floor
      --

      --
      local container = ISInventoryPage.floorContainer[self.player + 1]
      container:removeItemsFromProcessItems()
      ISInventoryPage.floorContainer[self.player + 1]:clear();

      local sqs = sqsContainers
      table.wipe(sqs)

      local dir = getSpecificPlayer(self.player):getDir();

      if(dir == IsoDirections.N) then sqs[2] = getCell():getGridSquare(cx - 1, cy - 1, cz); sqs[3] = getCell():getGridSquare(cx, cy - 1, cz); sqs[4] = getCell():getGridSquare(cx + 1, cy - 1, cz);
      elseif (dir == IsoDirections.NE) then sqs[2] = getCell():getGridSquare(cx, cy - 1, cz); sqs[3] = getCell():getGridSquare(cx + 1, cy - 1, cz); sqs[4] = getCell():getGridSquare(cx + 1, cy, cz);
      elseif (dir == IsoDirections.E) then sqs[2] = getCell():getGridSquare(cx + 1, cy - 1, cz); sqs[3] = getCell():getGridSquare(cx + 1, cy, cz); sqs[4] = getCell():getGridSquare(cx + 1, cy + 1, cz);
      elseif (dir == IsoDirections.SE) then sqs[2] = getCell():getGridSquare(cx + 1, cy, cz); sqs[3] = getCell():getGridSquare(cx + 1, cy + 1, cz); sqs[4] = getCell():getGridSquare(cx, cy + 1, cz);
      elseif (dir == IsoDirections.S) then sqs[2] = getCell():getGridSquare(cx + 1, cy + 1, cz); sqs[3] = getCell():getGridSquare(cx, cy + 1, cz); sqs[4] = getCell():getGridSquare(cx - 1, cy + 1, cz);
      elseif (dir == IsoDirections.SW) then sqs[2] = getCell():getGridSquare(cx, cy + 1, cz); sqs[3] = getCell():getGridSquare(cx - 1, cy + 1, cz); sqs[4] = getCell():getGridSquare(cx - 1, cy, cz);
      elseif (dir == IsoDirections.W) then sqs[2] = getCell():getGridSquare(cx - 1, cy + 1, cz); sqs[3] = getCell():getGridSquare(cx - 1, cy, cz); sqs[4] = getCell():getGridSquare(cx - 1, cy - 1, cz);
      elseif (dir == IsoDirections.NW) then sqs[2] = getCell():getGridSquare(cx - 1, cy, cz); sqs[3] = getCell():getGridSquare(cx - 1, cy - 1, cz); sqs[4] = getCell():getGridSquare(cx, cy - 1, cz);
      end

      local vehicleContainers = sqsVehicles
      table.wipe(vehicleContainers)

      sqs[1] = getCell():getGridSquare(cx, cy, cz);
      -- print("c");
      for x = 1, 4 do
        local gs = sqs[x];

        -- stop grabbing thru walls...
        local currentSq = getSpecificPlayer(self.player):getCurrentSquare()
        if gs ~= currentSq and currentSq and currentSq:isBlockedTo(gs) then
          gs = nil
        end

        -- don't show containers in safehouse if you're not allowed
        if gs and isClient() and SafeHouse.isSafeHouse(gs, getSpecificPlayer(self.player):getUsername(), true) and not getServerOptions():getBoolean("SafehouseAllowLoot") then
          gs = nil;
        end

        if gs ~= nil then

          --for y = -1, 1 do
          local obs = gs:getObjects();
          local sobs = gs:getStaticMovingObjects();
          local wobs = gs:getWorldObjects();

          if wobs ~= nil then
            for i = 0, wobs:size() - 1 do
              local o = wobs:get(i);
              if instanceof(o, "IsoWorldInventoryObject") then
                -- FIXME: An item can be in only one container; in coop the item won't be displayed for every player.
                ISInventoryPage.floorContainer[self.player + 1]:AddItem(o:getItem());
                if o:getItem() and o:getItem():getCategory() == "Container" then
                  local item = o:getItem()
                  local containerButton = ISButton:new(self.width - 32, ((c - 1) * 32) + 15, 32, 32, "", self, ISInventoryPage.selectContainer, ISInventoryPage.onBackpackMouseDown, true);
                  containerButton:setImage(item:getTex());
                  containerButton:forceImageSize(30, 30)
                  containerButton.anchorBottom = false;
                  containerButton:setOnMouseOverFunction(ISInventoryPage.onMouseOverButton);
                  containerButton:setOnMouseOutFunction(ISInventoryPage.onMouseOutButton);
                  containerButton.anchorRight = true;
                  containerButton.anchorTop = false;
                  containerButton.anchorLeft = false;
                  containerButton:initialise();
                  containerButton.borderColor.a = 0.0;
                  containerButton.backgroundColor.a = 0.0;
                  containerButton.backgroundColorMouseOver = {r = 0.3, g = 0.3, b = 0.3, a = 1.0};
                  containerButton.inventory = item:getInventory();
                  containerButton.capacity = item:getEffectiveCapacity(playerObj);
                  containerButton.name = item:getName();
                  if self.inventoryPane.inventory == containerButton.inventory then
                    containerButton.backgroundColor = {r = 0.7, g = 0.7, b = 0.7, a = 1.0};
                    foundIndex = c;
                    found = true;
                  end
                  self:addChild(containerButton);
                  self.backpacks[c] = containerButton;
                  c = c + 1;
                  self.backpacks[c] = containerButton;
                end
              end
            end
          end

          for i = 0, sobs:size() - 1 do
            local so = sobs:get(i);
            local doIt = true;

            if so:getContainer() ~= nil then
              -- if container is locked with a padlock and we don't have the key, return

              if instanceof(so, "IsoThumpable") and so:isLockedByPadlock() and not getSpecificPlayer(self.player):getInventory():haveThisKey(so:getKeyId()) then
                doIt = false;
              end

              if doIt then
                local containerButton = ISButton:new(self.width - 32, ((c - 1) * 32) + 15, 32, 32, "", self, ISInventoryPage.selectContainer, ISInventoryPage.onBackpackMouseDown, true);
                containerButton.anchorBottom = false;
                containerButton:setOnMouseOverFunction(ISInventoryPage.onMouseOverButton);
                containerButton:setOnMouseOutFunction(ISInventoryPage.onMouseOutButton);
                containerButton.anchorRight = true;
                containerButton.anchorTop = false;
                containerButton.anchorLeft = false;
                containerButton:initialise();
                containerButton.borderColor.a = 0.0;
                containerButton.backgroundColor.a = 0.0;
                containerButton.backgroundColorMouseOver = {r = 0.3, g = 0.3, b = 0.3, a = 1.0};
                containerButton.inventory = so:getContainer();
                containerButton.capacity = so:getContainer():getEffectiveCapacity(playerObj);
                if self.containerIconMaps[containerButton.inventory:getType()] ~= nil then
                  containerButton:setImage(self.containerIconMaps[containerButton.inventory:getType()]);
                else
                  containerButton:setImage(self.conDefault);
                end
                containerButton:forceImageSize(30, 30)
                containerButton.name = "";--getSpecificPlayer(self.player):getDescriptor():getForename().." "..getSpecificPlayer(self.player):getDescriptor():getSurname().."'s " .. item:getName();
                if self.inventoryPane.inventory == containerButton.inventory then
                  containerButton.backgroundColor = {r = 0.7, g = 0.7, b = 0.7, a = 1.0};
                  foundIndex = c;
                  found = true;
                end
                if not containerButton.inventory:isExplored() then
                  if not isClient() then
                    ItemPicker.fillContainer(containerButton.inventory, self.player)
                  else
                    containerButton.inventory:requestServerItemsForContainer();
                  end
                  containerButton.inventory:setExplored(true);
                end
                self:addChild(containerButton);
                self.backpacks[c] = containerButton;
                c = c + 1;
                self.backpacks[c] = containerButton;
              end
            end
          end

          for i = 0, obs:size() - 1 do
            local o = obs:get(i);
            for containerIndex = 1, o:getContainerCount() do
              local containerButton = nil;
              if instanceof(o, "IsoThumpable") and o:isLockedToCharacter(playerObj) then
                containerButton = ISButton:new(self.width - 32, ((c - 1) * 32) + 15, 32, 32, "", self, nil, nil, true);
                containerButton.textureOverride = getTexture("media/ui/lock.png");
              else
                containerButton = ISButton:new(self.width - 32, ((c - 1) * 32) + 15, 32, 32, "", self, ISInventoryPage.selectContainer, ISInventoryPage.onBackpackMouseDown, true);
                containerButton:setOnMouseOverFunction(ISInventoryPage.onMouseOverButton);
                containerButton:setOnMouseOutFunction(ISInventoryPage.onMouseOutButton);
              end
              containerButton.anchorBottom = false;
              containerButton.anchorRight = true;
              containerButton.anchorTop = false;
              containerButton.anchorLeft = false;
              containerButton:initialise();
              containerButton.borderColor.a = 0.0;
              containerButton.backgroundColor.a = 0.0;
              containerButton.backgroundColorMouseOver = {r = 0.3, g = 0.3, b = 0.3, a = 1.0};
              containerButton.inventory = o:getContainerByIndex(containerIndex - 1);

              if instanceof(o, "IsoThumpable") and o:isLockedByPadlock() and getSpecificPlayer(self.player):getInventory():haveThisKeyId(o:getKeyId()) then
                containerButton.textureOverride = getTexture("media/ui/lockOpen.png");
              end

              containerButton.capacity = containerButton.inventory:getEffectiveCapacity(playerObj);
              if self.containerIconMaps[containerButton.inventory:getType()] ~= nil then
                containerButton:setImage(self.containerIconMaps[containerButton.inventory:getType()]);
              else
                containerButton:setImage(self.conDefault);
              end
              containerButton:forceImageSize(30, 30)
              containerButton.name = "";--getSpecificPlayer(self.player):getDescriptor():getForename().." "..getSpecificPlayer(self.player):getDescriptor():getSurname().."'s " .. item:getName();
              if self.inventoryPane.inventory == containerButton.inventory then
                containerButton.backgroundColor = {r = 0.7, g = 0.7, b = 0.7, a = 1.0};
                foundIndex = c;
                found = true;
              end
              if not containerButton.inventory:isExplored() then

                if not isClient() then
                  ItemPicker.fillContainer(containerButton.inventory, self.player);
                else
                  containerButton.inventory:requestServerItemsForContainer();
                end

                containerButton.inventory:setExplored(true);
              end
              self:addChild(containerButton);
              self.backpacks[c] = containerButton;
              c = c + 1;
              self.backpacks[c] = containerButton;
            end
          end

          local vehicle = gs:getVehicleContainer()
          if vehicle and not vehicleContainers[vehicle] then
            vehicleContainers[vehicle] = true
            for partIndex = 1, vehicle:getPartCount() do
              local vehiclePart = vehicle:getPartByIndex(partIndex - 1)
              if vehiclePart:getItemContainer() and vehicle:canAccessContainer(partIndex - 1, playerObj) then
                local containerButton = ISButton:new(self.width - 32, ((c - 1) * 32) + 15, 32, 32, "", self, ISInventoryPage.selectContainer, ISInventoryPage.onBackpackMouseDown, true);
                containerButton.anchorBottom = false;
                containerButton:setOnMouseOverFunction(ISInventoryPage.onMouseOverButton);
                containerButton:setOnMouseOutFunction(ISInventoryPage.onMouseOutButton);
                containerButton.anchorRight = true;
                containerButton.anchorTop = false;
                containerButton.anchorLeft = false;
                containerButton:initialise();
                containerButton.borderColor.a = 0.0;
                containerButton.backgroundColor.a = 0.0;
                containerButton.backgroundColorMouseOver = {r = 0.3, g = 0.3, b = 0.3, a = 1.0};
                containerButton.inventory = vehiclePart:getItemContainer();
                containerButton.capacity = containerButton.inventory:getEffectiveCapacity(playerObj);
                if self.containerIconMaps[containerButton.inventory:getType()] ~= nil then
                  containerButton:setImage(self.containerIconMaps[containerButton.inventory:getType()]);
                else
                  containerButton:setImage(self.conDefault);
                end
                containerButton:forceImageSize(30, 30)
                containerButton.name = "";
                containerButton.tooltip = getText("IGUI_VehiclePart" .. containerButton.inventory:getType());
                if self.inventoryPane.inventory == containerButton.inventory then
                  containerButton.backgroundColor = {r = 0.7, g = 0.7, b = 0.7, a = 1.0};
                  foundIndex = c;
                  found = true;
                end
                if not containerButton.inventory:isExplored() then
                  if not isClient() then
                    ItemPicker.fillContainer(containerButton.inventory, self.player);
                  else
                    containerButton.inventory:requestServerItemsForContainer();
                  end
                  containerButton.inventory:setExplored(true);
                end
                self:addChild(containerButton);
                self.backpacks[c] = containerButton;
                c = c + 1;
                self.backpacks[c] = containerButton;
              end
            end
          end
        end

      end
      -- print("d");
      local containerButton = ISButton:new(self.width - 32, ((c - 1) * 32) + 15, 32, 32, "", self, ISInventoryPage.selectContainer, ISInventoryPage.onBackpackMouseDown, true);
      containerButton:setImage(self.conFloor);
      containerButton:forceImageSize(30, 30)
      containerButton.anchorBottom = false;
      containerButton:setOnMouseOverFunction(ISInventoryPage.onMouseOverButton);
      containerButton:setOnMouseOutFunction(ISInventoryPage.onMouseOutButton);
      containerButton.anchorRight = true;
      containerButton.anchorTop = false;
      containerButton.anchorLeft = false;
      containerButton:initialise();
      containerButton.borderColor.a = 0.0;
      containerButton.backgroundColor.a = 0.0;
      containerButton.backgroundColorMouseOver = {r = 0.3, g = 0.3, b = 0.3, a = 1.0};
      containerButton.inventory = ISInventoryPage.floorContainer[self.player + 1];
      containerButton.capacity = ISInventoryPage.floorContainer[self.player + 1]:getMaxWeight();
      containerButton.name = "";--getSpecificPlayer(self.player):getDescriptor():getForename().." "..getSpecificPlayer(self.player):getDescriptor():getSurname().."'s " .. item:getName();
      if self.inventoryPane.inventory == containerButton.inventory then
        containerButton.backgroundColor = {r = 0.7, g = 0.7, b = 0.7, a = 1.0};
        foundIndex = c;
        found = true;
      end
      self:addChild(containerButton);
      self.backpacks[c] = containerButton;
      local floor = c;
      c = c + 1;
      -- print("e");
      if not containerButton.inventory:isExplored() then
        if not isClient() then
          ItemPicker.fillContainer(containerButton.inventory, self.player);
        else
          containerButton.inventory:requestServerItemsForContainer();
        end
        containerButton.inventory:setExplored(true);
      end

    end
    --	print("f");
    self.inventoryPane.inventory = self.inventoryPane.lastinventory;
    self.inventory = self.inventoryPane.inventory;
    if self.backpackChoice ~= nil and getSpecificPlayer(self.player):getJoypadBind() ~= -1 then
      if self.backpackChoice >= c then
        if #self.backpacks > 1 then
          self.backpackChoice = 2;
        else
          self.backpackChoice = 1;
        end

      end
      if self.backpacks[self.backpackChoice] ~= nil then
        self.inventoryPane.inventory = self.backpacks[self.backpackChoice].inventory;
        self.capacity = self.backpacks[self.backpackChoice].capacity
      end
    else
      --	    print("g");
      if not self.onCharacter and oldNumBackpacks == 1 and c > 1 then
        self.inventoryPane.inventory = self.backpacks[1].inventory;
        self.capacity = self.backpacks[1].capacity
      elseif found then
        self.capacity = self.backpacks[foundIndex].capacity
      elseif not found and c > 1 then
        if self.backpacks[1] and self.backpacks[1].inventory then
          self.inventoryPane.inventory = self.backpacks[1].inventory;
          self.capacity = self.backpacks[1].capacity
        end
      elseif self.inventoryPane.lastinventory ~= nil then
        self.inventoryPane.inventory = self.inventoryPane.lastinventory;
      end

      --	    print("h");
    end

    if isClient() and (not self.isCollapsed) and (self.inventoryPane.inventory ~= self.inventoryPane.lastinventory) then
      self.inventoryPane.inventory:requestSync();
    end

    if not found then
      self.toggleStove:setVisible(false);
    end
    self.inventoryPane:bringToTop();

    self.resizeWidget2:bringToTop();
    self.resizeWidget:bringToTop();
    --	print("i");

    self.inventory = self.inventoryPane.inventory;
    --	print("j");

    self.title = nil
    for k, containerButton in ipairs(self.backpacks) do
      if containerButton.inventory == self.inventory then
        containerButton.backgroundColor = {r = 0.7, g = 0.7, b = 0.7, a = 1.0}
        self.title = containerButton.name
      else
        containerButton.backgroundColor.a = 0
      end
    end

    if self.inventoryPane ~= nil then self.inventoryPane:refreshContainer(); end
    self:refreshWeight();

    self:syncToggleStove()
  end

  function ISInventoryPage:addContainerButton(container, texture, name, tooltip)
    local titleBarHeight = self:titleBarHeight()
    local playerObj = getSpecificPlayer(self.player)
    local c = #self.backpacks + 1
    local button = ISButton:new(self.width - 32, ((c - 1) * 32) + titleBarHeight - 1, 32, 32, "", self, ISInventoryPage.selectContainer, ISInventoryPage.onBackpackMouseDown, true)
    button.borderColor.a = 0.0
    button.backgroundColor.a = 0.0
    button.backgroundColorMouseOver = {r = 0.3, g = 0.3, b = 0.3, a = 1.0}
    button.anchorLeft = false
    button.anchorTop = false
    button.anchorRight = true
    button.anchorBottom = false
    button:setOnMouseOverFunction(ISInventoryPage.onMouseOverButton)
    button:setOnMouseOutFunction(ISInventoryPage.onMouseOutButton)
    button:initialise()
    button.inventory = container
    button.capacity = container:getEffectiveCapacity(playerObj)
    if instanceof(texture, "Texture") then
      button:setImage(texture)
    else
      if self.containerIconMaps[container:getType()] ~= nil then
        button:setImage(self.containerIconMaps[container:getType()])
      else
        button:setImage(self.conDefault)
      end
    end
    button:forceImageSize(30, 30)
    button.name = name
    button.tooltip = tooltip
    self:addChild(button)
    self.backpacks[c] = button
    return button
  end

  function ISInventoryPage:refreshBackpacks()
    for i, v in ipairs(self.backpacks) do
      self:removeChild(v)
    end

    if ISInventoryPage.floorContainer == nil then
      ISInventoryPage.floorContainer = {}
    end
    if ISInventoryPage.floorContainer[self.player + 1] == nil then
      ISInventoryPage.floorContainer[self.player + 1] = ItemContainer.new("floor", nil, nil, 10, 10)
      ISInventoryPage.floorContainer[self.player + 1]:setExplored(true)
    end

    self.inventoryPane.lastinventory = self.inventoryPane.inventory

    self.inventoryPane:hideButtons()

    local oldNumBackpacks = #self.backpacks
    table.wipe(self.backpacks)

    local containerButton = nil

    local playerObj = getSpecificPlayer(self.player)

    triggerEvent("OnRefreshInventoryWindowContainers", self, "begin")

    if self.onCharacter then
      local name = getText("IGUI_InventoryName", playerObj:getDescriptor():getForename(), playerObj:getDescriptor():getSurname())
      containerButton = self:addContainerButton(playerObj:getInventory(), self.invbasic, name, nil)
      containerButton.capacity = self.inventory:getMaxWeight()
      if not self.capacity then
        self.capacity = containerButton.capacity
      end
      local it = playerObj:getInventory():getItems()
      for i = 0, it:size() - 1 do
        local item = it:get(i)
        if item:getCategory() == "Container" and playerObj:isEquipped(item) or item:getType() == "KeyRing" then
          -- found a container, so create a button for it...
          containerButton = self:addContainerButton(item:getInventory(), item:getTex(), item:getName(), nil)
        end
      end
    elseif playerObj:getVehicle() then
      local vehicle = playerObj:getVehicle()
      for partIndex = 1, vehicle:getPartCount() do
        local vehiclePart = vehicle:getPartByIndex(partIndex - 1)
        if vehiclePart:getItemContainer() and vehicle:canAccessContainer(partIndex - 1, playerObj) then
          local tooltip = getText("IGUI_VehiclePart" .. vehiclePart:getItemContainer():getType())
          containerButton = self:addContainerButton(vehiclePart:getItemContainer(), nil, "", tooltip)
          if not containerButton.inventory:isExplored() then
            if not isClient() then
              ItemPicker.fillContainer(containerButton.inventory, self.player)
            else
              containerButton.inventory:requestServerItemsForContainer()
            end
            containerButton.inventory:setExplored(true)
          end
        end
      end
    else
      local cx = playerObj:getX()
      local cy = playerObj:getY()
      local cz = playerObj:getZ()

      -- Do floor
      local container = ISInventoryPage.floorContainer[self.player + 1]
      container:removeItemsFromProcessItems()
      ISInventoryPage.floorContainer[self.player + 1]:clear()

      local sqs = sqsContainers
      table.wipe(sqs)

      local dir = playerObj:getDir()

      if(dir == IsoDirections.N) then sqs[2] = getCell():getGridSquare(cx - 1, cy - 1, cz) sqs[3] = getCell():getGridSquare(cx, cy - 1, cz) sqs[4] = getCell():getGridSquare(cx + 1, cy - 1, cz)
      elseif (dir == IsoDirections.NE) then sqs[2] = getCell():getGridSquare(cx, cy - 1, cz) sqs[3] = getCell():getGridSquare(cx + 1, cy - 1, cz) sqs[4] = getCell():getGridSquare(cx + 1, cy, cz)
      elseif (dir == IsoDirections.E) then sqs[2] = getCell():getGridSquare(cx + 1, cy - 1, cz) sqs[3] = getCell():getGridSquare(cx + 1, cy, cz) sqs[4] = getCell():getGridSquare(cx + 1, cy + 1, cz)
      elseif (dir == IsoDirections.SE) then sqs[2] = getCell():getGridSquare(cx + 1, cy, cz) sqs[3] = getCell():getGridSquare(cx + 1, cy + 1, cz) sqs[4] = getCell():getGridSquare(cx, cy + 1, cz)
      elseif (dir == IsoDirections.S) then sqs[2] = getCell():getGridSquare(cx + 1, cy + 1, cz) sqs[3] = getCell():getGridSquare(cx, cy + 1, cz) sqs[4] = getCell():getGridSquare(cx - 1, cy + 1, cz)
      elseif (dir == IsoDirections.SW) then sqs[2] = getCell():getGridSquare(cx, cy + 1, cz) sqs[3] = getCell():getGridSquare(cx - 1, cy + 1, cz) sqs[4] = getCell():getGridSquare(cx - 1, cy, cz)
      elseif (dir == IsoDirections.W) then sqs[2] = getCell():getGridSquare(cx - 1, cy + 1, cz) sqs[3] = getCell():getGridSquare(cx - 1, cy, cz) sqs[4] = getCell():getGridSquare(cx - 1, cy - 1, cz)
      elseif (dir == IsoDirections.NW) then sqs[2] = getCell():getGridSquare(cx - 1, cy, cz) sqs[3] = getCell():getGridSquare(cx - 1, cy - 1, cz) sqs[4] = getCell():getGridSquare(cx, cy - 1, cz)
      end

      local vehicleContainers = sqsVehicles
      table.wipe(vehicleContainers)

      sqs[1] = getCell():getGridSquare(cx, cy, cz)
      for x = 1, 4 do
        local gs = sqs[x]

        -- stop grabbing thru walls...
        local currentSq = playerObj:getCurrentSquare()
        if gs ~= currentSq and currentSq and currentSq:isBlockedTo(gs) then
          gs = nil
        end

        -- don't show containers in safehouse if you're not allowed
        if gs and isClient() and SafeHouse.isSafeHouse(gs, playerObj:getUsername(), true) and not getServerOptions():getBoolean("SafehouseAllowLoot") then
          gs = nil
        end

        if gs ~= nil then
          local wobs = gs:getWorldObjects()
          for i = 0, wobs:size() - 1 do
            local o = wobs:get(i)
            -- FIXME: An item can be in only one container in coop the item won't be displayed for every player.
            ISInventoryPage.floorContainer[self.player + 1]:AddItem(o:getItem())
            if o:getItem() and o:getItem():getCategory() == "Container" then
              local item = o:getItem()
              containerButton = self:addContainerButton(item:getInventory(), item:getTex(), item:getName(), nil)
            end
          end

          local sobs = gs:getStaticMovingObjects()
          for i = 0, sobs:size() - 1 do
            local so = sobs:get(i)
            local doIt = true
            if so:getContainer() ~= nil then
              -- if container is locked with a padlock and we don't have the key, return
              if instanceof(so, "IsoThumpable") and so:isLockedByPadlock() and not playerObj:getInventory():haveThisKey(so:getKeyId()) then
                doIt = false
              end

              if doIt then
                containerButton = self:addContainerButton(so:getContainer(), nil, "", nil)
                if not containerButton.inventory:isExplored() then
                  if not isClient() then
                    ItemPicker.fillContainer(containerButton.inventory, self.player)
                  else
                    containerButton.inventory:requestServerItemsForContainer()
                  end
                  containerButton.inventory:setExplored(true)
                end
              end
            end
          end

          local obs = gs:getObjects()
          for i = 0, obs:size() - 1 do
            local o = obs:get(i)
            for containerIndex = 1, o:getContainerCount() do
              containerButton = self:addContainerButton(o:getContainerByIndex(containerIndex - 1), nil, "", nil)
              if instanceof(o, "IsoThumpable") and o:isLockedToCharacter(playerObj) then
                containerButton.onclick = nil
                containerButton.onmousedown = nil
                containerButton:setOnMouseOverFunction(nil)
                containerButton:setOnMouseOutFunction(nil)
                containerButton.textureOverride = getTexture("media/ui/lock.png")
              end

              if instanceof(o, "IsoThumpable") and o:isLockedByPadlock() and playerObj:getInventory():haveThisKeyId(o:getKeyId()) then
                containerButton.textureOverride = getTexture("media/ui/lockOpen.png")
              end

              if not containerButton.inventory:isExplored() then
                if not isClient() then
                  ItemPicker.fillContainer(containerButton.inventory, self.player)
                else
                  containerButton.inventory:requestServerItemsForContainer()
                end
                containerButton.inventory:setExplored(true)
              end
            end
          end

          local vehicle = gs:getVehicleContainer()
          if vehicle and not vehicleContainers[vehicle] then
            vehicleContainers[vehicle] = true
            for partIndex = 1, vehicle:getPartCount() do
              local vehiclePart = vehicle:getPartByIndex(partIndex - 1)
              if vehiclePart:getItemContainer() and vehicle:canAccessContainer(partIndex - 1, playerObj) then
                local tooltip = getText("IGUI_VehiclePart" .. vehiclePart:getItemContainer():getType())
                containerButton = self:addContainerButton(vehiclePart:getItemContainer(), nil, "", tooltip)
                if not containerButton.inventory:isExplored() then
                  if not isClient() then
                    ItemPicker.fillContainer(containerButton.inventory, self.player)
                  else
                    containerButton.inventory:requestServerItemsForContainer()
                  end
                  containerButton.inventory:setExplored(true)
                end
              end
            end
          end
        end
      end

      triggerEvent("OnRefreshInventoryWindowContainers", self, "beforeFloor")

      containerButton = self:addContainerButton(ISInventoryPage.floorContainer[self.player + 1], self.conFloor, "", nil)
      containerButton.capacity = ISInventoryPage.floorContainer[self.player + 1]:getMaxWeight()
    end

    triggerEvent("OnRefreshInventoryWindowContainers", self, "buttonsAdded")

    local found = false
    local foundIndex = -1
    for index, containerButton in ipairs(self.backpacks) do
      if containerButton.inventory == self.inventoryPane.inventory then
        foundIndex = index
        found = true
        break
      end
    end

    self.inventoryPane.inventory = self.inventoryPane.lastinventory
    self.inventory = self.inventoryPane.inventory
    if self.backpackChoice ~= nil and playerObj:getJoypadBind() ~= -1 then
      if self.backpackChoice > #self.backpacks then
        if #self.backpacks > 1 then
          self.backpackChoice = 2
        else
          self.backpackChoice = 1
        end
      end
      if self.backpacks[self.backpackChoice] ~= nil then
        self.inventoryPane.inventory = self.backpacks[self.backpackChoice].inventory
        self.capacity = self.backpacks[self.backpackChoice].capacity
      end
    else
      if not self.onCharacter and oldNumBackpacks == 1 and #self.backpacks > 1 then
        self.inventoryPane.inventory = self.backpacks[1].inventory
        self.capacity = self.backpacks[1].capacity
      elseif found then
        self.capacity = self.backpacks[foundIndex].capacity
      elseif not found and #self.backpacks > 0 then
        if self.backpacks[1] and self.backpacks[1].inventory then
          self.inventoryPane.inventory = self.backpacks[1].inventory
          self.capacity = self.backpacks[1].capacity
        end
      elseif self.inventoryPane.lastinventory ~= nil then
        self.inventoryPane.inventory = self.inventoryPane.lastinventory
      end
    end

    if isClient() and (not self.isCollapsed) and (self.inventoryPane.inventory ~= self.inventoryPane.lastinventory) then
      self.inventoryPane.inventory:requestSync()
    end

    if not found then
      self.toggleStove:setVisible(false)
    end

    self.inventoryPane:bringToTop()
    self.resizeWidget2:bringToTop()
    self.resizeWidget:bringToTop()

    self.inventory = self.inventoryPane.inventory

    self.title = nil
    for k, containerButton in ipairs(self.backpacks) do
      if containerButton.inventory == self.inventory then
        containerButton.backgroundColor = {r = 0.7, g = 0.7, b = 0.7, a = 1.0}
        self.title = containerButton.name
      else
        containerButton.backgroundColor.a = 0
      end
    end

    if self.inventoryPane ~= nil then
      self.inventoryPane:refreshContainer()
    end

    self:refreshWeight()

    self:syncToggleStove()

    triggerEvent("OnRefreshInventoryWindowContainers", self, "end")
  end

  --************************************************************************--
  --** ISInventoryPage:new
  --**
  --************************************************************************--
  function ISInventoryPage:new (x, y, width, height, inventory, onCharacter, zoom)
    local o = {}
    --o.data = {}
    o = ISPanel:new(x, y, width, height);
    setmetatable(o, self)
    self.__index = self
    o.x = x;
    o.y = y;
    o.anchorLeft = true;
    o.anchorRight = true;
    o.anchorTop = true;
    o.anchorBottom = true;
    o.borderColor = {r = 0.4, g = 0.4, b = 0.4, a = 1};
    o.backgroundColor = {r = 0, g = 0, b = 0, a = 0.8};
    o.width = width;
    o.height = height;
    o.anchorLeft = true;
    o.backpackChoice = 1;
    o.zoom = zoom;
    o.isCollapsed = true;
    if o.zoom == nil then o.zoom = 1; end

    o.inventory = inventory;
    o.onCharacter = onCharacter;
    o.titlebarbkg = getTexture("media/ui/Panel_TitleBar.png");
    o.infoBtn = getTexture("media/ui/Panel_info_button.png");
    o.statusbarbkg = getTexture("media/ui/Panel_StatusBar.png");
    o.resizeimage = getTexture("media/ui/Panel_StatusBar_Resize.png");
    o.invbasic = getTexture("media/ui/Icon_InventoryBasic.png");
    o.closebutton = getTexture("media/ui/Dialog_Titlebar_CloseIcon.png");
    o.collapsebutton = getTexture("media/ui/Panel_Icon_Collapse.png");
    o.pinbutton = getTexture("media/ui/Panel_Icon_Pin.png");

    o.conFloor = getTexture("media/ui/Container_Floor.png");
    o.conOven = getTexture("media/ui/Container_Oven.png");
    o.conCabinet = getTexture("media/ui/Container_Cabinet.png");
    o.conSack = getTexture("media/ui/Container_Sack.png");
    o.conShelf = getTexture("media/ui/Container_Shelf.png");
    o.conCounter = getTexture("media/ui/Container_Counter.png");
    o.conMedicine = getTexture("media/ui/Container_Medicine.png");
    o.conGarbage = getTexture("media/ui/Container_Garbage.png");
    o.conFridge = getTexture("media/ui/Container_Fridge.png");
    o.conFreezer = getTexture("media/ui/Container_Freezer.png");
    o.conDrawer = getTexture("media/ui/Container_Drawer.png");
    o.conCrate = getTexture("media/ui/Container_Crate.png");
    o.conFemaleZombie = getTexture("media/ui/Container_DeadPerson_FemaleZombie.png");
    o.conMaleZombie = getTexture("media/ui/Container_DeadPerson_MaleZombie.png");
    o.conMicrowave = getTexture("media/ui/Container_Microwave.png");
    o.conVending = getTexture("media/ui/Container_Vendingt.png");
    o.logs = getTexture("media/ui/Item_Logs.png");
    o.plant = getTexture("media/ui/Container_Plant.png");
    o.campfire = getTexture("media/ui/Container_Campfire.png");
    o.conglovebox = getTexture("media/ui/Container_GloveCompartment.png");
    o.conseat = getTexture("media/ui/Container_Carseat.png");
    o.contrunk = getTexture("media/ui/Container_TruckBed.png");

    o.conDefault = o.conShelf;
    o.highlightColors = {r = 0.98, g = 0.56, b = 0.11};

    o.containerIconMaps = {
      floor = o.conFloor,
      crate = o.conCrate,
      officedrawers = o.conDrawer,
      bin = o.conGarbage,
      fridge = o.conFridge,
      sidetable = o.conDrawer,
      wardrobe = o.conCabinet,
      counter = o.conCounter,
      medicine = o.conMedicine,
      barbecue = o.conOven,
      fireplace = o.conOven,
      woodstove = o.conOven,
      stove = o.conOven,
      shelves = o.conShelf,
      filingcabinet = o.conCabinet,
      garage_storage = o.conCrate,
      smallcrate = o.conCrate,
      smallbox = o.conCrate,
      inventorymale = o.conMaleZombie;
      inventoryfemale = o.conFemaleZombie;
      microwave = o.conMicrowave;
      vendingGt = o.conVending;
      logs = o.logs;
      fruitbusha = o.plant;
      fruitbushb = o.plant;
      fruitbushc = o.plant;
      fruitbushd = o.plant;
      fruitbushe = o.plant;
      corn = o.plant;
      vendingsnack = o.conVending;
      vendingpop = o.conVending;
      campfire = o.campfire;
      freezer = o.conFreezer;
      icecream = o.conFreezer;
      GloveBox = o.conglovebox;
      SeatRearLeft = o.conseat;
      SeatMiddleRight = o.conseat;
      SeatRearRight = o.conseat;
      SeatMiddleLeft = o.conseat;
      SeatFrontLeft = o.conseat;
      SeatFrontRight = o.conseat;
      TruckBed = o.contrunk;
      TruckBedOpen = o.contrunk;
    }

    o.pin = true;
    o.isCollapsed = false;
    o.backpacks = {}
    o.collapseCounter = 0;
    o.title = nil;
    o.titleFont = UIFont.Small
    o.titleFontHgt = getTextManager():getFontHeight(o.titleFont)
    return o
  end

  function ISInventoryPage:onMouseOverButton(button, x, y)
    self.mouseOverButton = button;
  end

  function ISInventoryPage:onMouseOutButton(button, x, y)
    self.mouseOverButton = nil;
  end

  function ISInventoryPage:canPutIn(doMain)
    if not self.mouseOverButton or self.mouseOverButton.inventory == nil then
      return false;
    end
    if self.mouseOverButton.inventory:getType() == "floor" then
      return true;
    end

    -- if we're not over a container
    if not self.mouseOverButton then
      return true;
    end
    -- we count the total weight of our container
    local totalWeight = ISInventoryPage.loadWeight(self.mouseOverButton.inventory);
    --~ 	self.mouseOverButton.inventory:getWeight();
    local inventoryItem = nil;
    for i, v in ipairs(ISMouseDrag.dragging) do
      if instanceof(v, "InventoryItem") then

        if self.mouseOverButton.inventory == v:getContainer() then
          return true;
        end

        if self.mouseOverButton.inventory:getOnlyAcceptCategory() and v:getCategory() ~= self.mouseOverButton.inventory:getOnlyAcceptCategory() then
          return false;
        end

        -- you can't draw the container in himself
        --~ 			print(self.mouseOverButton.inventory);
        --~ 			print(v);

        if not inventoryItem then
          inventoryItem = v;
          totalWeight = totalWeight + v:getActualWeight();
        elseif inventoryItem ~= v then
          totalWeight = totalWeight + v:getActualWeight();
        end
        --~ 			totalWeight = totalWeight + v:getActualWeight();
      else
        for i2, v2 in ipairs(v.items) do
          --~ 				print("notinstanceitem");
          --~ 				print(v2);
          --~ 				print(self.mouseOverButton.inventory);
          -- you can't draw the container in himself
          if (self.mouseOverButton.inventory:isInside(v2)) then
            return false;
          end

          if self.mouseOverButton.inventory == v2:getContainer() then
            return true;
          end

          if self.mouseOverButton.inventory:getOnlyAcceptCategory() and v2:getCategory() ~= self.mouseOverButton.inventory:getOnlyAcceptCategory() then
            return false;
          end

          -- first is a dummy
          if not inventoryItem then
            inventoryItem = v2;
            totalWeight = totalWeight + v2:getActualWeight();
          elseif inventoryItem ~= v2 then
            totalWeight = totalWeight + v2:getActualWeight();
          end
        end
      end
      --~ 		print(#v.items .. " " .. totalWeight);
    end

    return true;

  end

  function ISInventoryPage:RestoreLayout(name, layout)
    ISLayoutManager.DefaultRestoreWindow(self, layout)
    if layout.pin == 'true' then
      self:setPinned()
    end
    self.inventoryPane:RestoreLayout(name, layout)
  end

  function ISInventoryPage:SaveLayout(name, layout)
    ISLayoutManager.DefaultSaveWindow(self, layout)
    if self.pin then layout.pin = 'true' else layout.pin = 'false' end
    self.inventoryPane:SaveLayout(name, layout)
  end

  ISInventoryPage.onKeyPressed = function(key)
    if key == getCore():getKey("Toggle Inventory") and getSpecificPlayer(0) and getPlayerInventory(0) then
      getPlayerInventory(0):setVisible(not getPlayerInventory(0):getIsVisible());
      getPlayerLoot(0):setVisible(getPlayerInventory(0):getIsVisible());
    end
  end

  ISInventoryPage.toggleInventory = function()
    if ISInventoryPage.playerInventory:getIsVisible() then
      ISInventoryPage.playerInventory:setVisible(false);
    else
      ISInventoryPage.playerInventory:setVisible(true);
    end
  end

  ISInventoryPage.onInventoryFontChanged = function()
    for i = 1, getNumActivePlayers() do
      local pdata = getPlayerData(i - 1)
      if pdata then
        pdata.playerInventory.inventoryPane:onInventoryFontChanged()
        pdata.lootInventory.inventoryPane:onInventoryFontChanged()
      end
    end
  end

  -- Called when an object with a container is added/removed from the world.
  -- Added this to handle campfire containers.
  ISInventoryPage.OnContainerUpdate = function(object)
    ISInventoryPage.renderDirty = true
  end

  ISInventoryPage.ongamestart = function()
    ISInventoryPage.renderDirty = true;
  end

  Events.OnKeyPressed.Add(ISInventoryPage.onKeyPressed);
  Events.OnContainerUpdate.Add(ISInventoryPage.OnContainerUpdate)

  --Events.OnCreateUI.Add(testInventory);

  Events.OnGameStart.Add(ISInventoryPage.ongamestart);
