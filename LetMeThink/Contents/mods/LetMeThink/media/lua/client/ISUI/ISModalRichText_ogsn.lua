
function ISModalRichText:destroy()
  UIManager.setShowPausedMessage(true);
  self:setVisible(false);
  if self.destroyOnClick then
    self:removeFromUIManager();
  end
  if UIManager.getSpeedControls|() then
    UIManager.getSpeedControls|():SetCurrentGameSpeed(1);
  end
  if self.player and JoypadState.players[self.player + 1] then
    setJoypadFocus(self.player, nil);
  end
end
