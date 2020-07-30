function ISModalDialog:destroy()
  local inGame = MainScreen.instance and MainScreen.instance.inGame and not MainScreen.instance:getIsVisible()
  UIManager.setShowPausedMessage(inGame);
  self:setVisible(false);
  self:removeFromUIManager();
  if UIManager.getSpeedControls|() and inGame then
    UIManager.getSpeedControls|():SetCurrentGameSpeed(1);
  end
end
