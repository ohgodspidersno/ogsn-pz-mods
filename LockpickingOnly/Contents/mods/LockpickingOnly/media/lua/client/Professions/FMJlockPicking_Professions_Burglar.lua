require('NPCs/MainCreationMethods');

local BURGLAR_ID = 'burglar';

local function initProfessions()
    local burglar = ProfessionFactory.getProfession(BURGLAR_ID);
		burglar:getFreeRecipes():add("Lockpicking");
		burglar:getFreeRecipes():add("Create Hairpin");
		burglar:getFreeRecipes():add("Break Door Locks");
		burglar:getFreeRecipes():add("Break Window Locks");
    -- -- burglar:addFreeTrait("nimblefingers");
		-- burglar:setDescription(burglar:getDescription() .. " <LINE> " .. getText("UI_trait_nimblefingers"));
end

Events.OnGameBoot.Add(initProfessions);
