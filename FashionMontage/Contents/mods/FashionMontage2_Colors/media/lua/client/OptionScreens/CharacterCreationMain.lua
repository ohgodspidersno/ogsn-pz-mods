--***********************************************************
--**                   ROBERT JOHNSON                      **
--***********************************************************

require "ISUI/ISPanel"
require "ISUI/ISButton"
require "ISUI/ISInventoryPane"
require "ISUI/ISResizeWidget"
require "ISUI/ISMouseDrag"

require "defines"

CharacterCreationMain = ISPanelJoypad:derive("CharacterCreationMain");
CharacterCreationMain.debug = getDebug() and getDebugOptions():getBoolean("Character.Create.AllOutfits")
CharacterCreationMain.savefile = "saved_outfits.txt";

local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)
local FONT_HGT_MEDIUM = getTextManager():getFontHeight(UIFont.Medium)

function CharacterCreationMain:initialise()
	ISPanelJoypad.initialise(self);
end
--************************************************************************--
--** ISPanel:instantiate
--**
--************************************************************************--
function CharacterCreationMain:instantiate()
	
	--self:initialise();
	self.javaObject = UIElement.new(self);
	self.javaObject:setX(self.x);
	self.javaObject:setY(self.y);
	self.javaObject:setHeight(self.height);
	self.javaObject:setWidth(self.width);
	self.javaObject:setAnchorLeft(self.anchorLeft);
	self.javaObject:setAnchorRight(self.anchorRight);
	self.javaObject:setAnchorTop(self.anchorTop);
	self.javaObject:setAnchorBottom(self.anchorBottom);
	self:createChildren();
end

function CharacterCreationMain:create()
	self.maletex = getTexture("media/ui/maleicon.png");
	self.femaletex = getTexture("media/ui/femaleicon.png");
	local w = self.width * 0.75;
	if(w < 768) then
		w = 768;
	end
	local tw = self.width;
	local mainPanelY = 48
	local mainPanelPadBottom = 80
	if getCore():getScreenHeight() <= 600 then
		mainPanelPadBottom = 16
	end
	self.mainPanel = ISPanel:new((tw-w)/2, 48, w, self.height - mainPanelPadBottom - mainPanelY);
	self.mainPanel.backgroundColor = {r=0, g=0, b=0, a=0.8};
	self.mainPanel.borderColor = {r=1, g=1, b=1, a=0.5};
	
	self.mainPanel:initialise();
	self.mainPanel:setAnchorRight(true);
	self.mainPanel:setAnchorLeft(true);
	self.mainPanel:setAnchorBottom(true);
	self.mainPanel:setAnchorTop(true);
	self:addChild(self.mainPanel);
	
	-- we add the header (contain forename/surname/avatar/...)
	MainScreen.instance.charCreationHeader:setX(self.mainPanel:getX());
	MainScreen.instance.charCreationHeader:setY(self.mainPanel:getY());
	MainScreen.instance.charCreationHeader:setWidth(MainScreen.instance.charCreationHeader.forenameEntry:getRight());
	MainScreen.instance.charCreationHeader:setAnchorRight(false);
	MainScreen.instance.charCreationHeader:setAnchorLeft(true);
	MainScreen.instance.charCreationHeader:setAnchorBottom(false);
	MainScreen.instance.charCreationHeader:setAnchorTop(true);
	
	self:addChild(MainScreen.instance.charCreationHeader);
	
	-- HAIR TYPE SELECTION
	self.xOffset = MainScreen.instance.charCreationHeader.avatarPanel:getRight() + 24
	self.yOffset = 64+96+6+40;
	self.comboWid = 200
	self:createChestTypeBtn();
	self:createHairTypeBtn();
	self:createBeardTypeBtn();
	
	-- CLOTHING
	self.yOffset = CharacterCreationHeader.instance.avatarPanel.y;
	self:createClothingBtn();
	
	local buttonHgt = FONT_HGT_SMALL + 3 * 2
	
	-- BOTTOM BUTTON
	self.backButton = ISButton:new(16, self.mainPanel.height - 5 - buttonHgt, 100, buttonHgt, getText("UI_btn_back"), self, self.onOptionMouseDown);
	self.backButton.internal = "BACK";
	self.backButton:initialise();
	self.backButton:instantiate();
	self.backButton:setAnchorLeft(true);
	self.backButton:setAnchorTop(false);
	self.backButton:setAnchorBottom(true);
	self.backButton.borderColor = {r=1, g=1, b=1, a=0.1};
	self.backButton.setJoypadFocused = self.setJoypadFocusedBButton
	self.mainPanel:addChild(self.backButton);
	
	self.savedBuilds = ISComboBox:new(self.backButton:getRight() + 22, self.backButton.y, 250, buttonHgt, self, CharacterCreationMain.loadOutfit);
	self.savedBuilds:setAnchorTop(false);
	self.savedBuilds:setAnchorBottom(true);
	self.savedBuilds.openUpwards = true;
	self.mainPanel:addChild(self.savedBuilds)

	self.savedBuilds.noSelectionText = getText("UI_characreation_SelectToLoad")
	local saved_builds = CharacterCreationMain.readSavedOutfitFile();
	for key,val in pairs(saved_builds) do
		self.savedBuilds:addOption(key)
	end
    self.savedBuilds.selected = 0 -- no selection

	self.saveBuildButton = ISButton:new(self.savedBuilds:getRight() + 10, self.savedBuilds.y, 50, buttonHgt, getText("UI_characreation_BuildSave"), self, self.saveBuildStep1);
	self.saveBuildButton:initialise();
	self.saveBuildButton:instantiate();
	self.saveBuildButton:setAnchorLeft(true);
	self.saveBuildButton:setAnchorRight(false);
	self.saveBuildButton:setAnchorTop(false);
	self.saveBuildButton:setAnchorBottom(true);
	self.saveBuildButton.borderColor = { r = 1, g = 1, b = 1, a = 0.1 };
	self.mainPanel:addChild(self.saveBuildButton);

	self.deleteBuildButton = ISButton:new(self.saveBuildButton:getRight() + 10, self.saveBuildButton:getY(), 50, buttonHgt, getText("UI_characreation_BuildDel"), self, self.deleteBuildStep1);
	self.deleteBuildButton:initialise();
	self.deleteBuildButton:instantiate();
	self.deleteBuildButton:setAnchorLeft(true);
	self.deleteBuildButton:setAnchorRight(false);
	self.deleteBuildButton:setAnchorTop(false);
	self.deleteBuildButton:setAnchorBottom(true);
	self.deleteBuildButton.borderColor = { r = 1, g = 1, b = 1, a = 0.1 };
	self.mainPanel:addChild(self.deleteBuildButton);
	
	self.playButton = ISButton:new(self.mainPanel.width - 116, self.mainPanel.height - 5 - buttonHgt, 100, buttonHgt, getText("UI_btn_play"), self, self.onOptionMouseDown);
	self.playButton.internal = "NEXT";
	self.playButton:initialise();
	self.playButton:instantiate();
	self.playButton:setAnchorLeft(false);
	self.playButton:setAnchorRight(true);
	self.playButton:setAnchorTop(false);
	self.playButton:setAnchorBottom(true);
	self.playButton:setEnable(true); -- sets the hard-coded border color
	self.playButton.setJoypadFocused = self.setJoypadFocusedAButton
	self.mainPanel:addChild(self.playButton);
	
	local textWid = getTextManager():MeasureStringX(UIFont.Small, getText("UI_characreation_random"))
	local buttonWid = math.max(100, textWid + 8 * 2)
	self.randomButton = ISButton:new(self.playButton:getX() - 10 - buttonWid, self.playButton:getY(), buttonWid, buttonHgt, getText("UI_characreation_random"), self, self.onOptionMouseDown);
	self.randomButton.internal = "RANDOM";
	self.randomButton:initialise();
	self.randomButton:instantiate();
	self.randomButton:setAnchorLeft(false);
	self.randomButton:setAnchorRight(true);
	self.randomButton:setAnchorTop(false);
	self.randomButton:setAnchorBottom(true);
	self.randomButton.borderColor = { r = 1, g = 1, b = 1, a = 0.1 };
	self.backButton.setJoypadFocused = self.setJoypadFocusedYButton
	self.mainPanel:addChild(self.randomButton);
	
	-- Hack: CharacterCreationHeader.avatarPanel overlaps this
	local panel = CharacterCreationHeader.instance.avatarPanel
	self.avatarPanelX = panel.x
	local absX,absY = panel:getAbsoluteX(),panel:getAbsoluteY()
	panel:setX(absX - self:getAbsoluteX())
	panel:setY(absY - self:getAbsoluteY())
	CharacterCreationHeader.instance:removeChild(panel)
	self:addChild(panel)
	
	-- DISABLE BUTTON
	self:disableBtn();
end

function CharacterCreationMain:deleteBuildStep1()
	local delBuild = self.savedBuilds.options[self.savedBuilds.selected]
	local screenW = getCore():getScreenWidth()
	local screenH = getCore():getScreenHeight()
	local modal = ISModalDialog:new((screenW - 230) / 2, (screenH - 120) / 2, 230, 120, getText("UI_characreation_BuildDeletePrompt", delBuild), true, self, CharacterCreationMain.deleteBuildStep2);
	modal.backgroundColor.a = 0.9
	modal:initialise()
	modal:setCapture(true)
	modal:addToUIManager()
	modal:setAlwaysOnTop(true)
	if self.joyfocus then
		modal.param1 = self.joyfocus
		self.joyfocus.focus = modal
		updateJoypadFocus(self.joyfocus)
	end
end

function CharacterCreationMain:deleteBuildStep2(button, joypadData) -- {{{
	if joypadData then
		joypadData.focus = self
		updateJoypadFocus(joypadData)
	end
	
	if button.internal == "NO" then return end
	
	local delBuild = self.savedBuilds.options[self.savedBuilds.selected];
	
	local builds = CharacterCreationMain.readSavedOutfitFile();
	builds[delBuild] = nil;
	
	local options = {};
	CharacterCreationMain.writeSaveFile(builds);
	for key,val in pairs(builds) do
		if key ~= nil and val ~= nil then
			options[key] = 1;
		end
	end
	
	self.savedBuilds.options = {};
	for key,val in pairs(options) do
		table.insert(self.savedBuilds.options, key);
	end
	if self.savedBuilds.selected > #self.savedBuilds.options then
		self.savedBuilds.selected = #self.savedBuilds.options
	end
	self:loadOutfit(self.savedBuilds)
	--    luautils.okModal("Deleted build "..delBuild.."!", true);
end

function CharacterCreationMain:saveBuildStep1()
	local firstName = MainScreen.instance.charCreationHeader.forenameEntry:getText()
	local lastName = MainScreen.instance.charCreationHeader.surnameEntry:getText()
	local text = firstName:trim() .. " " .. lastName:trim()
	if text == " " then
		text = "Preset"
	end
	self.inputModal = BCRC.inputModal(true, nil, nil, nil, nil, text, CharacterCreationMain.saveBuildStep2, self);
	self.inputModal.backgroundColor.a = 0.9
	self.inputModal:setValidateFunction(self, self.saveBuildValidate)
	if self.joyfocus then
		self.inputModal.param1 = self.joyfocus
		self.joyfocus.focus = self.inputModal
		updateJoypadFocus(self.joyfocus)
	end
end

function CharacterCreationMain:saveBuildStep2(button, joypadData, param2)
	if joypadData then
		joypadData.focus = self
		updateJoypadFocus(joypadData)
	end
	
	if button.internal == "CANCEL" then
		return
	end
	
	local savename = button.parent.entry:getText()
	if savename == '' then return end
	
	local desc = MainScreen.instance.desc;
	
	local builds = CharacterCreationMain.readSavedOutfitFile();
	local savestring = "gender=" .. MainScreen.instance.charCreationHeader.genderCombo.selected .. ";";
	savestring = savestring .. "skincolor=" .. self.colorPickerSkin.index .. "|" .. self.skinColorButton.backgroundColor.r .. "," .. self.skinColorButton.backgroundColor.g .. "," .. self.skinColorButton.backgroundColor.b .. ";";
	savestring = savestring .. "name=" .. MainScreen.instance.charCreationHeader.forenameEntry:getText() .. "|" .. MainScreen.instance.charCreationHeader.surnameEntry:getText() .. ";";
	savestring = savestring .. "hair=" .. self.hairTypeCombo.selected .. "|" .. self.hairColorButton.backgroundColor.r .. "," .. self.hairColorButton.backgroundColor.g .. "," .. self.hairColorButton.backgroundColor.b .. ";";
	if not desc:isFemale() then
		savestring = savestring .. "chesthair=" .. self.chestHairCombo.selected .. ";";
		savestring = savestring .. "beard=" .. self.beardTypeCombo.selected .. ";";
	end
	for i,v in pairs(self.clothingCombo) do
		if v:getOptionText(v.selected) ~= "None" then
			savestring = savestring ..  i .. "=" .. v:getOptionText(v.selected);
			if self.clothingColorBtn[i] and self.clothingColorBtn[i]:isVisible() then
				savestring = savestring .. "|" .. self.clothingColorBtn[i].backgroundColor.r .. "," .. self.clothingColorBtn[i].backgroundColor.g  .. "," .. self.clothingColorBtn[i].backgroundColor.b;
			end
			if self.clothingTextureCombo[i] and self.clothingTextureCombo[i]:isVisible() then
				savestring = savestring .. "|" .. self.clothingTextureCombo[i].selected;
			end
			savestring = savestring .. ";";
		end
	end
	builds[savename] = savestring;
	
	local options = {};
	CharacterCreationMain.writeSaveFile(builds);
	for key,val in pairs(builds) do
		options[key] = 1;
	end
	
	self.savedBuilds.options = {};
	local i = 1;
	for key,val in pairs(options) do
		table.insert(self.savedBuilds.options, key);
		if key == savename then
			self.savedBuilds.selected = i;
		end
		i = i + 1;
	end
end

function CharacterCreationMain.loadOutfit(self, box)
	self:loadOutfit(box);
end

function CharacterCreationMain:loadOutfit(box)
	local name = box.options[box.selected];
	if name == nil then return end;

	local desc = MainScreen.instance.desc;
	
	local saved_builds = CharacterCreationMain.readSavedOutfitFile();
	local build = saved_builds[name];
	if build == nil then return end;
	
	desc:getWornItems():clear();

	local items = luautils.split(build, ";");
	for i,v in pairs(items) do
		local location = luautils.split(v, "=");
		local options = luautils.split(location[2], "|");
		if location[1] == "gender" then
			MainScreen.instance.charCreationHeader.genderCombo.selected = tonumber(options[1]);
			MainScreen.instance.charCreationHeader:onGenderSelected(MainScreen.instance.charCreationHeader.genderCombo);
			desc:getWornItems():clear();
		elseif location[1] == "skincolor" then
			self.colorPickerSkin.index = tonumber(options[1]);
			local color = luautils.split(options[2], ",");
			local colorRGB = {};
			colorRGB.r = tonumber(color[1]);
			colorRGB.g = tonumber(color[2]);
			colorRGB.b = tonumber(color[3]);
			self:onSkinColorPicked(colorRGB, true);
		elseif location[1] == "name" then
			desc:setForename(options[1]);
			MainScreen.instance.charCreationHeader.forenameEntry:setText(options[1]);
			desc:setSurname(options[2]);
			MainScreen.instance.charCreationHeader.surnameEntry:setText(options[2]);
		elseif location[1] == "hair" then
			local color = luautils.split(options[2], ",");
			local colorRGB = {};
			colorRGB.r = tonumber(color[1]);
			colorRGB.g = tonumber(color[2]);
			colorRGB.b = tonumber(color[3]);
			self:onHairColorPicked(colorRGB, true);
			self.hairTypeCombo.selected = tonumber(options[1]);
			self:onHairTypeSelected(self.hairTypeCombo);
		elseif location[1] == "chesthair" then
			self.chestHairCombo.selected = tonumber(options[1]);
			self:onChestHairSelected(self.chestHairCombo);
		elseif location[1] == "beard" then
			self.beardTypeCombo.selected = tonumber(options[1]);
			self:onBeardTypeSelected(self.beardTypeCombo);
		elseif self.clothingCombo[location[1]]  then
--			print("dress on ", location[1], "with", options[1])
			self.clothingCombo[location[1]]:select(options[1]);
			self:onClothingComboSelected(self.clothingCombo[location[1]], location[1]);
			if options[2] then
				local color = luautils.split(options[2], ",");
				-- is it a color or a texture choice
				if color[2] and self.clothingColorBtn[location[1]] then -- it's a color
					local colorRGB = {};
					colorRGB.r = tonumber(color[1]);
					colorRGB.g = tonumber(color[2]);
					colorRGB.b = tonumber(color[3]);
					self:onClothingColorPicked(colorRGB, true, location[1]);
				else -- texture
					self.clothingTextureCombo[location[1]]:select(color[1]);
					self:onClothingTextureComboSelected(self.clothingTextureCombo[location[1]], location[1]);
				end
			end
		end
	end
end

function CharacterCreationMain.readSavedOutfitFile()
	local retVal = {};
	
	local saveFile = getFileReader(CharacterCreationMain.savefile, true);
	local line = saveFile:readLine();
	while line ~= nil do
		local s = luautils.split(line, ":");
		retVal[s[1]] = s[2];
		line = saveFile:readLine();
	end
	saveFile:close();
	
	return retVal;
end

function CharacterCreationMain.writeSaveFile(options)
	local saved_builds = getFileWriter(CharacterCreationMain.savefile, true, false); -- overwrite
	for key,val in pairs(options) do
		saved_builds:write(key..":"..val.."\n");
	end
	saved_builds:close();
end

function CharacterCreationMain:createChestTypeBtn()
	local comboHgt = FONT_HGT_SMALL + 3 * 2
	
	local lbl = ISLabel:new(self.xOffset, self.yOffset, FONT_HGT_MEDIUM, getText("UI_characreation_body"), 1, 1, 1, 1, UIFont.Medium, true);
	lbl:initialise();
	lbl:instantiate();
	self.mainPanel:addChild(lbl);
	
	local rect = ISRect:new(self.xOffset, self.yOffset + FONT_HGT_MEDIUM + 5, 300, 1, 1, 0.3, 0.3, 0.3);
	rect:initialise();
	rect:instantiate();
	self.mainPanel:addChild(rect);
	
	self.yOffset = self.yOffset + FONT_HGT_MEDIUM + 15;
	
	-------------
	-- SKIN COLOR 
	-------------
	self.skinColorLbl = ISLabel:new(self.xOffset+70, self.yOffset, FONT_HGT_SMALL, getText("UI_SkinColor"), 1, 1, 1, 1, UIFont.Small);
	self.skinColorLbl:initialise();
	self.skinColorLbl:instantiate();
	self.mainPanel:addChild(self.skinColorLbl);
	
	local xColor = 90;
	self.skinColors = { {r=1,g=0.91,b=0.72},
		{r=0.98,g=0.79,b=0.49},
		{r=0.8,g=0.65,b=0.45},
		{r=0.54,g=0.38,b=0.25},
		{r=0.36,g=0.25,b=0.14} }
	--	for _,color in ipairs(skinColors) do
	--		color:desaturate(0.5)
	--	end
	local skinColorBtn = ISButton:new(self.xOffset+xColor, self.yOffset, 45, FONT_HGT_SMALL, "", self, CharacterCreationMain.onSkinColorSelected)
	skinColorBtn:initialise()
	skinColorBtn:instantiate()
	local color = self.skinColors[1]
	skinColorBtn.backgroundColor = {r = color.r, g = color.g, b = color.b, a = 1}
	self.mainPanel:addChild(skinColorBtn)
	self.skinColorButton = skinColorBtn
	
	self.colorPickerSkin = ISColorPicker:new(0, 0, nil)
	self.colorPickerSkin:initialise()
	self.colorPickerSkin.keepOnScreen = true
	self.colorPickerSkin.pickedTarget = self
	self.colorPickerSkin.resetFocusTo = self
	self.colorPickerSkin:setColors(self.skinColors, #self.skinColors, 1)
	
	self.yOffset = self.yOffset + FONT_HGT_SMALL + 5 + 4;
	
	-------------
	-- CHEST HAIR
	-------------
	self.chestHairLbl = ISLabel:new(self.xOffset+70, self.yOffset, comboHgt, getText("UI_ChestHair"), 1, 1, 1, 1, UIFont.Small);
	self.chestHairLbl:initialise();
	self.chestHairLbl:instantiate();
	self.mainPanel:addChild(self.chestHairLbl);
	
	self.chestHairCombo = ISComboBox:new(self.xOffset+90, self.yOffset, 100, comboHgt, self, CharacterCreationMain.onChestHairSelected);
	self.chestHairCombo:initialise();
	--	self.chestHairCombo:instantiate();
	self.chestHairCombo:addOption(getText("UI_Yes"))
	self.chestHairCombo:addOption(getText("UI_No"))
	self.mainPanel:addChild(self.chestHairCombo)
	self.yOffset = self.yOffset + comboHgt + 4;
	
	----------------------
	-- HEAD/FACIAL STUBBLE
	----------------------
	self.shavedHairLbl = ISLabel:new(self.xOffset+70, self.yOffset, comboHgt, getText("UI_Stubble"), 1, 1, 1, 1, UIFont.Small);
	self.shavedHairLbl:initialise();
	self.shavedHairLbl:instantiate();
	--	self.mainPanel:addChild(self.shavedHairLbl);
	
	self.shavedHairCombo = ISComboBox:new(self.xOffset+90, self.yOffset, 100, comboHgt, self, CharacterCreationMain.onShavedHairSelected);
	self.shavedHairCombo:initialise();
	--	self.shavedHairCombo:instantiate();
	self.shavedHairCombo:addOption(getText("UI_Yes"))
	self.shavedHairCombo:addOption(getText("UI_No"))
	--	self.mainPanel:addChild(self.shavedHairCombo)
	self.yOffset = self.yOffset + comboHgt + 10;
end


function CharacterCreationMain:createHairTypeBtn()
	local comboHgt = FONT_HGT_SMALL + 3 * 2
	
	local lbl = ISLabel:new(self.xOffset, self.yOffset, FONT_HGT_MEDIUM, getText("UI_characreation_hair"), 1, 1, 1, 1, UIFont.Medium, true);
	lbl:initialise();
	lbl:instantiate();
	self.mainPanel:addChild(lbl);
	
	local rect = ISRect:new(self.xOffset, self.yOffset + FONT_HGT_MEDIUM + 5, 300, 1, 1, 0.3, 0.3, 0.3);
	rect:setAnchorRight(false);
	rect:initialise();
	rect:instantiate();
	self.mainPanel:addChild(rect);
	
	self.yOffset = self.yOffset + FONT_HGT_MEDIUM + 15;
	
	self.hairTypeLbl = ISLabel:new(self.xOffset+70, self.yOffset, comboHgt, getText("UI_characreation_hairtype"), 1, 1, 1, 1, UIFont.Small);
	self.hairTypeLbl:initialise();
	self.hairTypeLbl:instantiate();
	
	self.mainPanel:addChild(self.hairTypeLbl);
	
	self.hairTypeCombo = ISComboBox:new(self.xOffset+90, self.yOffset, self.comboWid, comboHgt, self, CharacterCreationMain.onHairTypeSelected);
	self.hairTypeCombo:initialise();
	--	self.hairTypeCombo:instantiate();
	self.mainPanel:addChild(self.hairTypeCombo)
	
	self.hairType = 0
	
	self.yOffset = self.yOffset + comboHgt + 4;
	
	self.hairColorLbl = ISLabel:new(self.xOffset+70, self.yOffset, FONT_HGT_SMALL, getText("UI_characreation_color"), 1, 1, 1, 1, UIFont.Small);
	self.hairColorLbl:initialise();
	self.hairColorLbl:instantiate();
	
	self.mainPanel:addChild(self.hairColorLbl);
	
	local xColor = 90;
	local fontHgt = getTextManager():getFontHeight(self.hairColorLbl.font)
	
	local hairColors = MainScreen.instance.desc:getCommonHairColor();
	local hairColors1 = {}
	local info = ColorInfo.new()
	for i=1,hairColors:size() do
		local color = hairColors:get(i-1)
		-- we create a new info color to desaturate it (like in the game)
		info:set(color:getRedFloat(), color:getGreenFloat(), color:getBlueFloat(), 1)
		--		info:desaturate(0.5)
		table.insert(hairColors1, { r=info:getR(), g=info:getG(), b=info:getB() })
	end
	local hairColorBtn = ISButton:new(self.xOffset+xColor, self.yOffset, 45, fontHgt, "", self, CharacterCreationMain.onHairColorMouseDown)
	hairColorBtn:initialise()
	hairColorBtn:instantiate()
	local color = hairColors1[1]
	hairColorBtn.backgroundColor = {r=color.r, g=color.g, b=color.b, a=1}
	self.mainPanel:addChild(hairColorBtn)
	self.hairColorButton = hairColorBtn
	
	self.colorPickerHair = ISColorPicker:new(0, 0, nil)
	self.colorPickerHair:initialise()
	self.colorPickerHair.keepOnScreen = true
	self.colorPickerHair.pickedTarget = self
	self.colorPickerHair.resetFocusTo = self
	self.colorPickerHair:setColors(hairColors1, math.min(#hairColors1, 10), math.ceil(#hairColors1 / 10))
	
	self.yOffset = self.yOffset + comboHgt + 10;
end

function CharacterCreationMain:createBeardTypeBtn()
	local comboHgt = FONT_HGT_SMALL + 3 * 2
	
	self.beardLbl = ISLabel:new(self.xOffset, self.yOffset, FONT_HGT_MEDIUM, getText("UI_characreation_beard"), 1, 1, 1, 1, UIFont.Medium, true);
	self.beardLbl:initialise();
	self.beardLbl:instantiate();
	self.mainPanel:addChild(self.beardLbl);
	
	self.beardRect = ISRect:new(self.xOffset, self.yOffset + FONT_HGT_MEDIUM + 5, 300, 1, 1, 0.3, 0.3, 0.3);
	self.beardRect:setAnchorRight(false);
	self.beardRect:initialise();
	self.beardRect:instantiate();
	self.mainPanel:addChild(self.beardRect);
	
	self.yOffset = self.yOffset + FONT_HGT_MEDIUM + 15;
	
	self.beardTypeLbl = ISLabel:new(self.xOffset+ 70, self.yOffset, comboHgt, getText("UI_characreation_beardtype"), 1, 1, 1, 1, UIFont.Small);
	self.beardTypeLbl:initialise();
	self.beardTypeLbl:instantiate();
	
	self.mainPanel:addChild(self.beardTypeLbl);
	
	self.beardTypeCombo = ISComboBox:new(self.xOffset+90, self.yOffset, self.comboWid, comboHgt, self, CharacterCreationMain.onBeardTypeSelected);
	self.beardTypeCombo:initialise();
	--	self.beardTypeCombo:instantiate();
	self.mainPanel:addChild(self.beardTypeCombo)
	
	self.yOffset = self.yOffset + comboHgt + 10;
end

function CharacterCreationMain:createClothingComboDebug(label, bodyLocation)
	local comboHgt = FONT_HGT_SMALL + 3 * 2
	local x = 0
	
	local label = ISLabel:new(x + 70 + 70, self.yOffset, comboHgt, label, 1, 1, 1, 1, UIFont.Small)
	label:initialise()
	self.clothingPanel:addChild(label)
	
	local combo = ISComboBox:new(x + 90 + 70, self.yOffset, self.comboWid, comboHgt, self, self.onClothingComboSelected, bodyLocation)
	combo:initialise()
	self.clothingPanel:addChild(combo)
	
	local fontHgt = getTextManager():getFontHeight(self.skinColorLbl.font)
	local button = ISButton:new(combo:getRight() + 20, self.yOffset, 45, comboHgt, "", self)
	button:setOnClick(CharacterCreationMain.onClothingColorClicked, bodyLocation)
	button.internal = color
	button:initialise()
	button.backgroundColor = {r = 1, g = 1, b = 1, a = 1}
	self.clothingPanel:addChild(button)
	
	local comboDecal = ISComboBox:new(button:getRight() + 20, self.yOffset, self.comboWid, comboHgt, self, self.onClothingDecalComboSelected, bodyLocation)
	comboDecal:initialise()
	self.clothingPanel:addChild(comboDecal)
	
	local comboTexture = ISComboBox:new(combo:getRight() + 20, self.yOffset, 80, comboHgt, self, self.onClothingTextureComboSelected, bodyLocation)
	comboTexture:initialise()
	self.clothingPanel:addChild(comboTexture)
	
	self.clothingCombo = self.clothingCombo or {}
	self.clothingColorBtn = self.clothingColorBtn or {}
	self.clothingTextureCombo = self.clothingTextureCombo or {}
	self.clothingDecalCombo = self.clothingDecalCombo or {}
	
	self.clothingCombo[bodyLocation] = combo
	self.clothingColorBtn[bodyLocation] = button
	self.clothingTextureCombo[bodyLocation] = comboTexture
	self.clothingDecalCombo[bodyLocation] = comboDecal
	
	table.insert(self.clothingWidgets, { combo, button, comboDecal, comboTexture })
	
	self.yOffset = self.yOffset + comboHgt + 4
	
	return
end

-- -- -- -- --
-- -- -- -- --
-- -- -- -- --

local ClothingPanel = ISPanelJoypad:derive("CharacterCreationClothingPanel")

function ClothingPanel:prerender()
	ISPanelJoypad.prerender(self)
	self:setStencilRect(0, 0, self.width, self.height)
end

function ClothingPanel:render()
	ISPanelJoypad.render(self)
	self:clearStencilRect()
	if self.joyfocus then
		self:drawRectBorder(0, -self:getYScroll(), self:getWidth(), self:getHeight(), 0.4, 0.2, 1.0, 1.0);
		self:drawRectBorder(1, 1-self:getYScroll(), self:getWidth()-2, self:getHeight()-2, 0.4, 0.2, 1.0, 1.0);
	end
end

function ClothingPanel:onGainJoypadFocus(joypadData)
	ISPanelJoypad.onGainJoypadFocus(self, joypadData)
	self.joypadButtonsY = {}
	for _,table1 in ipairs(self.parent.parent.clothingWidgets) do
		self:insertNewLineOfButtons(table1[1], table1[2], table1[3], table1[4])
	end
	self.joypadIndex = 1
	if self.prevJoypadIndexY ~= -1 then
		self.joypadIndexY = self.prevJoypadIndexY
	else
		self.joypadIndexY = 1
	end
	self.joypadButtons = self.joypadButtonsY[self.joypadIndexY]
	self.joypadButtons[self.joypadIndex]:setJoypadFocused(true)
end

function ClothingPanel:onLoseJoypadFocus(joypadData)
	self.prevJoypadIndexY = self.joypadIndexY
	ISPanelJoypad.onLoseJoypadFocus(self, joypadData)
end

function ClothingPanel:onJoypadDirLeft(joypadData)
	if self.joypadIndex == 1 then
		joypadData.focus = self.parent.parent
		updateJoypadFocus(joypadData)
	else
		ISPanelJoypad.onJoypadDirLeft(self, joypadData)
	end
end

function ClothingPanel:onJoypadDirRight(joypadData)
	ISPanelJoypad.onJoypadDirRight(self, joypadData)
end

function ClothingPanel:new(x, y, width, height)
	local o = ISPanelJoypad:new(x, y, width, height)
	setmetatable(o, self)
	self.__index = self
	self.prevJoypadIndexY = -1
	return o
end

-- -- -- -- --
-- -- -- -- --
-- -- -- -- --

-- In debug you'll have access to all clothes
-- In normal mode, you'll have access to basic clothes + some specific to your profession (RP option can be enabled in MP to have access to a full outfit)
function CharacterCreationMain:createClothingBtn()
	local comboHgt = FONT_HGT_SMALL + 3 * 2
	
	local x = self.mainPanel:getWidth() / 2
	
	self.clothingPanel = ClothingPanel:new(x, 0, self.mainPanel.width / 2, self.mainPanel.height - 5 - 25 - 10)
	self.clothingPanel:initialise()
	self.clothingPanel.background = false
	self.mainPanel:addChild(self.clothingPanel)
	
	x = 0
	self.clothingLbl = ISLabel:new(x, self.yOffset, FONT_HGT_MEDIUM, getText("UI_characreation_clothing"), 1, 1, 1, 1, UIFont.Medium, true);
	self.clothingLbl:initialise();
	self.clothingPanel:addChild(self.clothingLbl);
	
	local rect = ISRect:new(x, self.yOffset + FONT_HGT_MEDIUM + 5, 400, 1, 1, 0.3, 0.3, 0.3);
	rect:setAnchorRight(true);
	rect:initialise();
	rect:instantiate();
	self.clothingPanel:addChild(rect);
	
	self.yOffset = self.yOffset + FONT_HGT_MEDIUM + 15;
	self.originalYOffset = self.yOffset;
	
	if CharacterCreationMain.debug then
		self:initClothingDebug();
	end
end

function CharacterCreationMain:createClothingCombo(label, bodyLocation)
	local comboHgt = FONT_HGT_SMALL + 3 * 2
	local x = 0
	
	if not self.clothingPanel then return; end
	
	local label = ISLabel:new(x + 70 + 70, self.yOffset, comboHgt, label, 1, 1, 1, 1, UIFont.Small)
	label:initialise()
	self.clothingPanel:addChild(label)
	
	local combo = ISComboBox:new(x + 90 + 70, self.yOffset, self.comboWid, comboHgt, self, self.onClothingComboSelected, bodyLocation)
	combo:initialise()
	combo.bodyLocation = bodyLocation;
	self.clothingPanel:addChild(combo)
	
	local fontHgt = getTextManager():getFontHeight(self.skinColorLbl.font)
	local button = ISButton:new(combo:getRight() + 20, self.yOffset, 45, comboHgt, "", self)
	button:setOnClick(CharacterCreationMain.onClothingColorClicked, bodyLocation)
	button.internal = color
	button:initialise()
	button.backgroundColor = {r = 1, g = 1, b = 1, a = 1}
	self.clothingPanel:addChild(button)
	
	local comboTexture = ISComboBox:new(combo:getRight() + 20, self.yOffset, 80, comboHgt, self, self.onClothingTextureComboSelected, bodyLocation)
	comboTexture:initialise()
	self.clothingPanel:addChild(comboTexture)
	
	self.clothingCombo = self.clothingCombo or {}
	self.clothingColorBtn = self.clothingColorBtn or {}
	self.clothingTextureCombo = self.clothingTextureCombo or {}
	self.clothingComboLabel = self.clothingComboLabel or {}
	
	self.clothingCombo[bodyLocation] = combo
	self.clothingColorBtn[bodyLocation] = button
	self.clothingTextureCombo[bodyLocation] = comboTexture
	self.clothingComboLabel[bodyLocation] = label;
	
	table.insert(self.clothingWidgets, { combo, button, comboTexture })
	
	self.yOffset = self.yOffset + comboHgt + 4
	
	return
end

function CharacterCreationMain:debugClothingDefinitions()
	local bodyLocationGroup = BodyLocations.getGroup("Human")
	for k1,v1 in pairs(ClothingSelectionDefinitions) do
		-- Female, Male
		for k2,v2 in pairs(v1) do
			if k2 ~= "Female" and k2 ~= "Male" then
				error("expected Female or Male in ClothingSelectionDefinitions." .. tostring(k1))
			end
			for locationId,v3 in pairs(v2) do
				if bodyLocationGroup:indexOf(locationId) == -1 then
					error("unknown BodyLocation \"" .. tostring(locationId) .. "\" in ClothingSelectionDefinitions." .. tostring(k1) .. "." .. tostring(k2))
				end
				for _,fullType in ipairs(v3.items) do
					if not ScriptManager.instance:FindItem(fullType) then
						error("unknown item type \"" .. tostring(fullType) .. "\" in ClothingSelectionDefinitions." .. tostring(k1) .. "." .. tostring(k2))
					end
				end
			end
		end
	end
end

function CharacterCreationMain:initClothing()
	if getDebug() then
		self:debugClothingDefinitions()
	end
	
	if CharacterCreationMain.debug then return; end
	
	self.clothingWidgets = {}
	
	local desc = MainScreen.instance.desc;
	local default = ClothingSelectionDefinitions.default;
	if MainScreen.instance.desc:isFemale() then
		self:doClothingCombo(default.Female, true);
	else
		self:doClothingCombo(default.Male, true);
	end
	
	local profession = ClothingSelectionDefinitions[desc:getProfession()];
	if profession then
		if MainScreen.instance.desc:isFemale() then
			self:doClothingCombo(profession.Female, false);
		else
			if profession.Male then -- most of the time there's no diff between male/female outfit, so i didn't created them both
				self:doClothingCombo(profession.Male, false);
			else
				self:doClothingCombo(profession.Female, false);
			end
		end
	end
end

function CharacterCreationMain:doClothingCombo(definition, erasePrevious)
	if not self.clothingPanel then return; end
	
	-- reinit all combos
	if erasePrevious then
		if self.clothingCombo then
			for i,v in pairs(self.clothingCombo) do
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
		
		for j,clothing in ipairs(profTable.items) do
			local item = ScriptManager.instance:FindItem(clothing)
			local displayName = item:getDisplayName()
			-- some clothing are president in default list AND profession list, so we can force a specific clothing in profession we already have
			if not combo:contains(displayName) then
				combo:addOptionWithData(displayName, clothing)
			end
		end
	end
	
	self:updateSelectedClothingCombo();
	
	self.clothingPanel:setScrollChildren(true)
	self.clothingPanel:setScrollHeight(self.yOffset)
	self.clothingPanel:addScrollBars()
	
	self.colorPicker = ISColorPicker:new(0, 0, {h=1,s=0.6,b=0.9});
	self.colorPicker:initialise()
	self.colorPicker.keepOnScreen = true
	self.colorPicker.pickedTarget = self
	self.colorPicker.resetFocusTo = self.clothingPanel
end

function CharacterCreationMain:updateSelectedClothingCombo()
	if CharacterCreationMain.debug then return; end
	local desc = MainScreen.instance.desc;
	if self.clothingCombo then
		for i,combo in pairs(self.clothingCombo) do
			combo.selected = 1;
			self.clothingColorBtn[combo.bodyLocation]:setVisible(false);
			self.clothingTextureCombo[combo.bodyLocation]:setVisible(false);
			-- we select the current clothing we have at this location in the combo
			local currentItem = desc:getWornItem(combo.bodyLocation);
			if currentItem then
				for j,v in ipairs(combo.options) do
					if v.text == currentItem:getDisplayName() then
						combo.selected = j;
						break
					end
				end
				self:updateColorButton(combo.bodyLocation, currentItem);
			end
		end
	end
end

function CharacterCreationMain:updateColorButton(bodyLocation, clothing)
	self.clothingColorBtn[bodyLocation]:setVisible(false);
	self.clothingTextureCombo[bodyLocation]:setVisible(false);
	-- if the item can be colored we add the colorpicker button
	if clothing and clothing:getClothingItem():getAllowRandomTint() then
		self.clothingColorBtn[bodyLocation]:setVisible(true);
		-- update color of button
		local color = clothing:getVisual():getTint(clothing:getClothingItem())
		self.clothingColorBtn[bodyLocation].backgroundColor = {r = color:getRedFloat(), g = color:getGreenFloat(), b = color:getBlueFloat(), a = 1}
	end
	if clothing and clothing:getClothingItem():getTextureChoices():size() > 1 then
		local combo = self.clothingTextureCombo[bodyLocation];
		combo:setVisible(true);
		combo.options = {}
		for i=0,clothing:getClothingItem():getTextureChoices():size() - 1 do
			combo:addOptionWithData("Type " .. (i + 1), clothing:getClothingItem():getTextureChoices():get(i))
			if i == clothing:getVisual():getTextureChoice() then
				combo:select("Type " .. (i + 1));
			end
		end
	end
end

function CharacterCreationMain:initClothingDebug()
	local comboHgt = FONT_HGT_SMALL + 3 * 2
	local x = 0;
	--
	-- Outfit
	--
	self.outfitLbl = ISLabel:new(x + 70 + 70, self.yOffset, comboHgt, "Outfit", 1, 1, 1, 1, UIFont.Small)
	self.outfitLbl:initialise()
	self.clothingPanel:addChild(self.outfitLbl)
	
	self.outfitCombo = ISComboBox:new(x + 90 + 70, self.yOffset, self.comboWid, comboHgt, self, CharacterCreationMain.onOutfitSelected);
	self.outfitCombo:initialise()
	self.clothingPanel:addChild(self.outfitCombo)
	
	local fontHgt = getTextManager():getFontHeight(self.skinColorLbl.font)
	local button = ISButton:new(self.outfitCombo:getRight() + 20, self.yOffset + (fontHgt - 15) / 2, 15, 15, "Randomize", self)
	button:setOnClick(CharacterCreationMain.onRandomizeOutfitClicked)
	button:initialise()
	self.clothingPanel:addChild(button)
	
	self.clothingWidgets = {}
	table.insert(self.clothingWidgets, { self.outfitCombo, button })
	
	self.yOffset = self.yOffset + comboHgt + 4;
	
	--
	-- Clothing
	--
	if CharacterCreationMain.debug then
		self:createClothingComboDebug("Eyes", "Eyes")
		self:createClothingComboDebug("Mask", "Mask")
		self:createClothingComboDebug("MaskEyes", "MaskEyes")
		self:createClothingComboDebug("Hat", "Hat")
		self:createClothingComboDebug("FullHat", "FullHat")
		self:createClothingComboDebug("Neck", "Neck")
		self:createClothingComboDebug("Multi-item (Underwear)", "Torso1Legs1")
		self:createClothingComboDebug("TankTop", "TankTop")
		self:createClothingComboDebug("TShirt", "Tshirt")
		self:createClothingComboDebug("Shirt", "Shirt")
		self:createClothingComboDebug("Sweater", "Sweater")
		self:createClothingComboDebug("Jacket", "Jacket")
		self:createClothingComboDebug("Jacket + Hat", "JacketHat")
		self:createClothingComboDebug("Gloves", "Hands")
		self:createClothingComboDebug("Underwear (bottom)", "Legs1")
		self:createClothingComboDebug("Pants", "Pants")
		self:createClothingComboDebug("Skirt", "Skirt")
		self:createClothingComboDebug("Dress", "Dress")
		self:createClothingComboDebug("Full Suit", "FullSuit")
		self:createClothingComboDebug("Full Suit + Head", "FullSuitHead")
		self:createClothingComboDebug("Full Top", "FullTop")
		self:createClothingComboDebug("Torso Extra", "TorsoExtra")
		self:createClothingComboDebug("Socks", "Socks")
		self:createClothingComboDebug("Shoes", "Shoes")
		self:createClothingComboDebug("Tail", "Tail")
		self:createClothingComboDebug("Back", "Back")
		
		self.clothingPanel:setScrollChildren(true)
		self.clothingPanel:setScrollHeight(self.yOffset)
		self.clothingPanel:addScrollBars()
		
		self.colorPicker = ISColorPicker:new(0, 0)
		self.colorPicker:initialise()
		self.colorPicker.keepOnScreen = true
		self.colorPicker.pickedTarget = self
		self.colorPicker.resetFocusTo = self.clothingPanel
		--	self.clothingPanel:addChild(colorPicker)
	end
end

function CharacterCreationMain:setVisible(bVisible, joypadData)
	if self.javaObject == nil then
		self:instantiate();
	end
	
	ISPanelJoypad.setVisible(self, bVisible, joypadData)
	
	if bVisible and MainScreen.instance.desc then
		MainScreen.instance.charCreationHeader:randomGenericOutfit();
		self:initClothing();
	end
end

function CharacterCreationMain:disableBtn()
	-- CharacterCreationHeader calls this during creation
	if not self.chestHairLbl then return end
	
	local desc = MainScreen.instance.desc
	local visible = not desc:isFemale()
	self.chestHairLbl:setVisible(visible)
	self.chestHairCombo:setVisible(visible)
	self.shavedHairLbl:setVisible(visible)
	self.shavedHairCombo:setVisible(visible)
	self.beardTypeLbl:setVisible(visible)
	self.beardTypeCombo:setVisible(visible)
	self.beardRect:setVisible(visible)
	self.beardLbl:setVisible(visible)
	
	-- Changing male <-> female, update combobox choices.
	if self.female ~= desc:isFemale() then
		self.female = desc:isFemale()
		
		self.hairTypeCombo.options = {}
		local hairStyles = getAllHairStyles(desc:isFemale())
		for i=1,hairStyles:size() do
			local label = hairStyles:get(i-1)
			if label == "" then
				label = getText("IGUI_Hair_Bald")
			else
				label = getText("IGUI_Hair_" .. label);
			end
			self.hairTypeCombo:addOptionWithData(label, hairStyles:get(i-1))
		end
		
		self.beardTypeCombo.options = {}
		if desc:isFemale() then
			-- no bearded ladies
		else
			local beardStyles = getAllBeardStyles()
			for i=1,beardStyles:size() do
				local label = beardStyles:get(i-1)
				if label == "" then
					label = getText("IGUI_Beard_None")
				else
					label = getText("IGUI_Beard_" .. label);
				end
				self.beardTypeCombo:addOptionWithData(label, beardStyles:get(i-1))
			end
		end
		
		if self.outfitCombo then
			self.outfitCombo.options = {}
			self.outfitCombo:addOptionWithData(getText("UI_characreation_clothing_none"), nil)
			local outfits = getAllOutfits(desc:isFemale())
			for i=1,outfits:size() do
				self.outfitCombo:addOptionWithData(outfits:get(i-1), outfits:get(i-1))
			end
		end
		
		local fillCombo = function(bodyLocation)
			local combo = self.clothingCombo[bodyLocation]
			combo.options = {}
			combo:addOptionWithData(getText("UI_characreation_clothing_none"), nil)
			local items = getAllItemsForBodyLocation(bodyLocation)
			table.sort(items, function(a,b)
				local itemA = ScriptManager.instance:FindItem(a)
				local itemB = ScriptManager.instance:FindItem(b)
				return not string.sort(itemA:getDisplayName(), itemB:getDisplayName())
			end)
			for _,fullType in ipairs(items) do
				local item = ScriptManager.instance:FindItem(fullType)
				local displayName = item:getDisplayName()
				combo:addOptionWithData(displayName, fullType)
			end
		end
		
		if CharacterCreationMain.debug then
			for bodyLocation,combo in pairs(self.clothingCombo) do
				fillCombo(bodyLocation)
			end
		end
	end
	
	self:syncUIWithTorso()
	self.hairTypeCombo.selected = self.hairType + 1
	
	if self.skinColors and self.skinColor then
		local color = self.skinColors[self.skinColor]
		self.skinColorButton.backgroundColor.r = color.r
		self.skinColorButton.backgroundColor.g = color.g
		self.skinColorButton.backgroundColor.b = color.b
	end
	
	local color = desc:getHumanVisual():getHairColor()
	self.hairColorButton.backgroundColor.r = color:getRedFloat()
	self.hairColorButton.backgroundColor.g = color:getGreenFloat()
	self.hairColorButton.backgroundColor.b = color:getBlueFloat()
	
	if MainScreen.instance.avatar then
		self.hairTypeCombo.selected = 1
		local hairModel = desc:getHumanVisual():getHairModel()
		for i=1,#self.hairTypeCombo.options do
			local name = self.hairTypeCombo:getOptionData(i):lower()
			if name:lower() == hairModel:lower() then
				self.hairTypeCombo.selected = i
				break
			end
		end
		
		self.beardTypeCombo.selected = 1
		local beardModel = desc:getHumanVisual():getBeardModel()
		for i=1,#self.beardTypeCombo.options do
			local name = self.beardTypeCombo:getOptionData(i):lower()
			if name:lower() == beardModel:lower() then
				self.beardTypeCombo.selected = i
				break
			end
		end
		
		if CharacterCreationMain.debug then
			for bodyLocation,combo in pairs(self.clothingCombo) do
				local selected = combo.selected
				combo.selected = 1 -- None
				local item = desc:getWornItem(bodyLocation)
				local clothingItem = nil
				if item and item:getVisual() then
					combo.selected = combo:find(function(text, data, fullType)
						return data == fullType
					end, item:getFullType())
					clothingItem = item:getVisual():getClothingItem()
				end
				if clothingItem and not clothingItem:getTextureChoices():isEmpty() and clothingItem:getTextureChoices():size() > 1 then
					local combo = self.clothingTextureCombo[bodyLocation];
					combo:setVisible(true);
					combo.options = {}
					for i=0,clothingItem:getTextureChoices():size() - 1 do
						combo:addOptionWithData("Type " .. (i + 1), clothingItem:getTextureChoices():get(i))
						if i == item:getVisual():getTextureChoice() then
							combo:select("Type " .. (i + 1));
						end
					end
				else
					self.clothingTextureCombo[bodyLocation].options = {};
					self.clothingTextureCombo[bodyLocation]:setVisible(false);
				end
				if clothingItem and clothingItem:getAllowRandomTint() then
					local color = item:getVisual():getTint(clothingItem)
					self.clothingColorBtn[bodyLocation].backgroundColor = { r=color:getRedFloat(), g=color:getGreenFloat(), b=color:getBlueFloat(), a = 1 }
					self.clothingColorBtn[bodyLocation]:setVisible(true)
				else
					self.clothingColorBtn[bodyLocation].backgroundColor = { r=1, g=1, b=1, a = 1 }
					self.clothingColorBtn[bodyLocation]:setVisible(false)
				end
				if clothingItem and clothingItem:getDecalGroup() then
					-- Fill the decal combo if a different clothing item is now selected.
					if self.decalItem ~= item then
						self.decalItem = item
						local decalCombo = self.clothingDecalCombo[bodyLocation]
						decalCombo.options = {}
						local items = getAllDecalNamesForItem(item)
						for i=1,items:size() do
							decalCombo:addOptionWithData(items:get(i-1), items:get(i-1))
						end
					end
					local decalName = item:getVisual():getDecal(clothingItem)
					self.clothingDecalCombo[bodyLocation]:select(decalName)
					self.clothingDecalCombo[bodyLocation]:setVisible(true)
				else
					self.clothingDecalCombo[bodyLocation]:setVisible(false)
				end
			end
		end
	end
end

function CharacterCreationMain:onHairColorMouseDown(button, x, y)
	self.colorPickerHair:setX(button:getAbsoluteX())
	self.colorPickerHair:setY(button:getAbsoluteY() + button:getHeight())
	self.colorPickerHair:setPickedFunc(CharacterCreationMain.onHairColorPicked)
	local color = button.backgroundColor
	self.colorPickerHair:setInitialColor(ColorInfo.new(color.r, color.g, color.b, 1))
	self:removeChild(self.colorPickerHair)
	self:addChild(self.colorPickerHair)
	if self.joyfocus then
		self.joyfocus.focus = self.colorPickerHair
	end
	--[[
		local desc = MainScreen.instance.desc
		self.hairColor = button.internal;
		desc:getHumanVisual():setHairColor(button.internal)
		desc:getHumanVisual():setBeardColor(button.internal)
		CharacterCreationHeader.instance.avatarPanel:setSurvivorDesc(desc)
		self:disableBtn();
	]]--
end

function CharacterCreationMain:onHairColorPicked(color, mouseUp)
	self.hairColorButton.backgroundColor = { r=color.r, g=color.g, b=color.b, a = 1 }
	local desc = MainScreen.instance.desc
	local immutableColor = ImmutableColor.new(color.r, color.g, color.b, 1)
	desc:getHumanVisual():setHairColor(immutableColor)
	desc:getHumanVisual():setBeardColor(immutableColor)
	CharacterCreationHeader.instance.avatarPanel:setSurvivorDesc(desc)
	self:disableBtn()
end

function CharacterCreationMain:syncTorsoWithUI()
	--[[
		local torsoNum = self.skinColor - 1
		if not MainScreen.instance.desc:isFemale() then
			-- white white+chest white+stubble white+chest+stubble
			-- black black+chest black+stubble black+chest+stubble
			torsoNum = torsoNum * 4
			if self.shavedHairCombo.selected == 1 then
				torsoNum = torsoNum + 2
			end
			if self.chestHairCombo.selected == 1 then
				torsoNum = torsoNum + 1
			end
		end
		MainScreen.instance.desc:setTorsoNumber(torsoNum)
		SurvivorFactory.setTorso(MainScreen.instance.desc)
		MainScreen.instance.avatar:reloadSpritePart()
	]]--
	self:disableBtn()
end

function CharacterCreationMain:syncUIWithTorso()
	local desc = MainScreen.instance.desc
	if not desc then return end
	self.skinColor = desc:getHumanVisual():getSkinTextureIndex() + 1
	if MainScreen.instance.desc:isFemale() then
		self.chestHairCombo.selected = 2
	else
		self.chestHairCombo.selected = (desc:getHumanVisual():getBodyHairIndex() == 0) and 1 or 2
		if torsoNum == 2 or torsoNum == 3 or torsoNum == 6 or torsoNum == 7 then
			self.shavedHairCombo.selected = 1 -- Yes
		else
			self.shavedHairCombo.selected = 2 -- No
		end
	end
end

function CharacterCreationMain:onChestHairSelected(combo)
	local desc = MainScreen.instance.desc
	desc:getHumanVisual():setBodyHairIndex((combo.selected == 1) and 0 or -1)
	CharacterCreationHeader.instance.avatarPanel:setSurvivorDesc(desc)
end

function CharacterCreationMain:onShavedHairSelected(combo)
	self:syncTorsoWithUI()
end

function CharacterCreationMain:onSkinColorSelected(button, x, y)
	self.colorPickerSkin:setX(button:getAbsoluteX())
	self.colorPickerSkin:setY(button:getAbsoluteY() + button:getHeight())
	self.colorPickerSkin:setPickedFunc(CharacterCreationMain.onSkinColorPicked)
	local color = button.backgroundColor
	self.colorPickerSkin:setInitialColor(ColorInfo.new(color.r, color.g, color.b, 1))
	self:removeChild(self.colorPickerSkin)
	self:addChild(self.colorPickerSkin)
	if self.joyfocus then
		self.joyfocus.focus = self.colorPickerSkin
	end
end

function CharacterCreationMain:onSkinColorPicked(color, mouseUp)
	self.skinColorButton.backgroundColor = { r=color.r, g=color.g, b=color.b, a = 1 }
	local desc = MainScreen.instance.desc
	desc:getHumanVisual():setSkinTextureIndex(self.colorPickerSkin.index - 1)
	CharacterCreationHeader.instance.avatarPanel:setSurvivorDesc(desc)
	self:disableBtn()
end

function CharacterCreationMain:onHairTypeSelected(combo)
	local desc = MainScreen.instance.desc
	self.hairType = combo.selected - 1
	local hair = combo:getOptionData(combo.selected)
	desc:getHumanVisual():setHairModel(hair) -- may be nil
	CharacterCreationHeader.instance.avatarPanel:setSurvivorDesc(desc)
	self:disableBtn()
end

function CharacterCreationMain:onBeardTypeSelected(combo)
	local desc = MainScreen.instance.desc
	local beard = combo:getOptionData(combo.selected)
	desc:getHumanVisual():setBeardModel(beard) -- may be nil
	CharacterCreationHeader.instance.avatarPanel:setSurvivorDesc(desc)
	self:disableBtn()
end

function CharacterCreationMain:onOutfitSelected(combo)
	local desc = MainScreen.instance.desc
	local outfitName = combo:getOptionData(combo.selected)
	desc:dressInNamedOutfit(outfitName)
	CharacterCreationHeader.instance.avatarPanel:setSurvivorDesc(desc)
	self:disableBtn()
end

function CharacterCreationMain:onRandomizeOutfitClicked()
	self:onOutfitSelected(self.outfitCombo)
end

function CharacterCreationMain:onClothingComboSelected(combo, bodyLocation)
	local desc = MainScreen.instance.desc
	desc:setWornItem(bodyLocation, nil)
	local itemType = combo:getOptionData(combo.selected)
	if itemType then
		local item = InventoryItemFactory.CreateItem(itemType)
		if item then
			desc:setWornItem(bodyLocation, item)
		end
	end
	self:updateSelectedClothingCombo();
	
	CharacterCreationHeader.instance.avatarPanel:setSurvivorDesc(desc)
	self:disableBtn()
end

function CharacterCreationMain:onClothingColorClicked(button, bodyLocation)
	self.colorPicker:setX(self.clothingPanel:getAbsoluteX() + self.clothingPanel:getXScroll() + button:getX() - self.colorPicker:getWidth())
	self.colorPicker:setY(self.clothingPanel:getAbsoluteY() + self.clothingPanel:getYScroll() + button:getY() + button:getHeight())
	self.colorPicker:setPickedFunc(CharacterCreationMain.onClothingColorPicked, bodyLocation)
	local color = button.backgroundColor
	self.colorPicker:setInitialColor(ColorInfo.new(color.r, color.g, color.b, 1))
	self:removeChild(self.colorPicker)
	self:addChild(self.colorPicker)
	if self.joyfocus then
		button:setJoypadFocused(false)
		self.joyfocus.focus = self.colorPicker
	end
end

function CharacterCreationMain:onClothingColorPicked(color, mouseUp, bodyLocation)
	print("PICKEDCLR", color.r, color.g, color.b)
	self.clothingColorBtn[bodyLocation].backgroundColor = { r=color.r, g=color.g, b=color.b, a = 1 }
	local desc = MainScreen.instance.desc
	local item = desc:getWornItem(bodyLocation)
	if item then
		local color2 = ImmutableColor.new(color.r, color.g, color.b, 1)
		item:getVisual():setTint(color2)
		CharacterCreationHeader.instance.avatarPanel:setSurvivorDesc(desc)
	end
end

function CharacterCreationMain:onClothingTextureComboSelected(combo, bodyLocation)
	local desc = MainScreen.instance.desc
	local textureName = combo:getOptionData(combo.selected)
	local item = desc:getWornItem(bodyLocation)
	if textureName and item then
		item:getVisual():setTextureChoice(combo.selected - 1)
	end
	CharacterCreationHeader.instance.avatarPanel:setSurvivorDesc(desc)
	self:disableBtn()
end

function CharacterCreationMain:onClothingDecalComboSelected(combo, bodyLocation)
	local desc = MainScreen.instance.desc
	local decalName = combo:getOptionData(combo.selected)
	local item = desc:getWornItem(bodyLocation)
	if decalName and item then
		item:getVisual():setDecal(decalName)
	end
	CharacterCreationHeader.instance.avatarPanel:setSurvivorDesc(desc)
	self:disableBtn()
end

function CharacterCreationMain:onOptionMouseDown(button, x, y)
	if button.internal == "BACK" then
		self:setVisible(false)
		MainScreen.instance.charCreationProfession:setVisible(true, self.joyfocus);
	end
	if button.internal == "RANDOM" then
		CharacterCreationHeader.instance:onOptionMouseDown(button, x, y)
	end
	if button.internal == "NEXT" then
		--		MainScreen.instance.charCreationMain:setVisible(false);
		--		MainScreen.instance.charCreationMain:removeChild(MainScreen.instance.charCreationHeader);
		--		MainScreen.instance.charCreationProfession:addChild(MainScreen.instance.charCreationHeader);
		--		MainScreen.instance.charCreationProfession:setVisible(true, self.joyfocus);
		
		MainScreen.instance.charCreationMain:setVisible(false);
		-- set the player desc we build
		self:initPlayer();
		-- set up the world
		if not getWorld():getMap() then
			getWorld():setMap("Muldraugh, KY");
		end
		if MainScreen.instance.createWorld then
			createWorld(getWorld():getWorld())
		end
		GameWindow.doRenderEvent(false);
		-- menu activated via joypad, we disable the joypads and will re-set them automatically when the game is started
		if self.joyfocus then
			local joypadData = self.joyfocus
			joypadData.focus = nil;
			updateJoypadFocus(joypadData)
			JoypadState.count = 0
			JoypadState.players = {};
			JoypadState.joypads = {};
			JoypadState.forceActivate = joypadData.id;
		end
		forceChangeState(GameLoadingState.new());
	end
	self:disableBtn();
end

function CharacterCreationMain:initPlayer()
	MainScreen.instance.desc:setForename(MainScreen.instance.charCreationHeader.forenameEntry:getText());
	MainScreen.instance.desc:setSurname(MainScreen.instance.charCreationHeader.surnameEntry:getText());
	--	if MainScreen.instance.charCreationProfession.listboxProf.selected > -1 then
	--		MainScreen.instance.desc:setProfession(MainScreen.instance.charCreationProfession.listboxProf.items[MainScreen.instance.charCreationProfession.listboxProf.selected].item:getType());
	--	else
	--		MainScreen.instance.desc:setProfession(MainScreen.instance.charCreationProfession.listboxProf.items[0].item:getType());
	--	end
end

--[[
-- draw the avatar of the player
function CharacterCreationMain:drawAvatar()
	if MainScreen.instance.avatar == nil then
		return;
	end
	local x = self:getAbsoluteX();
	local y = self:getAbsoluteY();
	x = x + 96/2;
	y = y + 165;

	MainScreen.instance.avatar:drawAt(x,y);
end
]]--

function CharacterCreationMain:prerender()
	CharacterCreationMain.instance = self
	ISPanel.prerender(self);
	self:drawTextCentre(getText("UI_characreation_title"), self.width / 2, 10, 1, 1, 1, 1, UIFont.Large);
	--[[
		local avatar = MainScreen.instance.avatar
		if avatar ~= nil then
			avatar:getSprite():update(avatar:getSpriteDef())
		end
	]]--
	self.deleteBuildButton:setEnable(self.savedBuilds.options[self.savedBuilds.selected] ~= nil)
end

function CharacterCreationMain:onGainJoypadFocus(joypadData)
	local oldFocus = self:getJoypadFocus()
	ISPanelJoypad.onGainJoypadFocus(self, joypadData);
	self.playButton:setJoypadButton(getTexture("media/ui/abutton.png"))
	self:setISButtonForB(self.backButton);
	self:setISButtonForY(self.randomButton);
	-- init all the button for the controller
	self:loadJoypadButtons();
	if not oldFocus or not oldFocus:isVisible() then
		self:clearJoypadFocus(JoypadState[1])
		self.joypadIndexY = #self.joypadButtonsY;
		self.joypadButtons = self.joypadButtonsY[self.joypadIndexY];
		self.joypadIndex = #self.joypadButtons;
		self.playButton:setJoypadFocused(true);
	end
end

function CharacterCreationMain:onLoseJoypadFocus(joypadData)
	self.playButton.isJoypad = false
	self.ISButtonB = nil
	self.backButton.isJoypad = false
	self.ISButtonY = nil
	self.randomButton.isJoypad = false
	ISPanelJoypad.onLoseJoypadFocus(joypadData)
end

function CharacterCreationMain:setJoypadFocusedAButton(focused)
	ISButton.setJoypadFocused(self, focused)
	self.ISButtonA = focused and self or nil
	self.isJoypad = focused
end

function CharacterCreationMain:setJoypadFocusedBButton(focused)
	ISButton.setJoypadFocused(self, focused)
	self.ISButtonB = focused and self or nil
	self.isJoypad = focused
end

function CharacterCreationMain:setJoypadFocusedYButton(focused)
	ISButton.setJoypadFocused(self, focused)
	CharacterCreationMain.instance.ISButtonY = focused and self or nil
	self.isJoypad = focused
end

function CharacterCreationMain:onJoypadDirLeft(joypadData)
	ISPanelJoypad.onJoypadDirLeft(self, joypadData)
end

function CharacterCreationMain:onJoypadDirRight(joypadData)
	if self.joypadIndexY < #self.joypadButtonsY then
		joypadData.focus = self.clothingPanel
		updateJoypadFocus(joypadData)
	else
		ISPanelJoypad.onJoypadDirRight(self, joypadData)
	end
end

function CharacterCreationMain:loadJoypadButtons()
	local oldFocus = self:getJoypadFocus()
	self:clearJoypadFocus(JoypadState[1])
	self.joypadButtonsY = {};
	local sexButton = self:insertNewLineOfButtons(MainScreen.instance.charCreationHeader.genderCombo);
	--    self:insertNewLineOfButtons(MainScreen.instance.charCreationHeader.randomButton);
	local buttons = {}
	table.insert(buttons, self.skinColorButton)
	table.insert(buttons, self.clothingOutfitCombo)
	self:insertNewListOfButtons(buttons)
	if not MainScreen.instance.desc:isFemale() then
		self:insertNewLineOfButtons(self.chestHairCombo)
	end
	self:insertNewLineOfButtons(self.hairTypeCombo);
	self:insertNewLineOfButtons(self.hairColorButton);
	if not MainScreen.instance.desc:isFemale() then
		self:insertNewLineOfButtons(self.beardTypeCombo);
	end
	self:insertNewLineOfButtons(self.savedBuilds, self.saveBuildButton, self.deleteBuildButton, self.playButton)
	self.joypadIndex = 1
	self.joypadIndexY = 1
	self.joypadButtons = self.joypadButtonsY[self.joypadIndexY];
--    self.joypadButtons[self.joypadIndex]:setJoypadFocused(true, JoypadState[1])

	if oldFocus and oldFocus:isVisible() then
		self:setJoypadFocus(oldFocus)
	end
end

function CharacterCreationMain:onResolutionChange(oldw, oldh, neww, newh)
	local w = neww * 0.75;
	if (w < 768) then
		w = 768;
	end
	local tw = neww;
	local mainPanelY = 48
	local mainPanelPadBottom = 80
	if getCore():getScreenHeight() <= 600 then
		mainPanelPadBottom = 16
	end
	self.mainPanel:setWidth(w)
	self.mainPanel:setHeight(self.height - mainPanelPadBottom - mainPanelY)
	self.mainPanel:setX((tw - w) / 2)
	self.mainPanel:setY(48)
	self.mainPanel:recalcSize()
	
	self.clothingPanel:setX(self.mainPanel:getWidth() / 2)
	self.clothingPanel:setWidth(self.mainPanel:getWidth() / 2)
	self.clothingPanel:setHeight(self.mainPanel:getHeight() - 5 - 25 - 10)
	
	MainScreen.instance.charCreationHeader:setX(self.mainPanel:getX());
	MainScreen.instance.charCreationHeader:setY(self.mainPanel:getY());
	--	MainScreen.instance.charCreationHeader:setWidth(self.mainPanel:getWidth());
	
	local panel = CharacterCreationHeader.instance.avatarPanel
	panel:setX(self.mainPanel:getAbsoluteX() + self.avatarPanelX - self:getAbsoluteX())
end

function CharacterCreationMain:new (x, y, width, height)
	local o = {};
	o = ISPanelJoypad:new(x, y, width, height);
	setmetatable(o, self);
	self.__index = self;
	o.x = 0;
	o.y = 0;
	o.backgroundColor = {r=0, g=0, b=0, a=0.0};
	o.borderColor = {r=1, g=1, b=1, a=0.0};
	o.itemheightoverride = {};
	o.anchorLeft = true;
	o.anchorRight = false;
	o.anchorTop = true;
	o.anchorBottom = false;
	o.colorPanel = {};
	o.rArrow = getTexture("media/ui/ArrowRight.png");
	o.disabledRArrow = getTexture("media/ui/ArrowRight_Disabled.png");
	o.lArrow = getTexture("media/ui/ArrowLeft.png");
	o.disabledLArrow = getTexture("media/ui/ArrowLeft_Disabled.png");
	CharacterCreationMain.instance = o;
	return o;
end
