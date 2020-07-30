
function ISInventoryPage:toggleStove()
  if UIManager.getSpeedControls|() and UIManager.getSpeedControls|():getCurrentGameSpeed() == 0 then
    return
  end

  local object = self.inventoryPane.inventory:getParent()
  if not object then return end
  local className = object:getObjectName()
  TurnOnOff[className].toggle(object)
end
