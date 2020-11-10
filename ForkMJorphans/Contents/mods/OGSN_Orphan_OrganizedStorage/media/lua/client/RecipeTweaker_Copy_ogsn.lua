
if not RecipeTweaker then  RecipeTweaker = {} end
if not TweakRecipe then  TweakRecipe = {} end
if not TweakRecipeData then  TweakRecipeData = {} end

--Prep code to make the changes to all item in the TweakRecipeData table.
function RecipeTweaker.tweakRecipes()
	local recipe;
	for k,v in pairs(TweakRecipeData) do
		for t,y in pairs(v) do
			recipe = ScriptManager.instance:getRecipe(k);
			if recipe ~= nil then
				recipe:DoParam(t.." = "..y);
				print(k..": "..t..", "..y);
			end
		end
	end
end

function TweakRecipe(recipeName, recipeProperty, propertyValue)
	if not TweakRecipeData[recipeName] then
		TweakRecipeData[recipeName] = {};
	end
	TweakRecipeData[recipeName][recipeProperty] = propertyValue;
end

Events.OnGameBoot.Add(RecipeTweaker.tweakRecipes)
