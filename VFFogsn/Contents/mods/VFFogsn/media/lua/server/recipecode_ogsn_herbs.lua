-- Note: ISCraftAction:perform() in the vanilla code is a good reference
function MakeCupHerbalTeaOGSN(items, result, player)
  print('starting MakeCupHerbalTeaOGSN')
  local rotten = false
  local fresh = true

  for i = 0, items:size() - 1 do
    print('in loop. i =')
    print(i)
    local item = items:get(i)
    local type = item:getType()
    if type ~= "WaterMug" and type ~= "FullKettle" then
        if not item:isFresh() then
          fresh = false
        end
        if item:isRotten() then
          rotten = true
          fresh = false
        end
    end
  end

  result:setRotten(rotten) -- pass on the rotten status of the worst ingredient
  if rotten then -- if it was rotten strip it of any positive effects
    result:setFluReduction(0)
    result:setReduceFoodSickness(0)
    result:setPainReduction(0)
    result:setEnduranceChange(0)
    result:setFatigueChange(0)
  end
end

function CookRawHerbOGSN(herb)
  local driedType = nil
  local oven = herb:getContainer();

  if not herb:isRotten() then -- if it was not rotten, replace it with the dried version, already cooked
    if     herb:getType() == "CommonMallow" then driedType = "Base.CommonMallowDried"
    elseif herb:getType() == "LemonGrass" then driedType = "Base.LemonGrassDried"
    elseif herb:getType() == "BlackSage" then driedType = "Base.BlackSageDried"
    elseif herb:getType() == "Ginseng" then driedType = "Base.GinsengDried"
    elseif herb:getType() == "Rosehips" then driedType = "Base.RosehipsDried"
    elseif herb:getType() == "GrapeLeaves" then driedType = "Base.GrapeLeavesDried"
    elseif herb:getType() == "Violets" then driedType = "Base.VioletsDried"
    elseif herb:getType() == "Plantain" then driedType = "Base.PlantainDried"
    elseif herb:getType() == "WildGarlic" then driedType = "Base.WildGarlicDried"
    elseif herb:getType() == "Teabag_Medicinal" then driedType = "Base.Teabag_MedicinalDried"
    elseif herb:getType() == "Teabag_Energizing" then driedType = "Base.Teabag_EnergizingDried"
    end
  end

  if not driedType then return end -- to handle weirdness. this shouldn't happen.

  local driedHerb = InventoryItemFactory.CreateItem(driedType);
  oven:Remove(herb)
  oven:AddItem(driedHerb)
end

function MakeHerbalBlendOGSN(items, result, player)
  print('starting MakeHerbalBlendOGSN')
  local fresh = true
  local rotten = false
  local dried_counter = 0
  local days_fresh = result:getOffAge()
  for i = 0, items:size() - 1 do
    print('in loop. i =')
    print(i)
    local item = items:get(i)
    local type = item:getType()
    if not type == "MortarPestle" then
    if not item:isFresh() then
      fresh = false
    end

    -- if one of them is dried then it won't be fresh. will only be dried if they all are, though. teabags are a special case.
    if type == "Teabag2" or type == "CommonMallowDried" or type == "LemonGrassDried" or type == "BlackSageDried" or type == "GinsengDried" or type == "RosehipsDried" or type == "GrapeLeavesDried" or type == "VioletsDried" or type == "PlantainDried" or type == "WildGarlicDried" then
      print('One of the ingredients is dried')
      dried_counter = dried_counter + 1
      if type ~= "Teabag2" then -- if it's a teabag it shouldn't count against the freshness
        fresh = false
      end
    end

    if item:isRotten() then
      rotten = true
      fresh = false
    end
    end
  end

  if not fresh then
      result:setAge(days_fresh+1) -- this seems to be the only way to make something stale
  end

  result:setRotten(rotten)  -- mark it rotten if appropriate
  if rotten then -- if it was rotten strip it of any positive effects
    result:setFluReduction(0)
    result:setReduceFoodSickness(0)
    result:setPainReduction(0)
    result:setEnduranceChange(0)
    result:setFatigueChange(0)
  elseif dried_counter == 3 then
    if result:getType() == "Teabag_Medicinal" then
        result:setType("Teabag_MedicinalDried")
    elseif result:getType() == "Teabag_Energizing" then
        result:setType("Teabag_EnergizingDried")
    end
  end
end
