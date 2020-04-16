--***********************************************************
--**                LEMMY/ROBERT JOHNSON                   **
--***********************************************************

require "ISUI/ISPanel"

ISContextMenu = ISPanel:derive("ISContextMenu");

--************************************************************************--
--** ISContextMenu:initialise
--**
--************************************************************************--

function ISContextMenu:initialise()
	ISPanel.initialise(self);
end

function ISContextMenu:isMouseOut()
	return self.mouseOut;
end

--************************************************************************--
--** ISContextMenu:onMouseMove
--**
--************************************************************************--
function ISContextMenu:onMouseMove(dx, dy)
	self.mouseOut = false;
	if self:topmostMenuWithMouse(getMouseX(), getMouseY()) ~= self then return end
	local mouseY = self:getMouseY()
	local dy = (self:getScrollHeight() > self:getScrollAreaHeight()) and self.scrollIndicatorHgt or 0
	mouseY = math.max(self.padTopBottom + dy - self:getYScroll(), mouseY)
	mouseY = math.min(self.padTopBottom + dy + self:getScrollAreaHeight() - 1 - self:getYScroll(), mouseY)
	local y = math.floor((mouseY - self.padTopBottom - dy) / self.itemHgt + 1);
	if y >= 1 and y < self.numOptions then
		if self.subMenu and (y ~= self.mouseOver) then
			self.subMenu:hideSelfAndChildren2()
			self.subMenu = nil
		end
		self.mouseOver = y;
		-- if we move over a new option, we close the previous subMenu
--		if getPlayerData(self.player) ~= nil and getPlayerContextMenu(self.player).instanceMap then
--			for i,v in ipairs(getPlayerContextMenu(self.player).instanceMap) do
--				v:setVisible(false);
--			end
--		end
--		if self.player == 0 then
--			self:hideToolTip()
--		end
	else
		self.mouseOver = -1;
	end
end

function ISContextMenu:hideSelfAndChildren2()
	self:setVisible(false)
	for i=1,#self.options do
		if self.options[i].subOption then
			if self:getSubMenu(self.options[i].subOption) then
				self:getSubMenu(self.options[i].subOption):hideSelfAndChildren2()
			end
		end
	end
end

--************************************************************************--
--** ISContextMenu:onMouseMoveOutside
--**
--************************************************************************--
function ISContextMenu:onMouseMoveOutside(dx, dy)
	if self.player == 0 then
		self.mouseOut = true;
		self:hideToolTip()
	end
end

--************************************************************************--
--** ISContextMenu:onMouseUp
--**
--************************************************************************--
function ISContextMenu:onMouseUp(x, y)
	if self:getScrollHeight() > self:getScrollAreaHeight() then
		if y < self.padTopBottom + self.scrollIndicatorHgt - self:getYScroll() then
			self:setYScroll(self:getYScroll() + self.itemHgt)
			self:onMouseMove(0, 0)
			return
		end
		if y >= self.padTopBottom + self.scrollIndicatorHgt + self:getScrollAreaHeight() - self:getYScroll() then
			self:setYScroll(self:getYScroll() - self.itemHgt)
			self:onMouseMove(0, 0)
			return
		end
	end
	if self.mouseOver ~= -1 and self:getIsVisible() then
		--print("calling option : " .. self.options[self.mouseOver].name);
		-- we call the function if we have one
		if self.options[self.mouseOver] ~= nil and self.options[self.mouseOver].onSelect ~= nil and not self.options[self.mouseOver].notAvailable then
            ISContextMenu.globalPlayerContext = self.player;
            self.options[self.mouseOver].onSelect(self.options[self.mouseOver].target, self.options[self.mouseOver].param1, self.options[self.mouseOver].param2, self.options[self.mouseOver].param3, self.options[self.mouseOver].param4, self.options[self.mouseOver].param5, self.options[self.mouseOver].param6);
			self:setVisible(false);
			self.visibleCheck = false
			self:hideToolTip()
            self.forceVisible = false;
			local parent = self.parent;
			while parent do
				parent:setVisible(false);
				parent = parent.parent;
            end
 		end
	end
end

function ISContextMenu:onMouseWheel(del)
	self:setYScroll(self:getYScroll() - del * self.itemHgt)
	self:onMouseMove(0, 0)
	return true
end

function ISContextMenu:ensureVisible()
	if not self.mouseOver then return end
	if self:getScrollHeight() <= self:getScrollAreaHeight() then return end
	local topY = self.padTopBottom + ((self:getScrollHeight() > self:getScrollAreaHeight()) and self.scrollIndicatorHgt or 0)
	local topItem = math.floor((topY - self:getYScroll()) / self.itemHgt) + 1
	local numVisibleItems = math.floor(self:getScrollAreaHeight() / self.itemHgt)
	local bottomItem = topItem + numVisibleItems - 1
	if self.mouseOver < topItem then
		self:setYScroll(0 - (self.mouseOver - 1) * self.itemHgt)
	elseif self.mouseOver > bottomItem then
		self:setYScroll(0 - (self.mouseOver - numVisibleItems) * self.itemHgt)
	end
end

function ISContextMenu:onFocus(x, y)
	-- do not call bringToTop(), otherwise the root context menu is drawn before
	-- its child menus, and render() sets the visibility of the submenu that the
	-- mouse is over
end

function ISContextMenu:onJoypadDirUp()
    if self.subMenu then
        self.subMenu:hideAndChildren()
        self.subMenu = nil
    end
    if self.mouseOver == nil then self.mouseOver = 1; end
    self.mouseOver = self.mouseOver - 1;
    if self.mouseOver <= 0 then
        self.mouseOver = self.numOptions - 1;
    end
    self:hideToolTip()
    self.mouseOut = false
    self:ensureVisible()
end

function ISContextMenu:onJoypadDirDown()
    if self.subMenu then
        self.subMenu:hideAndChildren()
        self.subMenu = nil
    end
    if self.mouseOver == nil then self.mouseOver = 1; end
    self.mouseOver = self.mouseOver + 1;
    if self.mouseOver >= self.numOptions then
        self.mouseOver = 1;
    end
    self:hideToolTip()
    self.mouseOut = false
    self:ensureVisible()
end

function ISContextMenu:onJoypadDirLeft()
    if self.parent then
		if self.subMenu then
			self.subMenu:hideAndChildren()
			self.subMenu = nil
		end
		self.mouseOver = nil
		self:hideToolTip()
		setJoypadFocus(self.player, self.parent)
	end
end

function ISContextMenu:onJoypadDirRight()
	local option = self.options[self.mouseOver]
	if option ~= nil and option.onSelect == nil and option.subOption ~= nil then
		self:hideToolTip()
		local subMenu = self:getSubMenu(option.subOption)
		subMenu.forceVisible = true
		subMenu.mouseOver = 1
		setJoypadFocus(self.player, subMenu)
		subMenu:ensureVisible()
	end
end

function ISContextMenu:hideAndChildren()
    self:setVisible(false);
    self.visibleCheck = false;
    self.forceVisible = false;
    self:hideToolTip()
    for _,option in ipairs(self.options) do
        if option.subOption and self:getSubMenu(option.subOption) then
            self:getSubMenu(option.subOption):hideAndChildren()
        end
    end
    -- FIXME: this only works for the global context menu for each player
    if self.instanceMap == nil or #self.instanceMap == 0 then return;end
    for k, v in ipairs(self.instanceMap) do
        v:hideAndChildren();
    end
end

function ISContextMenu:hideToolTip()
	if self.toolTip ~= nil then
		if self.toolTip.barrel then
			self.toolTip.barrel:setHighlighted(false);
		end
		self.toolTip:removeFromUIManager()
		self.toolTip:setVisible(false)
		self.toolTip = nil
	end
end

function ISContextMenu:onJoypadDown(button)
    if button == Joypad.AButton then
        if self.mouseOver > 0 and self:getIsVisible() then
            --print("calling option : " .. self.options[self.mouseOver].name);
            -- we call the function if we have one
            if self.options[self.mouseOver] ~= nil and self.options[self.mouseOver].onSelect == nil  and self.options[self.mouseOver].subOption ~= nil then
                self:getSubMenu(self.options[self.mouseOver].subOption).mouseOver = 1;
                setJoypadFocus(self.player, self:getSubMenu(self.options[self.mouseOver].subOption));
            elseif self.options[self.mouseOver] ~= nil and self.options[self.mouseOver].onSelect ~= nil and not self.options[self.mouseOver].notAvailable then
                ISContextMenu.globalPlayerContext = self.player;
                print(ISContextMenu.globalPlayerContext);
                self:setVisible(false);
                self.visibleCheck = false
                self:hideToolTip()
                self.forceVisible = false;
                local parent = self.parent;
                if(parent == nil) then setJoypadFocus(self.player, self.origin); end
                while parent do
                    parent:setVisible(false);
                    if parent.parent == nil then
                        setJoypadFocus(self.player, parent.origin);
                    end
                    parent = parent.parent;
                  end
                self:hideAndChildren();
                self.options[self.mouseOver].onSelect(self.options[self.mouseOver].target, self.options[self.mouseOver].param1, self.options[self.mouseOver].param2, self.options[self.mouseOver].param3, self.options[self.mouseOver].param4, self.options[self.mouseOver].param5, self.options[self.mouseOver].param6);


            end
        end
    end
    if button == Joypad.BButton then
         self:setVisible(false);
        self.visibleCheck = false
        self.forceVisible = false;
        self:hideToolTip()

        local parent = self.parent;
        if(parent == nil) then setJoypadFocus(self.player, self.origin); end
        while parent do
            parent:setVisible(false);
            if parent.parent == nil then
                setJoypadFocus(self.player, parent.origin);
            end
            parent = parent.parent;
        end
        self:hideAndChildren();
      --  setPrevFocusForPlayer(self.player);

    end
end
function ISContextMenu:onMouseDownOutside(x, y)
	if self.player == 0 then
		self:setVisible(false);
		self.visibleCheck = false
		self:hideToolTip()
	end
end
--************************************************************************--
--** ISContextMenu:onMouseDown
--**
--************************************************************************--
function ISContextMenu:onMouseDown(x, y)

end
--************************************************************************--
--** ISContextMenu:render
--**
--************************************************************************--
function ISContextMenu:prerender()
	local c = 1;

	for i,k in ipairs(self.options) do
		c = c + 1;
	end
	if c == 1 then
		self:setX(100000); -- cheap hack for now ��
		return;
	end
end

function ISContextMenu:render()
	self.visibleCheck = true;
	local c = 1;

	for i,k in ipairs(self.options) do
		c = c + 1;
	end
	if c == 1 then
		return;
	end
	local y = self.padTopBottom;
	local dy = 0
	if self:getScrollHeight() > self:getScrollAreaHeight() then
		dy = self.scrollIndicatorHgt
		y = y + dy
	end

	self:drawRect(0, dy - self:getYScroll(), self.width, self.height - dy * 2, self.backgroundColor.a, self.backgroundColor.r, self.backgroundColor.g, self.backgroundColor.b);
	self:drawRect(0, dy - self:getYScroll(), 17, self.height - dy * 2, UIManager.isFBOActive() and 0.8 or 0.6, 0.1, 0.1, 0.1);
	self:drawRectBorderStatic(0, dy, self.width, self.height - dy * 2, self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b)

	local highestWid = 0;

	local textDY = (self.itemHgt - self.fontHgt) / 2

	self.currentOptionRect = { x = self.x, y = self.y + y + self:getYScroll(), width = 100, height = self.itemHgt }
	c = 1;
	local sizeMap = {};
	local offTop,offBottom = false,false
	local showTooltip = false
	for i,k in ipairs(self.options) do
        if k.disable then return; end
		local sub = nil;
		if y + self:getYScroll() < 0 then
			-- off the top
			offTop = true
		elseif y + self:getYScroll() + self.itemHgt > self.scrollIndicatorHgt + self.padTopBottom + self:getScrollAreaHeight() then
			-- off the bottom
			offBottom = true
		elseif self.mouseOver == c then
			if k.notAvailable then
				self:drawRect(0, y, self.width, self.itemHgt, 0.1, 0.05, 0.05, 0.05);
				self:drawRectBorder(0, y, self.width, self.itemHgt, 0.15, 0.9, 0.9, 1);
				self:drawText(k.name, 24, y+textDY, 1, 0.2, 0.2, 0.85, self.font);
                if k.subOption ~= nil then
                    self:drawTextRight(">", self.width - 4, y+textDY, 1, 0.2, 0.2, 0.85, self.font);
                end
			else
				self:drawRect(0, y, self.width, self.itemHgt, 0.7, 0.05, 0.05, 0.05);
				self:drawRectBorder(0, y, self.width, self.itemHgt, 0.15, 0.9, 0.9, 1);
				self:drawText(k.name, 24, y+textDY, 1, 1, 1, 1, self.font);
			end
--~ 			if k.textDisplay then
--~ 			if ISContextMenu.toolTip ~= nil then
--~ 				ISContextMenu.toolTip:removeFromUIManager();
--~ 				ISContextMenu.toolTip:setVisible(false);
--~ 				ISContextMenu.toolTip = nil;
--~ 			elseif k.toolTip and not self:isMouseOut() then
--~ 				ISContextMenu.toolTip = k.toolTip;
--~ 				ISContextMenu.toolTip:setVisible(true);
--~ 				ISContextMenu.toolTip:addToUIManager();
--~ 			end

			local isMouseOut = self:isMouseOut()
			if JoypadState.players[self.player+1] and not self.joyfocus then
				isMouseOut = true
			end
			if k.toolTip and not isMouseOut then
				if self.toolTip and self.toolTip ~= k.toolTip then
					self:hideToolTip()
				end
				if not self.toolTip then
                    self.toolTip = k.toolTip;
                    self.toolTip:setVisible(true);
                    self.toolTip:addToUIManager();
                    self.toolTip.followMouse = not self.joyfocus
				end
				showTooltip = true
			end
--~ 				self:drawText(k.textDisplay, self:getMouseX(), self:getMouseY(), 1, 1, 1, 1, UIFont.Normal);
--~ 			end
			-- if we have a subOption, we set it visible
			if k.subOption ~= nil then
				self:drawTextRight(">", self.width - 4, y+textDY, 1, 1, 1, 1, self.font);
				if self.forceVisible then
					self.subMenu = self:getSubMenu(k.subOption);
					self.subMenu:setVisible(true);
					-- is position is next to our selected option
					dy = (self.subMenu:getScrollHeight() > self.subMenu:getScrollAreaHeight()) and self.scrollIndicatorHgt or 0
					self:getSubMenu(k.subOption):setY(y - self.subMenu.padTopBottom + self.y + self:getYScroll() - dy);
					table.insert(sizeMap, self:getSubMenu(k.subOption));
				end
			end
			self.currentOptionRect = { x = self.x, y = self.y + y + self:getYScroll(), width = 100, height = self.itemHgt }
		else
			if k.notAvailable then
				self:drawText(k.name, 24, y+textDY, 1, 0.2, 0.2, 0.85, self.font);
                if k.subOption ~= nil then
                    self:drawTextRight(">", self.width - 4, y+textDY, 1, 0.2, 0.2, 0.85, self.font);
                end
            else
                if self.blinkOption == k.name then
                    if not self.blinkAlpha then
                        self.blinkAlpha = 1;
                        self.blinkAlphaIncrease = false;
                    end

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

                    self:drawRect(0, y, self.width, self.itemHgt, self.blinkAlpha, 1, 1, 1);
                end
				self:drawText(k.name, 24, y+textDY, 1, 0.8, 0.8, 0.9, self.font);
				if k.subOption ~= nil then
					self:drawTextRight(">", self.width - 4, y+textDY, 1, 0.8, 0.8, 0.9, self.font);
				end
			end
		end
		y = y + self.itemHgt;
		local w = getTextManager():MeasureStringX(self.font, k.name);
		if(w > highestWid) then
			highestWid = w;
		end
		c = c + 1;
	end

	if offTop then
		self:drawRect(0, 0 - self:getYScroll(), self.width, self.scrollIndicatorHgt, 0.8, 0.1, 0.1, 0.1);
		local x = self.width / 2 - 14 - 7
		self:drawTexture(self.arrowUp, x, 0 - self:getYScroll(), 1, 1, 1, 1)
		self:drawTexture(self.arrowUp, x + 14, 0 - self:getYScroll(), 1, 1, 1, 1)
		self:drawTexture(self.arrowUp, x + 14 * 2, 0 - self:getYScroll(), 1, 1, 1, 1)
	end
	if offBottom then
		self:drawRect(0, self.height - self.scrollIndicatorHgt - self:getYScroll(), self.width, self.scrollIndicatorHgt, 0.8, 0.1, 0.1, 0.1);
		local x = self.width / 2 - 14 - 7
		self:drawTexture(self.arrowDown, x, self.height - self.scrollIndicatorHgt - self:getYScroll(), 1, 1, 1, 1)
		self:drawTexture(self.arrowDown, x + 14, self.height - self.scrollIndicatorHgt - self:getYScroll(), 1, 1, 1, 1)
		self:drawTexture(self.arrowDown, x + 14 * 2, self.height - self.scrollIndicatorHgt - self:getYScroll(), 1, 1, 1, 1)
	end

	if self.toolTip then
        self.toolTip:setContextMenu(self);
        self.toolTip:setVisible(true);
--~ 		self:drawText(displayText, self:getMouseX(), self:getMouseY(), 1, 1, 1, 1, UIFont.Normal);
	end

	local ww = highestWid + 24 + 40;
	if(ww<100) then
		ww = 100;
	end
	self:setWidth(ww);
	self.currentOptionRect.width = ww

	-- we make his x at the edge of the current menu
	-- place submenu to the left if there is no room on the right
	for _,subMenu in ipairs(sizeMap) do
		local subMenuWidth = subMenu:calcWidth()
		if self.x + ww + 1 + subMenuWidth > getCore():getScreenWidth() then
			subMenu:setX(self.x - subMenuWidth - 1)
		else
			subMenu:setX(self.x + ww + 1)
		end
	end

	if not showTooltip and self.player == 0 then
		self:hideToolTip()
	end
end

function ISContextMenu:calcHeight()
	local itemsHgt = (self.numOptions - 1) * self.itemHgt
	local screenHgt = getCore():getScreenHeight()
--	screenHgt = 200
	if itemsHgt + self.padTopBottom * 2 > screenHgt then
		local numVisibleItems = math.floor((screenHgt - self.padTopBottom * 2 - self.scrollIndicatorHgt * 2) / self.itemHgt)
		self.scrollAreaHeight = numVisibleItems * self.itemHgt
		self:setHeight(self.scrollAreaHeight + self.padTopBottom * 2 + self.scrollIndicatorHgt * 2)
		self:setScrollHeight(itemsHgt)
	else
		self.scrollAreaHeight = itemsHgt
		self:setHeight(itemsHgt + self.padTopBottom * 2)
		self:setScrollHeight(itemsHgt)
	end
end

function ISContextMenu:calcWidth()
	local maxWidth = 0
	for _,k in ipairs(self.options) do
		local w = getTextManager():MeasureStringX(self.font, k.name)
		if(w > maxWidth) then
			maxWidth = w
		end
	end
	return math.max(maxWidth + 24 + 40, 100)
end

function ISContextMenu:topmostMenuWithMouse(x, y)
	local menu = nil
	if self == getPlayerContextMenu(self.player) then
		if x >= self.x and x < self.x + self.width and y >= self.y and y < self.y + self.height then
			menu = self
		end
	end
	for i=1,#getPlayerContextMenu(self.player).instanceMap do
		local m = getPlayerContextMenu(self.player).instanceMap[i]
		if m:getIsVisible() and x >= m.x and x < m.x + m.width and y >= m.y and y < m.y + m.height then
--		if m:getIsVisible() and not m.mouseOut then
			menu = m
		end
	end
	return menu
end

function ISContextMenu:addOption(name, target, onSelect, param1, param2, param3, param4, param5, param6)

	local menu = {id=self.numOptions, name=name, onSelect=onSelect, target=target, param1 = param1, param2 = param2, param3 = param3, param4 = param4, param5 = param5, param6 = param6, subOption = nil};
	self.options[self.numOptions] =  menu;
	self.numOptions = self.numOptions + 1;
	self:calcHeight()
	self:setWidth(self:calcWidth())
	return menu;
end

function ISContextMenu:removeLastOption()
    self.options[self.numOptions - 1] =  nil;
    self.numOptions = self.numOptions -1;
	self:calcHeight()
end
--
 function ISContextMenu:addSubMenu(option, subMenuNum)

	option.subOption = subMenuNum;
 end

  function ISContextMenu:addSubMenu(option, menu)
	option.subOption = menu.subOptionNums;
 end

function ISContextMenu:clear()
	self.options = {}
	self.numOptions = 1;
	self.mouseOver = -1
end

function ISContextMenu:isEmpty()
	return self.numOptions == 1
end

function ISContextMenu:getScrollAreaHeight()
	return self.scrollAreaHeight or 0
end

function ISContextMenu:setFont(font)
	self.font = font or UIFont.Medium
	self.fontHgt = getTextManager():getFontHeight(self.font)
	self.itemHgt = self.fontHgt + self.padY * 2
end

function ISContextMenu:setFontFromOption()
	local font = getCore():getOptionContextMenuFont()
	if font == "Large" then
		self:setFont(UIFont.Large)
	elseif font == "Small" then
		self:setFont(UIFont.Small)
	else
		self:setFont(UIFont.Medium)
	end
end

--************************************************************************--
--** ISContextMenu:new
--**
--************************************************************************--
function ISContextMenu:new (x, y, width, height, zoom)
	local o = {}
	--o.data = {}
	o = ISPanel:new(x, y, width, height);
	setmetatable(o, self)
	self.__index = self
	o.x = x;
	o.y = y;
	o.zoom = zoom;
	o.font = UIFont.Medium;
	o.padY = 6
	o.fontHgt = getTextManager():getFontFromEnum(o.font):getLineHeight()
	o.itemHgt = o.fontHgt + o.padY * 2
	o.padTopBottom = 0
	o.borderColor = {r=1, g=1, b=1, a=0.15};
	o.backgroundColor = {r=0.1, g=0.1, b=0.1, a=0.7};
	o.backgroundColorMouseOver = {r=0.3, g=0.3, b=0.3, a=1.0};
	o.width = width;
	o.height = height;
	o.anchorLeft = true;
	o.anchorRight = false;
	o.anchorTop = true;
	o.anchorBottom = false;
	o.parent = {};
	-- Must override ISUIElement getKeepOnScreen because parent ~= null for sub menus
	o.keepOnScreen = true
	o.options = {};
	o.numOptions = 1;
	o.visibleCheck = false;
    o.forceVisible = true;
    o.toolTip = nil;
	o.subOptionNums = 0;
    o.player = 0;
    o.scrollIndicatorHgt = 14
    o.arrowUp = getTexture("media/ui/ArrowUp.png")
    o.arrowDown = getTexture("media/ui/ArrowDown.png")
	return o
end

ISContextMenu.get = function(player, x, y)
    local context = getPlayerContextMenu(player);
	context:hideAndChildren();
    context:setVisible(true);
    context:clear();
    context:setFontFromOption()
	context.forceVisible = true;
    context.parent = nil;
    context:setX(x);
    context:setY(y);
    context:bringToTop();
    context:setVisible(true);
    context.visibleCheck = true;
    if context.instanceMap then
        for _,v in pairs(context.instanceMap) do
            v:removeFromUIManager()
        end
    end
    context.instanceMap = {}
    context.subOptionNums = 0;
    context.subInstance = {}
	context.player = player;
	return context;
end

function ISContextMenu:getNew(parentContext)
	local context = getPlayerContextMenu(parentContext.player);
	context.subInstance = ISContextMenu:new(0, 0, 1, 1, 1.5);
    context.subInstance:initialise();
    context.subInstance:instantiate();
    context.subInstance:addToUIManager();
    context.subInstance:clear();
    context.subInstance:setFontFromOption()
    context.subInstance:setX(parentContext:getX());
    context.subInstance:setY(parentContext:getY());
    context.subInstance.parent = parentContext;
    context.subInstance:setVisible(false);
    context.subInstance:bringToTop();
	context.subInstance.player = parentContext.player;
	context.subOptionNums = context.subOptionNums + 1;
	context.subInstance.subOptionNums = context.subOptionNums;
    context.instanceMap[context.subOptionNums] = context.subInstance;
	return context.subInstance;
end

function ISContextMenu:getSubMenu(num)
	return getPlayerContextMenu(self.player):getSubInstance(num)
end

function ISContextMenu:getSubInstance(num)
	return self.instanceMap[num];
end

ISContextMenu.wantNoise = false
ISContextMenu.noise = function(msg)
	if (ISContextMenu.wantNoise) then print('ISContextMenu: '..msg) end
end


