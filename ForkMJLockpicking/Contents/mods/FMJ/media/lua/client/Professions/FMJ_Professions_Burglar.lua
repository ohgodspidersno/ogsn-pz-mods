require('NPCs/MainCreationMethods');

local BURGLAR_ID = 'burglar';

local function initProfessions()
    local FMJburglar = ProfessionFactory.getProfession(BURGLAR_ID);

    local burglar = ProfessionFactory.addProfession(BURGLAR_ID, getText("UI_prof_Burglar"), "profession_burglar2", FMJburglar:getCost()-6);
    for k, v in pairs(transformIntoKahluaTable(FMJburglar:getXPBoostMap())) do
        burglar:addXPBoost(k, v);
    end
		burglar:setFreeTraitStack(FMJburglar:getFreeTraitStack());
		burglar:addFreeTrait("nimblefingers");
		burglar:getFreeRecipes():add("Lockpicking");
		burglar:getFreeRecipes():add("Create Bobby Pin");
		burglar:getFreeRecipes():add("Break Door locks");
		burglar:getFreeRecipes():add("Break Window locks");

		burglar:setDescription(FMJburglar:getDescription() .. " <LINE> " .. getText("UI_trait_nimblefingers"));
end

Events.OnGameBoot.Add(initProfessions);