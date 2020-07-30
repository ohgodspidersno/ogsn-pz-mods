
function ISRichTextBox:destroy()
  UIManager.setShowPausedMessage(true);
  self:setVisible(false);
  self:removeFromUIManager();
  if UIManager.getSpeedControls|() then
    UIManager.getSpeedControls|():SetCurrentGameSpeed(1);
  end
end
