-- Note: ISCraftAction:perform() in the vanilla code is a good reference
function MakeCupHerbalTeaOGSN(items, result, player)
  print('starting MakeCupHerbalTeaOGSN')
  local rotten = false
  -- local burnt = false
  local fresh = true
  local oldest = 0

  for i = 0, items:size() - 1 do
    print('in loop. i =')
    print(i)
    local item = items:get(i)
    local type = item:getStringItemType();
    if string_type == "Food" then
        if not item:isFresh() then
          fresh = false
        end
        if item:isRotten() then
          rotten = true
          fresh = false
        end
        -- if item:isBurnt() then
        --   burnt = true
        --   fresh = false
        -- end
        if item:getAge() > oldest then
          oldest = item:getAge()
        end
    end
  end
  -- pass on the burnt, rotten status, and oldest age to the result
  result:setRotten(rotten)
  -- result:setBurnt(burnt)
  result:setAge(oldest)
  -- if it was burnt or rotten strip it of any positive effects
  if rotten then -- OLD: if rotten or burnt then
    result:setFluReduction(0)
    result:setReduceFoodSickness(0)
    result:setPainReduction(0)
    result:setEnduranceChange(0)
    result:setFatigueChange(0)
  end
end

function CookRawHerbOGSN(herb)
  -- if it was rotten, just let it keep cooking like a normal piece of rotten food
  if herb:isRotten() then
    herb:setCooked(true)
  return end

  local driedType
  local oven = herb:getContainer();
  -- if it was not rotten, replace it with the dried version, already cooked
  if herb:getType() == "CommonMallow" then driedType = "Base.CommonMallowDried"
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

  local driedHerb = InventoryItemFactory.CreateItem(driedType);
  driedHerb:setCooked(true)
  -- oven:getItems():removeItem(herb)
  -- oven:removeItem(herb)
  oven:Remove(herb)
  oven:AddItem(driedHerb)
end

function MakeHerbalBlendOGSN(items, result, player)
  print('starting MakeHerbalBlendOGSN')
  local fresh = true
  local rotten = false
  -- local burnt = false
  local oldest = 0
  local days_fresh = result:getOffAge()
  local days_rotten = result:getOffAgeMax()
  for i = 0, items:size() - 1 do
    print('in loop. i =')
    print(i)
    local item = items:get(i)
    local string_type = item:getStringItemType();
    local type = item:getType()
    if string_type == "Food" then
        if not item:isFresh() then
          fresh = false
        end

        if type == "CommonMallowDried" or type == "LemonGrassDried" or type == "BlackSageDried" or type == "GinsengDried" or type == "RosehipsDried" or type == "GrapeLeavesDried" or type == "VioletsDried" or type == "PlantainDried" or type == "WildGarlicDried" then
          print('One of the ingredients is dried')
          fresh = false
        end

        if item:isRotten() then
          rotten = true
          fresh = false
        end
        -- if item:isBurnt() then
        --   burnt = true
        --   fresh = false
        -- end
        if item:getAge() > oldest and type ~= "Teabag2" then -- not sure if teabag2 has an age but I don't want it to mess it up if it does
          oldest = item:getAge()
          print('age of oldest ingredient:')
          print(oldest)
        end
    end
  end
  -- pass on the fresh, burnt, rotten status, and oldest age to the result
  -- freshness is only determined recursively by item's age
  result:setCooked(true)
  if not fresh then
      if oldest > days_fresh then -- if one of the ingredients was very old, then we make it that old
        result:setAge(oldest)
      else
        result:setAge(days_fresh+1) -- otherwise make it just a little stale
      end
  else
      result:setAge(oldest) -- if it is fresh just set it to the age
  end
  result:setRotten(rotten)  -- first mark it rotten if appropriate
  if rotten and days_rotten > oldest then -- if it's rotten but somehow its age is still 'stale'or 'fresh'
      result:setAge(days_rotten) -- 'then just set its age to be a little rotten
  end
  -- result:setBurnt(burnt)

  -- if it was burnt or rotten strip it of any positive effects
  if rotten then -- OLD: if rotten or burnt then
    result:setFluReduction(0)
    result:setReduceFoodSickness(0)
    result:setPainReduction(0)
    result:setEnduranceChange(0)
    result:setFatigueChange(0)
  end
end
