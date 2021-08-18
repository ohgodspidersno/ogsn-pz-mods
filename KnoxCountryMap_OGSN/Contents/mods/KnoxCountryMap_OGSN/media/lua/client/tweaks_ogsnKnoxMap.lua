require("ItemTweaker_Copy_ogsn");
if getActivatedMods():contains("Otr") then
    OGSNTweakItem("Base.KnoxCountryMap","Map","media/ui/LootableMaps/knox_country_map_OTR.png");
    OGSNTweakItem("Base.KnoxCountryMapSecret","Map","media/ui/LootableMaps/knox_country_map_secret_OTR.png");
else return end
