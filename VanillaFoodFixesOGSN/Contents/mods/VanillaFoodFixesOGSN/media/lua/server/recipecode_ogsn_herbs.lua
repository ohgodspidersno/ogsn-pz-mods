-- Note: ISCraftAction:perform() in the vanilla code is a good reference


function MakeCupHerbalTeaOGSN(items, result, player)
  print('Stack trace (not really)')
  print("items")
  print(items)
  print("result")
  print(result)
  local rotten = false
  local burnt = false
  local oldest = 0
  -- determine if any ingredients were rotten or burnt, and the age of the oldest ingredient
  for i = 0, items:size() - 1 do
    local ingredient = items:get(i)
    print("ingredient")
    print(ingredient)
    print(print(ingredient:isRotten())
    print(print(ingredient:isBurnt())
    print(print(ingredient:getAge())
    if ingredient:isRotten() then
      rotten = true
    end
    if ingredient:isBurnt() then
      burnt = true
    end
    if ingredient:getAge() > oldest then
      oldest = ingredient:getAge()
    end
    -- pass on the burnt, rotten status, and oldest age to the result
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
    print("result")
    print(result)
    print(result:getRotten())
    print(result:getBurnt())
    print(result:getAge())
    print(result:getFluReduction())
    print(result:getReduceFoodSickness())
    print(result:getPainReduction())
    print(result:getEnduranceChange())
    print(result:getFatigueChange())
  end
end

function CookRawHerbOGSN(herb)
  print('Stack trace (not really)')
  print(herb)
  print(herb:getType())
  -- if it was rotten, just let it keep cooking like a normal piece of rotten food
  if herb:isRotten() then return end
  -- if it was not rotten, replace it with the dried version, already cooked
  herb:setCooked(true)
  if herb:getType() == CommonMallow then
    result:setType(CommonMallowDried)
  elseif herb:getType() == LemonGrass then
    result:setType(LemonGrassDried)
  elseif herb:getType() == BlackSage then
    result:setType(BlackSageDried)
  elseif herb:getType() == Ginseng then
    result:setType(GinsengDried)
  elseif herb:getType() == Rosehips then
    result:setType(RosehipsDried)
  elseif herb:getType() == GrapeLeaves then
    result:setType(GrapeLeavesDried)
  elseif herb:getType() == Violets then
    result:setType(VioletsDried)
  end
  print("result")
  print(result)
  print(result:getType())
end

function MakeHerbalBlendOGSN(items, result, player)
  print('Stack trace (not really)')
  print("items")
  print(items)
  print("result")
  print(result)
  local fresh = true
  local rotten = false
  local burnt = false
  local oldest = 0
  for i = 0, items:size() - 1 do
    local ingredient = items:get(i)
    if not ingredient:isFresh() then
      fresh = false
    end
    if ingredient:isRotten() then
      rotten = true
      fresh = false
    end
    if ingredient:isBurnt() then
      burnt = true
      fresh = false
    end
    if ingredient:getAge() > oldest then
      oldest = ingredient:getAge()
    end
    -- pass on the fresh, burnt, rotten status, and oldest age to the result
    if fresh then
      result:setFresh(true)
    else
      result:setRotten(rotten)
      result:setBurnt(burnt)
    end
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
  print("result")
  print(result)
  print(result:getFluReduction())
  print(result:getReduceFoodSickness())
  print(result:getPainReduction())
  print(result:getEnduranceChange())
  print(result:getFatigueChange())
end
