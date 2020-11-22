Recipe = Recipe or {}
Recipe.GetItemTypes = Recipe.GetItemTypes or {}
Recipe.OnCreate = Recipe.OnCreate or {}
Recipe.OnGiveXP = Recipe.OnGiveXP or {}
Recipe.OnTest = Recipe.OnTest or {}

function Recipe.OnGiveXP.Cooking3(recipe, ingredients, result, player)
    player:getXp():AddXP(Perks.Cooking, 3);
end

function Recipe.OnGiveXP.Cooking10(recipe, ingredients, result, player)
    player:getXp():AddXP(Perks.Cooking, 10);
end
