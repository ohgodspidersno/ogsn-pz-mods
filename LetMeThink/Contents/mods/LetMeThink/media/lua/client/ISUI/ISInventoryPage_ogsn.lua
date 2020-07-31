local ISInventoryPage_toggleStove_original = ISInventoryPage.toggleStove
function ISInventoryPage:toggleStove(...)
  if UIManager.getSpeedControls|() and UIManager.getSpeedControls|():getCurrentGameSpeed() ~= 0 then
    ISInventoryPage_toggleStove_original(self, ...)
  end

  local object = self.inventoryPane.inventory:getParent()
  if not object then return end
  local className = object:getObjectName()
  TurnOnOff[className].toggle(object)
end
