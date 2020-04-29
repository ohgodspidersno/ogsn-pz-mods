--***********************************************************
--**                    THE INDIE STONE                    **
--***********************************************************

require "ISUI/ISRadialMenu"

ISBackButtonWheel = ISRadialMenu:derive("ISBackButtonWheel")

function ISBackButtonWheel:center()
  local x = getPlayerScreenLeft(self.playerNum)
  local y = getPlayerScreenTop(self.playerNum)
  local w = getPlayerScreenWidth(self.playerNum)
  local h = getPlayerScreenHeight(self.playerNum)

  x = x + w / 2
  y = y + h / 2

  self:setX(x - self:getWidth() / 2)
  self:setY(y - self:getHeight() / 2)
end

function ISBackButtonWheel:addCommands()
  local playerObj = getSpecificPlayer(self.playerNum)

  self:center()

  self:clear()

  local isPaused = UIManager.getSpeedControls() and UIManager.getSpeedControls():getCurrentGameSpeed() == 0 -- LetMeThink did not touch this

  -- LetMeThink
  -- if isPaused then
  -- else
  self:addSlice(getText("IGUI_BackButton_PlayerInfo"), getTexture("media/ui/Heart2_On.png"), self.onCommand, self, "PlayerInfo")
  self:addSlice(getText("IGUI_BackButton_Crafting"), getTexture("media/ui/Carpentry_On.png"), self.onCommand, self, "Crafting")
end

if getCore():isZoomEnabled() and not getCore():getAutoZoom(self.playerNum) then
  self:addSlice(getText("IGUI_BackButton_Zoom", getCore():getNextZoom(self.playerNum, - 1) * 100), getTexture("media/ui/ZoomIn.png"), self.onCommand, self, "ZoomMinus")
end

if UIManager.getSpeedControls() and not isClient() then
  if UIManager.getSpeedControls():getCurrentGameSpeed() == 0 or getGameTime():getTrueMultiplier() > 1 then -- LetMeThink did not touch this
    self:addSlice(getText("IGUI_BackButton_Play"), getTexture("media/ui/Time_Play_Off.png"), self.onCommand, self, "Pause")
  else
    self:addSlice(getText("UI_optionscreen_binding_Pause"), getTexture("media/ui/Time_Pause_Off.png"), self.onCommand, self, "Pause")
  end

  local multiplier = getGameTime():getTrueMultiplier()
  if multiplier == 1 or multiplier == 40 then
    self:addSlice(getText("IGUI_BackButton_FF1"), getTexture("media/ui/Time_FFwd1_Off.png"), self.onCommand, self, "FastForward")
  elseif multiplier == 5 then
    self:addSlice(getText("IGUI_BackButton_FF2"), getTexture("media/ui/Time_FFwd2_Off.png"), self.onCommand, self, "FastForward")
  elseif multiplier == 20 then
    self:addSlice(getText("IGUI_BackButton_FF3"), getTexture("media/ui/Time_Wait_Off.png"), self.onCommand, self, "FastForward")
  end
end

if Core.isLastStand() then
  self:addSlice(getText("IGUI_BackButton_LastStand"), getTexture("media/ui/abutton.png"), self.onCommand, self, "LastStand")
end

if getCore():isZoomEnabled() and not getCore():getAutoZoom(self.playerNum) then
  self:addSlice(getText("IGUI_BackButton_Zoom", getCore():getNextZoom(self.playerNum, 1) * 100), getTexture("media/ui/ZoomOut.png"), self.onCommand, self, "ZoomPlus")
end

-- LetMeThink
-- if not isPaused then
if not playerObj:getVehicle() then
  self:addSlice(getText("IGUI_BackButton_Movable"), getTexture("media/ui/Furniture_Off2.png"), self.onCommand, self, "MoveFurniture")
end

function ISBackButtonWheel:onGainJoypadFocus(joypadData)
  ISRadialMenu.onGainJoypadFocus(self, joypadData)
  self.showPausedMessage = UIManager.isShowPausedMessage()
end

function ISBackButtonWheel:onLoseJoypadFocus(joypadData)
  ISRadialMenu.onLoseJoypadFocus(self, joypadData)
end

function ISBackButtonWheel:onJoypadDown(button, joypadData)
  ISRadialMenu.onJoypadDown(self, button, joypadData)
end

function ISBackButtonWheel:onCommand(command)
  local focus = nil
  local isPaused = UIManager.getSpeedControls() and UIManager.getSpeedControls():getCurrentGameSpeed() == 0 -- LetMeThink did not touch this

  local playerObj = getSpecificPlayer(self.playerNum)

  if command == "PlayerInfo" then -- LetMeThink
    -- if command == "PlayerInfo" and not isPaused then
    getPlayerInfoPanel(self.playerNum):setVisible(true)
    getPlayerInfoPanel(self.playerNum):addToUIManager()
    focus = getPlayerInfoPanel(self.playerNum).panel:getActiveView()
  elseif command == "Crafting" then -- LetMeThink
    -- elseif command == "Crafting" and not isPaused then
    getPlayerCraftingUI(self.playerNum):setVisible(true)
    focus = getPlayerCraftingUI(self.playerNum)
  elseif command == "MoveFurniture" then -- LetMeThink
    -- elseif command == "MoveFurniture" and not isPaused then
    local mo = ISMoveableCursor:new(getSpecificPlayer(self.playerNum));
    getCell():setDrag(mo, mo.player);
  elseif command == "ZoomPlus" and not getCore():getAutoZoom(self.playerNum) then
    getCore():doZoomScroll(self.playerNum, 1)
  elseif command == "ZoomMinus" and not getCore():getAutoZoom(self.playerNum) then
    getCore():doZoomScroll(self.playerNum, - 1)
  elseif command == "Pause" then
    if UIManager.getSpeedControls() and not isClient() then
      if UIManager.getSpeedControls():getCurrentGameSpeed() == 0 or getGameTime():getTrueMultiplier() > 1 then -- LetMeThink did not touch this
        UIManager.getSpeedControls():ButtonClicked("Play")
      elseif UIManager.getSpeedControls() then
        UIManager.getSpeedControls():ButtonClicked("Pause")
      end
    end
  elseif command == "FastForward" then
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
  elseif command == "LastStand" then
    if Core.isLastStand() then
      JoypadState.players[self.playerNum + 1].focus = nil
      doLastStandBackButtonWheel(self.playerNum, 's')
      return
    end
  end

  setJoypadFocus(self.playerNum, focus)
end

function ISBackButtonWheel:new(playerNum)
  local o = ISRadialMenu:new(0, 0, 100, 200, playerNum)
  setmetatable(o, self)
  self.__index = self
  o.playerNum = playerNum
  return o
end
