-- Note: ISCraftAction:perform() in the vanilla code is a good reference


-- MakeCupHerbalTeaOGSN
-- pass on the burned, rotten status of the herb/blend
-- if it was burned or rotten strip it of any positive effects
--
--
-- CookRawHerbOGSN
function MakeCupHerbalTeaOGSN(items, result, player)
-- pass on the burnt, rotten status of the herb/blend
-- if it was burnt or rotten strip it of any positive effects
  local rotten = false
  local burnt = false
  local oldest = 0
  for i=0, items:size() -1 do
    local ingredient = items:get(i)
    if ingredient:isRotten() then
      rotten = true
    end
    if ingredient:isBurnt() then
      burnt = true
    end
    if ingredient:getAge() > oldest then
      oldest = ingredient:getAge()
    end
    result:setRotten(rotten)
    result:setBurnt(burnt)
    result:setAge(oldest)
    if rotten or burnt then
      result:setFluReduction(0)
      result:setReduceFoodSickness(0)
      result:setPainReduction(0)
      result:setEnduranceChange(0)
      result:setFatigueChange(0)
    end
  end
end
-- if it was rotten, just let it keep cooking like a normal piece of rotten food
-- if it was not rotten, replace it with the dried version
--
-- MakeHerbalBlendOGSN
-- if any of the ingredients were rotten and/or burned, make it rotten and/or burned
-- if all of the ingredients were fresh, make it fresh
