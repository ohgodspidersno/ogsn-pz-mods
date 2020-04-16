-- Note: ISCraftAction:perform() in the vanilla code is a good reference
function MakeCupHerbalTeaOGSN(items, result, player)
  local rotten = false
  local burnt = false
  local fresh = true
  local oldest = 0

  for i = 0, items:size() - 1 do
    local item = items:get(i)
    local type = item:getStringItemType();
    if type ~= "Food" then
      break
    end
    if not item:isFresh() then
      fresh = false
    end
    if item:isRotten() then
      rotten = true
      fresh = false
    end
    if item:isBurnt() then
      burnt = true
      fresh = false
    end
    if item:getAge() > oldest then
      oldest = ingredient:getAge()
    end
    -- pass on the burnt, rotten status, and oldest age to the result
    result:setFresh(fresh)
    result:setRotten(rotten)
    result:setBurnt(burnt)
    result:setAge(oldest)
    -- if it was burnt or rotten strip it of any positive effects
    if rotten or burnt then
      result:setFluReduction(0)
      result:setReduceFoodSickness(0)
      result:setPainReduction(0)
      result:setEnduranceChange(0)
      result:setFatigueChange(0)
    end
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
  end

  local driedHerb = InventoryItemFactory.CreateItem(driedType);
  driedHerb:setCooked(true)
  -- oven:getItems():removeItem(herb)
  -- oven:removeItem(herb)
  oven:Remove(herb)
  oven:AddItem(driedHerb)
end

function MakeHerbalBlendOGSN(items, result, player)
  local freshness = true
  local rotten = false
  local burnt = false
  local oldest = 0
  for i = 0, items:size() - 1 do
    local item = items:get(i)
    local type = item:getStringItemType();
    if type ~= "Food" then
      break
    end
    -- local ingredient = item
    if not item:isFresh() then
      freshness = false
    end
    if item:isRotten() then
      rotten = true
      freshness = false
    end
    if item:isBurnt() then
      burnt = true
      freshness = false
    end
    if ingredient:getAge() > oldest then
      oldest = ingredient:getAge()
      print('age of oldest ingredient:')
      print(oldest)
    end
    -- pass on the freshness, burnt, rotten status, and oldest age to the result
    result:setCooked(true)
    result:setFresh(freshness)
    result:setRotten(rotten)
    result:setBurnt(burnt)
    result:setAge(oldest)
    -- if it was burnt or rotten strip it of any positive effects
    if rotten or burnt then
      result:setFluReduction(0)
      result:setReduceFoodSickness(0)
      result:setPainReduction(0)
      result:setEnduranceChange(0)
      result:setFatigueChange(0)
    end
  end
end
