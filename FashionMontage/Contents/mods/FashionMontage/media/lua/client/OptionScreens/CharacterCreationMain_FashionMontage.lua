require "OptionScreens/CharacterCreationMain"

CharacterCreationMain = CharacterCreationMain or {}
local doClothingCombo_original = CharacterCreationMain.doClothingCombo



function CharacterCreationMain:doClothingCombo(definition, erasePrevious, ...)

  if not self.clothingPanel then return; end

  -- reinit all combos
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

  -- create new combo or populate existing one (for when having specific profession clothing)
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

    for j, clothing in ipairs(profTable.items) do
      local item = ScriptManager.instance:FindItem(clothing)
      local displayName = item:getDisplayName()
      -- some clothing are president in default list AND profession list, so we can force a specific clothing in profession we already have
      if not combo:contains(displayName) then
        combo:addOptionWithData(displayName, clothing)
      else
        unique = false
        suffix = 2
        while not unique do
          -- filename = "checkbook"
          -- filename = filename .. ".tmp"
          newDisplayName = displayName .. '_' .. tostring(suffix)
          if not combo:contains(newDisplayName) then
            combo:addOptionWithData(newDisplayName, clothing)
            unique = true
          else
            suffix = suffix + 1
          end
          -- displayName
        end

      end
    end
  end

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
