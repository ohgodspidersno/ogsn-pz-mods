
local ISHealthPanel_onBodyPartListRightMouseUp_original = ISHealthPanel.onBodyPartListRightMouseUp
function ISHealthPanel:onBodyPartListRightMouseUp(x, y, ...)
  if UIManager.getSpeedControls|():getCurrentGameSpeed() ~= 0 then
    ISHealthPanel_onBodyPartListRightMouseUp_original(self, x, y, ...)
  end

  local row = self:rowAt(x, y)
  if row < 1 or row > #self.items then return end
  self.selected = row
  local healthPanel = self.parent
  healthPanel:doBodyPartContextMenu(self.items[row].item.bodyPart, self:getX() + x, self:getY() + y)
end
