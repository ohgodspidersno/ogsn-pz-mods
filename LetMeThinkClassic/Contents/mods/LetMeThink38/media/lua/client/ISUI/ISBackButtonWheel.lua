require "ISUI/ISPanelJoypad"

ISBackButtonWheel = ISPanelJoypad:derive("ISBackButtonWheel")

function ISBackButtonWheel:update()
  if self:getIsVisible() then
    local x = getPlayerScreenLeft(self.playerNum)
    local y = getPlayerScreenTop(self.playerNum)
    local w = getPlayerScreenWidth(self.playerNum)
    local h = getPlayerScreenHeight(self.playerNum)

    x = x + w / 2
    y = y + h / 2

    local fontHgt = getTextManager():getFontFromEnum(self.font):getLineHeight()
    self:setHeight(fontHgt * 10)

    self:setX(x - self:getWidth() / 2)
    self:setY(y - self:getHeight() / 2)
  end

  ISPanelJoypad.update(self)
end

function ISBackButtonWheel:render()
  --	self:drawRect(0, 0, self:getWidth(), self:getHeight(), 0.1, 0, 0, 0);

  local dir = '?'
  if JoypadState.players[self.playerNum + 1] then
    local xAxis = getJoypadAimingAxisX(JoypadState.players[self.playerNum + 1].id)
    local yAxis = getJoypadAimingAxisY(JoypadState.players[self.playerNum + 1].id)
    if math.abs(xAxis) > 0.3 or math.abs(yAxis) > 0.3 then
      -- Degrees 0-360 counter-clockwise
      local degrees = math.atan2(-yAxis, xAxis) * 180 / math.pi
      if degrees < 0 then degrees = degrees + 360 end
      local n = degrees / (45 / 2)
      --			print('wheel x,y='..xAxis..','..yAxis..' degrees='..degrees..' n='..n)
      if n >= 15 or n < 1 then
        dir = 'e'
      elseif n >= 1 and n < 3 then
        dir = 'ne'
      elseif n >= 3 and n < 5 then
        dir = 'n'
      elseif n >= 5 and n < 7 then
        dir = 'nw'
      elseif n >= 7 and n < 9 then
        dir = 'w'
      elseif n >= 9 and n < 11 then
        dir = 'sw'
      elseif n >= 11 and n < 13 then
        dir = 's'
      elseif n >= 13 and n < 15 then
        dir = 'se'
      end
    end
  end

  self.selected = dir

  local isPaused = UIManager.getSpeedControls() and UIManager.getSpeedControls():getCurrentGameSpeed() == 0

  local fontHgt = getTextManager():getFontFromEnum(self.font):getLineHeight()
  local x = self.width / 2
  local y = fontHgt / 2
  local colNorm = { r = 1, g = 1, b = 1, a = 1 }
  local colSel = { r = 0, g = 1, b = 0, a = 1 }
  local colDisable = { r = 0.5, g = 0.5, b = 0.5, a = 1 }
  local col = {}

  col = (dir == 'n' and colSel) or colNorm
  self:drawTextCentre(getText("IGUI_BackButton_PlayerInfo"), x, y, col.r, col.g, col.b, col.a, self.font)
  y = y + fontHgt * 2
  col = (dir == 'nw' and colSel) or colNorm
  self:drawTextCentre(getText("IGUI_BackButton_Crafting"), x - 50, y, col.r, col.g, col.b, col.a, self.font)
  col = (dir == 'ne' and colSel) or colNorm
  self:drawTextCentre(getText("IGUI_BackButton_Movable"), x + 50, y, col.r, col.g, col.b, col.a, self.font)
  y = y + fontHgt * 2

  if getCore():isZoomEnabled() and not getCore():getAutoZoom(self.playerNum) then
    col = (dir == 'w' and colSel) or colNorm
    if getCore():getNextZoom(self.playerNum, 1) == getCore():getZoom(self.playerNum) then
      col = colDisable
    end
    self:drawTextCentre(getText("IGUI_BackButton_Zoom", getCore():getNextZoom(self.playerNum, 1) * 100), x - 75, y, col.r, col.g, col.b, col.a, self.font)
    col = (dir == 'e' and colSel) or colNorm
    if getCore():getNextZoom(self.playerNum, - 1) == getCore():getZoom(self.playerNum) then
      col = colDisable
    end
    self:drawTextCentre(getText("IGUI_BackButton_Zoom", getCore():getNextZoom(self.playerNum, - 1) * 100), x + 75, y, col.r, col.g, col.b, col.a, self.font)
  else
    col = (dir == 'w' and colSel) or colDisable
    self:drawTextCentre("---", x - 75, y, col.r, col.g, col.b, col.a, self.font)
    col = (dir == 'e' and colSel) or colDisable
    self:drawTextCentre("---", x + 75, y, col.r, col.g, col.b, col.a, self.font)
  end
  y = y + fontHgt * 2

  if UIManager.getSpeedControls() and not isClient() then
    col = (dir == 'sw' and colSel) or colNorm
    if UIManager.getSpeedControls():getCurrentGameSpeed() == 0 or getGameTime():getTrueMultiplier() > 1 then
      self:drawTextCentre(getText("IGUI_BackButton_Play"), x - 50, y, col.r, col.g, col.b, col.a, self.font)
    else
      self:drawTextCentre(getText("UI_optionscreen_binding_Pause"), x - 50, y, col.r, col.g, col.b, col.a, self.font)
    end

    col = (dir == 'se' and colSel) or colNorm
    local multiplier = getGameTime():getTrueMultiplier()
    if multiplier == 1 or multiplier == 40 then
      self:drawTextCentre(getText("IGUI_BackButton_FF1"), x + 50, y, col.r, col.g, col.b, col.a, self.font)
    elseif multiplier == 5 then
      self:drawTextCentre(getText("IGUI_BackButton_FF2"), x + 50, y, col.r, col.g, col.b, col.a, self.font)
    elseif multiplier == 20 then
      self:drawTextCentre(getText("IGUI_BackButton_FF3"), x + 50, y, col.r, col.g, col.b, col.a, self.font)
    end
  else
    col = (dir == 'sw' and colSel) or colDisable
    self:drawTextCentre("---", x - 50, y, col.r, col.g, col.b, col.a, self.font)
    col = (dir == 'se' and colSel) or colDisable
    self:drawTextCentre("---", x + 50, y, col.r, col.g, col.b, col.a, self.font)
  end
  y = y + fontHgt * 2

  if Core.isLastStand() then
    col = (dir == 's' and colSel) or colNorm
    self:drawTextCentre(getText("IGUI_BackButton_LastStand"), x, y, col.r, col.g, col.b, col.a, self.font)
  else
    col = (dir == 's' and colSel) or colDisable
    self:drawTextCentre("---", x, y, col.r, col.g, col.b, col.a, self.font)
  end
end

function ISBackButtonWheel:onGainJoypadFocus(joypadData)
  ISPanelJoypad.onGainJoypadFocus(self, joypadData)
  self.showPausedMessage = UIManager.isShowPausedMessage()
  UIManager.setShowPausedMessage(false)
end

function ISBackButtonWheel:onJoypadDown(button, joypadData)
  --	if button == Joypad.AButton then
  --		UIManager.setShowPausedMessage(self.showPausedMessage)
  --		self:setVisible(false)
  --		setJoypadFocus(self.playerNum, nil)
  --	end
end

function ISBackButtonWheel:onBackButtonReleased()
  UIManager.setShowPausedMessage(self.showPausedMessage)
  self:setVisible(false)
  local focus = nil
  local isPaused = UIManager.getSpeedControls() and UIManager.getSpeedControls():getCurrentGameSpeed() == 0

  if self.selected == 'n' then
    getPlayerInfoPanel(self.playerNum):setVisible(true)
    focus = getPlayerInfoPanel(self.playerNum).panel:getActiveView()
  elseif self.selected == 'nw' then
    getPlayerCraftingUI(self.playerNum):setVisible(true)
    focus = getPlayerCraftingUI(self.playerNum)
  elseif self.selected == 'ne' then
    local mo = ISMoveableCursor:new(getSpecificPlayer(self.playerNum));
    getCell():setDrag(mo, mo.player);
  elseif self.selected == 'w' and not getCore():getAutoZoom(self.playerNum) then
    getCore():doZoomScroll(self.playerNum, 1)
  elseif self.selected == 'e' and not getCore():getAutoZoom(self.playerNum) then
    getCore():doZoomScroll(self.playerNum, - 1)
  elseif self.selected == 'sw' then
    if UIManager.getSpeedControls() and not isClient() then
      if UIManager.getSpeedControls():getCurrentGameSpeed() == 0 or getGameTime():getTrueMultiplier() > 1 then
        UIManager.getSpeedControls():ButtonClicked("Play")
      elseif UIManager.getSpeedControls() then
        UIManager.getSpeedControls():ButtonClicked("Pause")
      end
    end
  elseif self.selected == 'se' then
    if UIManager.getSpeedControls() then
      local multiplier = getGameTime():getTrueMultiplier()
      if multiplier == 1 or multiplier == 40 then
        UIManager.getSpeedControls():ButtonClicked("Fast Forward x 1")
      elseif multiplier == 5 then
        UIManager.getSpeedControls():ButtonClicked("Fast Forward x 2")
      elseif multiplier == 20 then
        UIManager.getSpeedControls():ButtonClicked("Wait")
      end
    end
  elseif self.selected == 's' then
    if Core.isLastStand() then
      JoypadState.players[self.playerNum + 1].focus = nil
      doLastStandBackButtonWheel(self.playerNum, 's')
      return
    end
  end

  setJoypadFocus(self.playerNum, focus)
end

function ISBackButtonWheel:new(playerNum, x, y, width, height)
  local o = ISPanelJoypad:new(x, y, width, height)
  setmetatable(o, self)
  self.__index = self
  o.font = UIFont.Medium
  o.playerNum = playerNum
  o.selected = nil
  --	o:noBackground()
  return o
end
