--***********************************************************
--**                    THE INDIE STONE                    **
--***********************************************************

require "ISUI/ISPanel"

TRFB_ToolTip = ISPanel:derive("TRFB_ToolTip");


--************************************************************************--
--** ISPanel:initialise
--**
--************************************************************************--

function TRFB_ToolTip:initialise()
	ISPanel.initialise(self);
end


function TRFB_ToolTip:setBarrel(bar)
	self.barrel = bar
end

function TRFB_ToolTip:isBarrel()
	return self.barrel 
end


function TRFB_ToolTip:setName(name)
	self.name = name;
end

function TRFB_ToolTip:setContextMenu(contextMenu)
	self.contextMenu = contextMenu;
end

function TRFB_ToolTip:setTexture(textureName)
	self.texture = getTexture(textureName);
end

function TRFB_ToolTip:onMouseDown(x, y)
	return false
end

function TRFB_ToolTip:onMouseUp(x, y)
	return false
end

function TRFB_ToolTip:onRightMouseDown(x, y)
	return false
end

function TRFB_ToolTip:onRightMouseUp(x, y)
	return false
end

function TRFB_ToolTip:prerender()
	if self.owner and not self.owner:isReallyVisible() then
		self:removeFromUIManager()
		self:setVisible(false)
		return
	end
	self:doLayout()
	self:drawRect(0, 0, self.width, self.height, self.backgroundColor.a, self.backgroundColor.r, self.backgroundColor.g, self.backgroundColor.b);
end


--************************************************************************--
--** ISPanel:render
--**
--************************************************************************--

function TRFB_ToolTip:render()

	local mx = getMouseX() + 32
	local my = getMouseY() + 10
	if not self.followMouse then
		mx = self:getX()
		my = self:getY()
	end
	if self.desiredX and self.desiredY then
		mx = self.desiredX
		my = self.desiredY
	end
	self:setX(mx)
	self:setY(my)

	if self.contextMenu and self.contextMenu.joyfocus then
		local playerNum = self.contextMenu.player
		self:setX(getPlayerScreenLeft(playerNum) + 60);
		self:setY(getPlayerScreenTop(playerNum) + 60);
	elseif self.contextMenu and self.contextMenu.currentOptionRect then
		if self.contextMenu.currentOptionRect.height > 32 then
			self:setY(my + self.contextMenu.currentOptionRect.height)
		end
		self:adjustPositionToAvoidOverlap(self.contextMenu.currentOptionRect)
	elseif self.owner and self.owner.isButton then
		local ownerRect = { x = self.owner:getAbsoluteX(), y = self.owner:getAbsoluteY(), width = self.owner.width, height = self.owner.height }
		self:adjustPositionToAvoidOverlap(ownerRect)
	end

	-- big rectangle (our background)
	self:drawRect(0, 0, self.width, self.height, 0.7, 0.05, 0.05, 0.05)
	self:drawRectBorder(0, 0, self.width, self.height, 0.5, 0.9, 0.9, 1)

	-- render texture
	if self.texture then
		local widthTexture = self.texture:getWidth()
		local heightTexture = self.texture:getHeight()
		self:drawTextureScaled(self.texture, 8, 35, widthTexture, heightTexture, 1, 1, 1, 1)
	end

	-- render name
	if self.name then
		self:drawText(self.name, 8, 5, 1, 1, 1, 1, UIFont.Medium)
	end

	-- render description
	if self.description ~= "" then
		if self.texture then
			self.descriptionPanel:setX(self:getAbsoluteX() + 10 + self.texture:getWidth());
		else
			self.descriptionPanel:setX(self:getAbsoluteX() + 10);
		end
		local y = 0
		if self.name then
			y = 25
		end
		self.descriptionPanel:setY(self:getAbsoluteY() + y)
		self.descriptionPanel:prerender()
		self.descriptionPanel:render()
	end
	
	-- render a how to rotate message at the bottom if needed
	if self.footNote then
		local fontHgt = getTextManager():getFontFromEnum(UIFont.Small):getLineHeight()
		self:drawTextCentre(self.footNote, self:getWidth() / 2, self:getHeight() - fontHgt - 4, 1, 1, 1, 1, UIFont.Small)
	end
	
	--Highlight barrel
	if self.barrel then
		self.barrel:setHighlighted(true, false);
		self.barrel:setHighlightColor(getCore():getObjectHighlitedColor());
	end
end

function TRFB_ToolTip:doLayout()
	local textX = 10
	local textY = 0
	local textWidth = 0
	local textHeight = 0
	if self.description ~= "" then
		self.descriptionPanel.defaultFont = UIFont.NewSmall
		if getCore():getOptionTooltipFont() == "Large" then
			self.descriptionPanel.defaultFont = UIFont.Large
		elseif getCore():getOptionTooltipFont() == "Medium" then
			self.descriptionPanel.defaultFont = UIFont.Medium
		end
		self.descriptionPanel.text = self.description
		local widthScale = getTextManager():getFontHeight(self.descriptionPanel.defaultFont) / 15
		if self.maxLineWidth then
			self.descriptionPanel.maxLineWidth = self.maxLineWidth * widthScale
			self.descriptionPanel:setWidth(self.descriptionPanel.marginLeft + self.descriptionPanel.marginRight)
		else
			self.descriptionPanel:setWidth(180 * widthScale)
		end
		self.descriptionPanel:paginate()

		local maxLineWidth = 0
		for _,v in ipairs(self.descriptionPanel.lines) do
			local lineWidth = getTextManager():MeasureStringX(self.descriptionPanel.defaultFont, v);
			if lineWidth > maxLineWidth then
				maxLineWidth = lineWidth
			end
		end
		local panelWidth = maxLineWidth + self.descriptionPanel.marginLeft + self.descriptionPanel.marginRight
		if panelWidth > self.descriptionPanel:getWidth() then
			self.descriptionPanel:setWidth(panelWidth)
			self.descriptionPanel:paginate()
--		elseif panelWidth < self.descriptionPanel:getWidth() then
--			self.descriptionPanel:setWidth(panelWidth)
--			self.descriptionPanel:paginate()
		end
		
		textWidth = self.descriptionPanel:getWidth()
		textHeight = self.descriptionPanel:getHeight()
	end

	local textureX = 8
	local textureY = 0
	local textureWidth = 0
	local textureHeight = 0
	if self.texture then
		textureWidth = self.texture:getWidth()
		textureHeight = self.texture:getHeight() + 5
		textX = textureX + textureWidth + 2
	end

	local nameX = 8
	local nameWidth = 0
	local nameHeight = 0
	if self.name then
		nameWidth = getTextManager():MeasureStringX(UIFont.Medium, self.name) + 50
		nameHeight = getTextManager():getFontFromEnum(UIFont.Medium):getLineHeight()
		textureY = 35
		textY = 25
	end

	local myWidth = 150
	local myHeight = math.max(nameHeight, math.max(textureY + textureHeight, textY + textHeight))

	-- if myWidth < textX + textWidth then
		-- myWidth = textX + textWidth
    -- end
	if myWidth < nameWidth then
		myWidth = nameWidth
	end

--	if self.texture and myHeight < textureHeight + 40 then
--		myHeight = textureHeight + 40
--	end

	if self.footNote then
		local noteWidth = getTextManager():MeasureStringX(UIFont.Small, self.footNote)
		if myWidth < noteWidth then myWidth = noteWidth end
		local fontHgt = getTextManager():getFontFromEnum(UIFont.Small):getLineHeight()
		myHeight = myHeight + fontHgt + 4
	end

	self:setWidth(myWidth + 20)
	self:setHeight(myHeight)
end

function TRFB_ToolTip:setDesiredPosition(x, y)
	self.desiredX = x
	self.desiredY = y
	if not x or not y then return end
	self:setX(x)
	self:setY(y)
	if self.owner and self.owner.isButton then
		local ownerRect = { x = self.owner:getAbsoluteX(), y = self.owner:getAbsoluteY(), width = self.owner.width, height = self.owner.height }
		self:adjustPositionToAvoidOverlap(ownerRect)
	end
end

function TRFB_ToolTip:adjustPositionToAvoidOverlap(avoidRect)
	local myRect = { x = self.x, y = self.y, width = self.width, height = self.height }
	if self:overlaps(myRect, avoidRect) then
		local r = self:placeRight(myRect, avoidRect)
		if self:overlaps(r, avoidRect) then
			r = self:placeAbove(myRect, avoidRect)
			if self:overlaps(r, avoidRect) then
				r = self:placeLeft(myRect, avoidRect)
			end
		end
		self:setX(r.x)
		self:setY(r.y)
	end
end

function TRFB_ToolTip:overlaps(r1, r2)
	return r1.x + r1.width > r2.x and r1.x < r2.x + r2.width and
			r1.y + r1.height > r2.y and r1.y < r2.y + r2.height
end

function TRFB_ToolTip:placeLeft(r1, r2)
	local r = r1
	r.x = math.max(0, r2.x - r.width - 8)
	return r
end

function TRFB_ToolTip:placeRight(r1, r2)
	local r = r1
	r.x = r2.x + r2.width + 8
	r.x = math.min(r.x, getCore():getScreenWidth() - r.width)
	return r
end

function TRFB_ToolTip:placeAbove(r1, r2)
	local r = r1
	r.y = r2.y - r.height - 8
	r.y = math.max(0, r.y)
	return r
end

function TRFB_ToolTip:setOwner(ui)
	self.owner = ui
end


--************************************************************************--
--** ISPanel:new
--**
--************************************************************************--
function TRFB_ToolTip:new()
   local o = {}
   --o.data = {}
   o = ISPanel:new(0, 0, 0, 0);
   setmetatable(o, self)
   self.__index = self
   o:noBackground();
   o.x = 0;
   o.y = 0;
   o.name = nil;
   o.description = "";
   o.borderColor = {r=0.4, g=0.4, b=0.4, a=1};
   o.backgroundColor = {r=0, g=0, b=0, a=0};
   o.width = 0;
   o.height = 0;
   o.anchorLeft = true;
   o.anchorRight = false;
   o.anchorTop = true;
   o.anchorBottom = false;
   -- description panel
   o.descriptionPanel = ISRichTextPanel:new(0, 0, 0, 0);
   o.descriptionPanel.marginRight = 0
   o.descriptionPanel:initialise();
   o.descriptionPanel:instantiate();
   o.descriptionPanel:noBackground();
   o.descriptionPanel.backgroundColor = {r=0, g=0, b=0, a=0.3};
   o.descriptionPanel.borderColor = {r=1, g=1, b=1, a=0.1};
   o.owner = nil
   o.followMouse = true
   o.barrel = nil
   return o;
end

