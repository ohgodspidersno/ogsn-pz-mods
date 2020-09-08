ISWorldObjectContextMenu = ISWorldObjectContextMenu or {}

ISWorldObjectContextMenu.doScavengeOptions = function(context, player, scavengeZone, clickedSquare)
  local text = "";
  local zone = ISScavengeAction.getScavengingZone(clickedSquare:getX(), clickedSquare:getY());
  if not zone then
    text = "(100" .. getText("ContextMenu_FullPercent") .. ")"
  else
    local plantLeft = tonumber(zone:getName());
    local scavengeZoneIncrease = 0;
    local scavengeZoneTime = 50000 -- default vanilla time (for all settings)
    if SandboxVars.NatureAbundance == 1 then -- very poor
      -- scavengeZoneIncrease = -5;
      scavengeZoneTime = 1000000
    elseif SandboxVars.NatureAbundance == 2 then -- poor
      scavengeZoneTime = 500000
      -- scavengeZoneIncrease = -2;
    elseif SandboxVars.NatureAbundance == 3 then -- normal
      scavengeZoneTime = 250000
      -- scavengeZoneIncrease = 0;
    elseif SandboxVars.NatureAbundance == 4 then -- abundant
      -- scavengeZoneIncrease = 2;
      scavengeZoneTime = 150000
    elseif SandboxVars.NatureAbundance == 5 then -- very abundant
      -- scavengeZoneIncrease = 5;
      scavengeZoneTime = 50000 -- default vanilla time (for all settings)
    end
    local scavengeZoneNumber = ZombRand(5, 15) + scavengeZoneIncrease;
    if scavengeZoneNumber <= 0 then
      scavengeZoneNumber = 1;
    end
    if getGametimeTimestamp() - zone:getLastActionTimestamp() > scavengeZoneTime then
      zone:setName(scavengeZoneNumber .. "");
      zone:setOriginalName(scavengeZoneNumber .. "");
    end
    if zone:getName() == "0" then
      text = "(" .. getText("ContextMenu_Empty") .. ")";
    else
      text = "(" .. math.floor((tonumber(zone:getName()) / tonumber(zone:getOriginalName())) * 100) .. getText("ContextMenu_FullPercent") .. ")";
    end
  end

  context:addOption(getText("ContextMenu_Forage") .. " " .. text, nil, ISWorldObjectContextMenu.onScavenge, player, scavengeZone, clickedSquare);
end
