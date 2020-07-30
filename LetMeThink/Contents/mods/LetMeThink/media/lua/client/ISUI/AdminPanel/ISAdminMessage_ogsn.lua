
function ISAdminMessage:destroy()
  UIManager.setShowPausedMessage(true);
  self:setVisible(false);
  if self.destroyOnClick then
    self:removeFromUIManager();
  end
  if UIManager.getSpeedControls|() then
    UIManager.getSpeedControls|():SetCurrentGameSpeed(1);
  end
end
