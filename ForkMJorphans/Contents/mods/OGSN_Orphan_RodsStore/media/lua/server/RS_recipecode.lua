

function OnEat_Gum(food, character)
        character:getStats():setStress(character:getStats():getStress() - 10);
        if character:getStats():getStress() then
            character:getStats():setStress(0);
        end
        character:getBodyDamage():setFoodSicknessLevel(character:getBodyDamage():getFoodSicknessLevel() + 5);
        if character:getBodyDamage():getFoodSicknessLevel() > 100 then
            character:getBodyDamage():setFoodSicknessLevel(100);
        end
end