require('NPCs/MainCreationMethods');

local PARKRANGER_ID = 'parkranger';

local function initProfessions()
	local FMJparkranger = ProfessionFactory.getProfession(PARKRANGER_ID);

	local parkranger = ProfessionFactory.addProfession(PARKRANGER_ID, getText("UI_prof_parkranger"), "profession_parkranger2", FMJparkranger:getCost()-4);
    for k, v in pairs(transformIntoKahluaTable(FMJparkranger:getXPBoostMap())) do
        parkranger:addXPBoost(k, v);
    end
		parkranger:setFreeTraitStack(FMJparkranger:getFreeTraitStack());
		parkranger:getFreeRecipes():add("Make Stick Trap");
		parkranger:getFreeRecipes():add("Make Snare Trap");
		parkranger:getFreeRecipes():add("Make Wooden Cage Trap");
		parkranger:getFreeRecipes():add("Make Trap Box");
		parkranger:getFreeRecipes():add("Make Cage Trap");
		parkranger:getFreeRecipes():add("Make Mouse Trap");
		
		parkranger:setDescription(FMJparkranger:getDescription());
end

Events.OnGameBoot.Add(initProfessions);