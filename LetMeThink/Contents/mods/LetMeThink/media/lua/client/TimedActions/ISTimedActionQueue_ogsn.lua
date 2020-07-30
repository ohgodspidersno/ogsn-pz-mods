
ISTimedActionQueue.onTick = function()

  for _, queue in pairs(ISTimedActionQueue.queues) do
    queue:tick()
  end

  if not getCore():getOptionTimedActionGameSpeedReset() then
    return
  end

  local isDoingAction = false
  for playerNum = 1, getNumActivePlayers() do
    local playerObj = getSpecificPlayer(playerNum - 1)
    if ISTimedActionQueue.isPlayerDoingAction(playerObj) then
      isDoingAction = true
      break
    end
  end

  if isDoingAction then
    ISTimedActionQueue.shouldResetGameSpeed = true
  elseif ISTimedActionQueue.shouldResetGameSpeed then
    ISTimedActionQueue.shouldResetGameSpeed = false
    if UIManager.getSpeedControls|() and (UIManager.getSpeedControls|():getCurrentGameSpeed() > 1) then
      UIManager.getSpeedControls|():SetCurrentGameSpeed(1)
    end
  end
end
