require "OptionScreens/CharacterCreationMain"

CharacterCreationMain = CharacterCreationMain or {}
local doClothingCombo_original = CharacterCreationMain.doClothingCombo
local updateSelectedClothingCombo_original = CharacterCreationMain.updateSelectedClothingCombo

function CharacterCreationMain:getNewDropdownNameOGSN(itemName)
  -- itemName is Base.Earring_LoopSmall_Silver_Top
  -- item is Item{Module: Base, Name:Earring_LoopSmall_Silver_Top, Type:Clothing}
  -- displayName is Small Silver Looped Earrings (Top)
  -- weaponSprite is "nil" or whatever; expected and similar to displayName response
  print('getting new dropdown name, current name is ')
  print()
  print('item')
  local item = ScriptManager.instance:FindItem(itemName)
  print(item)
  local translationFetchName = "UI_"..itemName
  print('translationName')
  local translationName = getText(translationFetchName)
  print(translationName)
  print('weaponSprite')
  local weaponSprite = item:getWeaponSprite() or "nil"; -- First implementation
  print(weaponSprite)
  print('displayName')
  local displayName = item:getDisplayName() -- The normal translated name
  print(displayName)
  local dropdownName = "";
  if translationName ~= translationFetchName then
    dropdownName = translationName;
    else if weaponSprite ~= "nil" then
      dropdownName = displayName .. " - " .. weaponSprite;
    else
      dropdownName = displayName;
    end
    return dropdownName
  end
end

  function CharacterCreationMain:updateSelectedClothingCombo(...)
    print('in updateSelectedClothingCombo')
    local desc = MainScreen.instance.desc;
    print('desc')
    print(desc)
    if self.clothingCombo then
      print("self.clothingCombo")
      print(self.clothingCombo)
      for i, combo in pairs(self.clothingCombo) do
        print("in for i, combo in pairs(self.clothingCombo) do")
        print("i")
        print(i)
        print('combo')
        print(combo) -- table 0x555493789
        combo.selected = 1;
        self.clothingColorBtn[combo.bodyLocation]:setVisible(false);
        self.clothingTextureCombo[combo.bodyLocation]:setVisible(false);
        local currentItem = desc:getWornItem(combo.bodyLocation);
        if currentItem then
          -- currentItem ==> Clothing{ clothingItemName="AmmoStrap_Bullets" }
          local currentItemType = currentItem:getType() -- Base
          local currentItemModule = currentItem:getModule() -- AmmoStrap_Bullets
          local currentItemName = currentItemModule .. '.' .. currentItemType -- Base.AmmoStrap_Bullets
          -- local item = ScriptManager.instance:FindItem(currentItemName)
          local dropdownName = self:getNewDropdownNameOGSN(currentItemName);
          -- combo.options ==>  -- table 0x3400725251
          for j, v in ipairs(combo.options) do
            -- j  ==>  2
            -- v ==> table 0x2100484251
            -- v.text ==> Socks
            if v.text == dropdownName then
              combo.selected = j;
              break
            end
          end
          self:updateColorButton(combo.bodyLocation, currentItem);
          self:updateClothingTextureCombo(combo.bodyLocation, currentItem);
        end
      end
    end
  end

  function CharacterCreationMain:doClothingCombo(definition, erasePrevious, ...)
    print('in doClothingCombo')
    if not self.clothingPanel then return; end

    if erasePrevious then
      if self.clothingCombo then
        for i, v in pairs(self.clothingCombo) do
          self.clothingPanel:removeChild(self.clothingColorBtn[v.bodyLocation]);
          self.clothingPanel:removeChild(self.clothingTextureCombo[v.bodyLocation]);
          self.clothingPanel:removeChild(self.clothingComboLabel[v.bodyLocation]);
          self.clothingPanel:removeChild(v);
        end
      end
      self.clothingCombo = {};
      self.clothingColorBtn = {};
      self.clothingTextureCombo = {};
      self.clothingComboLabel = {};
      self.yOffset = self.originalYOffset;
    end

    local desc = MainScreen.instance.desc;
    for bodyLocation, profTable in pairs(definition) do
      local combo = nil;
      if self.clothingCombo then
        combo = self.clothingCombo[bodyLocation]
      end
      if not combo then
        self:createClothingCombo(getText("UI_ClothingType_" .. bodyLocation), bodyLocation);
        combo = self.clothingCombo[bodyLocation];
        combo:addOptionWithData(getText("UI_characreation_clothing_none"), nil)
      end
      if erasePrevious then
        combo.options = {}
        combo:addOptionWithData(getText("UI_characreation_clothing_none"), nil)
      end
      print(combo)
      print('combo')
      for j, clothing in ipairs(profTable.items) do
        -- print('in for j, clothing in ipairs(profTable.items) do')
        -- print('j')
        -- print(j) -- 12
        -- print('clothing')
        -- print(clothing) --  Base.Earring_Pearl
        -- print('item')
        -- local item = ScriptManager.instance:FindItem(clothing)
        -- print(item) -- Item{Module: Base, Name:Earring_Pearl, Type:Clothing}
        -- print('about to try to define its dropdown name using getNewDropdownNameOGSN ')
        local dropdownName = self:getNewDropdownNameOGSN(clothing)
        -- print('just left getNewDropdownNameOGSN was testing item:')
        -- print(item)
        -- print('its dropdownName is:')
        -- print(dropdownName)
        if not combo:contains(dropdownName) then
          combo:addOptionWithData(dropdownName, clothing)
        end
      end
    end

    print('about to call updateSelectedClothingCombo (from within doClothingCombo)')
    self:updateSelectedClothingCombo();

    self.clothingPanel:setScrollChildren(true)
    self.clothingPanel:setScrollHeight(self.yOffset)
    self.clothingPanel:addScrollBars()

    self.colorPicker = ISColorPicker:new(0, 0, {h = 1, s = 0.6, b = 0.9});
    self.colorPicker:initialise()
    self.colorPicker.keepOnScreen = true
    self.colorPicker.pickedTarget = self
    self.colorPicker.resetFocusTo = self.clothingPanel
  end


  return CharacterCreationMain
