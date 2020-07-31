
local ISFirearmRadialMenu_checkKey_original =  ISFirearmRadialMenu.checkKey
function ISFirearmRadialMenu.checkKey(key, ...)
  if UIManager.getSpeedControls|() and (UIManager.getSpeedControls|():getCurrentGameSpeed() ~= 0) then
    ISFirearmRadialMenu_checkKey_original(self, key, ...)
  end

  if key ~= getCore():getKey("ReloadWeapon") then
    return false
  end

  local playerObj = getSpecificPlayer(0)
  if not playerObj or playerObj:isDead() then
    return false
  end

  local queue = ISTimedActionQueue.queues[playerObj]
  if queue and #queue.queue > 0 then
    return false
  end
  return true
end
