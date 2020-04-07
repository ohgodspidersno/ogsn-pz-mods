-- Give the sauce pan back
function FMJReturnSaucePan_OnCreate(items, result, player)
	player:getInventory():AddItem("Base.Saucepan");
end

-- Return true if recipe is valid, false otherwise
function FMJIsCooked_TestIsValid(sourceItem, result)
	if sourceItem:getType() == "CheesePrep" or sourceItem:getType() == "YogurtPrep" then
		if sourceItem:isBurnt()==true or sourceItem:IsRotten()==true then
			return false
		else
			return sourceItem:isCooked()
		end
	end
	return true
end