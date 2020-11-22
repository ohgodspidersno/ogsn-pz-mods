Recipe = Recipe or {}
Recipe.GetItemTypes = Recipe.GetItemTypes or {}
Recipe.OnCreate = Recipe.OnCreate or {}
Recipe.OnGiveXP = Recipe.OnGiveXP or {}
Recipe.OnTest = Recipe.OnTest or {}

function Recipe.OnGiveXP.Cooking5(recipe, ingredients, result, player)
    player:getXp():AddXP(Perks.Cooking, 5);
end
