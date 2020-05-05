--***********************************************************
--**                   ROBERT JOHNSON                      **
--***********************************************************

require "ISUI/ISPanel"
require "ISUI/ISButton"
require "ISUI/ISInventoryPane"
require "ISUI/ISResizeWidget"
require "ISUI/ISMouseDrag"

require "defines"

CharacterCreationMain = CharacterCreationMain

function CharacterCreationMain:setVisible(bVisible, joypadData)
	if self.javaObject == nil then
		self:instantiate();
	end

	ISPanelJoypad.setVisible(self, bVisible, joypadData)

	if bVisible and MainScreen.instance.desc then
		MainScreen.instance.charCreationHeader:startingOutfit();
		self:initClothing();
	end
end
