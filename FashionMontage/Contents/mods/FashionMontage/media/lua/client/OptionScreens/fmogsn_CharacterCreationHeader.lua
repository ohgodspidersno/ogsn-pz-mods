--***********************************************************
--**                   ROBERT JOHNSON                      **
--***********************************************************

require "ISUI/ISPanel"
require "ISUI/ISButton"
require "ISUI/ISInventoryPane"
require "ISUI/ISResizeWidget"
require "ISUI/ISMouseDrag"

require "defines"

CharacterCreationHeader = CharacterCreationHeader

function AvatarPanel:createChildren()
	self.avatarBackgroundTexture = getTexture("media/ui/avatarBackground.png")

	local comboHgt = FONT_HGT_SMALL + 3 * 2

	self.avatarPanel = ISUI3DModel:new(0, 0, self.width, self.height - comboHgt)
	self.avatarPanel.backgroundColor = {r=0, g=0, b=0, a=0.8}
	self.avatarPanel.borderColor = {r=1, g=1, b=1, a=0.2}
	self:addChild(self.avatarPanel)
	CharacterCreationHeader.instance:startingOutfit()
	self.avatarPanel:setState("idle")
	self.avatarPanel:setDirection(IsoDirections.S)
	self.avatarPanel:setIsometric(false)
	self.avatarPanel:setDoRandomExtAnimations(true)

	self.turnLeftButton = ISButton:new(self.avatarPanel.x, self.avatarPanel:getBottom()-15, 15, 15, "", self, self.onTurnChar)
	self.turnLeftButton.internal = "TURNCHARACTERLEFT"
	self.turnLeftButton:initialise()
	self.turnLeftButton:instantiate()
	self.turnLeftButton:setImage(getTexture("media/ui/ArrowLeft.png"))
	self:addChild(self.turnLeftButton)

	self.turnRightButton = ISButton:new(self.avatarPanel:getRight()-15, self.avatarPanel:getBottom()-15, 15, 15, "", self, self.onTurnChar)
	self.turnRightButton.internal = "TURNCHARACTERRIGHT"
	self.turnRightButton:initialise()
	self.turnRightButton:instantiate()
	self.turnRightButton:setImage(getTexture("media/ui/ArrowRight.png"))
	self:addChild(self.turnRightButton)

	self.animCombo = ISComboBox:new(0, self.avatarPanel:getBottom() + 2, self.width, comboHgt, self, self.onAnimSelected)
	self.animCombo:initialise()
	self:addChild(self.animCombo)
	self.animCombo:addOptionWithData(getText("IGUI_anim_Idle"), "EventIdle")
	self.animCombo:addOptionWithData(getText("IGUI_anim_Walk"), "EventWalk")
	self.animCombo:addOptionWithData(getText("IGUI_anim_Run"), "EventRun")
	self.animCombo.selected = 1
end

function CharacterCreationHeader:onGenderSelected(combo)
	if combo.selected == 1 then
		MainScreen.instance.avatar:setFemale(true);
		MainScreen.instance.desc:setFemale(true);
	else
		MainScreen.instance.avatar:setFemale(false);
		MainScreen.instance.desc:setFemale(false);
	end
	-- self:randomGenericOutfit()
	self:setAvatarFromUI()

	-- we random the name
	SurvivorFactory.randomName(MainScreen.instance.desc);

	self.forenameEntry:setText(MainScreen.instance.desc:getForename());
	self.surnameEntry:setText(MainScreen.instance.desc:getSurname());

	CharacterCreationMain.instance:loadJoypadButtons();
end

function CharacterCreationHeader:startingOutfit()
  local desc = MainScreen.instance.desc;
	local starting = ClothingSelectionDefinitions.starting;
	if MainScreen.instance.desc:isFemale() then
		self:dressWithDefinitions(starting.Female, true);
	else
		self:dressWithDefinitions(starting.Male, true);
	end

	self.avatarPanel:setSurvivorDesc(desc)
	CharacterCreationHeader.instance.avatarPanel:setSurvivorDesc(desc)
	CharacterCreationMain.instance:disableBtn()
	CharacterCreationMain.instance:initClothing()
end

function CharacterCreationHeader:randomGenericOutfit()
	local desc = MainScreen.instance.desc;
	local default = ClothingSelectionDefinitions.default;
	if MainScreen.instance.desc:isFemale() then
		self:dressWithDefinitions(default.Female, true);
	else
		self:dressWithDefinitions(default.Male, true);
	end

	local profession = ClothingSelectionDefinitions[desc:getProfession()];

	self.avatarPanel:setSurvivorDesc(desc)
	CharacterCreationHeader.instance.avatarPanel:setSurvivorDesc(desc)
	CharacterCreationMain.instance:disableBtn()
	CharacterCreationMain.instance:initClothing()
end
