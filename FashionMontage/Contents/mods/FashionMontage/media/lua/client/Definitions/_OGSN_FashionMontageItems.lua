-- Lists of all vanilla items --

-- NOTE TO MODDERS: Do NOT overwrite this file.
-- If you want to add new clothing, create a new .lua file using the
-- template I have created in media/lua/client/Definitions/items_ExampleModName.lua

local clothingLists = {
      listHat = {
        "DistinctNames.Hat_Bandana",
        "DistinctNames.Hat_BandanaTied",
        "DistinctNames.Hat_BandanaTINT",
        "DistinctNames.Hat_BandanaTiedTINT",
        "DistinctNames.Hat_BaseballCap",
        "DistinctNames.Hat_BaseballCap_Reverse",
        "DistinctNames.Hat_BaseballCapBlue",
        "DistinctNames.Hat_BaseballCapBlue_Reverse",
        "DistinctNames.Hat_BaseballCapRed",
        "DistinctNames.Hat_BaseballCapRed_Reverse",
        "DistinctNames.Hat_BaseballCapGreen",
        "DistinctNames.Hat_BaseballCapGreen_Reverse",
        "DistinctNames.Hat_BaseballCapKY",
        "DistinctNames.Hat_BaseballCapKY_Reverse",
        "DistinctNames.Hat_BaseballCapKY_Red",
        "DistinctNames.Hat_Beany",
        "DistinctNames.Hat_Beret",
        "DistinctNames.Hat_BeretArmy",
        "DistinctNames.Hat_BonnieHat_CamoGreen",
        "DistinctNames.Hat_BonnieHat",
        "DistinctNames.Hat_ChefHat",
        "DistinctNames.Hat_Cowboy",
        "DistinctNames.Hat_EarMuffs",
        "DistinctNames.Hat_EarMuff_Protectors",
        "DistinctNames.Hat_Fedora",
        "DistinctNames.Hat_Fedora_Delmonte",
        "DistinctNames.Hat_Ranger",
        "DistinctNames.Hat_Police_Grey",
        "DistinctNames.Hat_Police",
        "DistinctNames.Hat_GolfHatTINT",
        "DistinctNames.Hat_GolfHat",
        "DistinctNames.Hat_HardHat",
        "DistinctNames.Hat_HardHat_Miner",
        "DistinctNames.Hat_Army",
        "DistinctNames.Hat_BaseballHelmet_KY",
        "DistinctNames.Hat_BaseballHelmet_Rangers",
        "DistinctNames.Hat_BaseballHelmet_Z",
        "DistinctNames.Hat_BicycleHelmet",
        "DistinctNames.Hat_CrashHelmet",
        "DistinctNames.Hat_CrashHelmet_Police",
        "DistinctNames.Hat_CrashHelmet_Stars",
        "DistinctNames.Hat_Fireman",
        "DistinctNames.Hat_HockeyHelmet",
        "DistinctNames.Hat_JockeyHelmet01",
        "DistinctNames.Hat_JockeyHelmet02",
        "DistinctNames.Hat_JockeyHelmet03",
        "DistinctNames.Hat_JockeyHelmet04",
        "DistinctNames.Hat_JockeyHelmet05",
        "DistinctNames.Hat_JockeyHelmet06",
        "DistinctNames.Hat_RidingHelmet",
        "DistinctNames.Hat_PeakedCapArmy",
        "DistinctNames.Hat_Raccoon",
        "DistinctNames.Hat_FastFood",
        "DistinctNames.Hat_FastFood_IceCream",
        "DistinctNames.Hat_FastFood_Spiffo",
        "DistinctNames.Hat_SantaHat",
        "DistinctNames.Hat_SantaHatGreen",
        "DistinctNames.Hat_ShowerCap",
        "DistinctNames.Hat_SummerHat",
        "DistinctNames.Hat_SurgicalCap_Blue",
        "DistinctNames.Hat_SurgicalCap_Green",
        "DistinctNames.Hat_Sweatband",
        "DistinctNames.Hat_WeddingVeil",
        "DistinctNames.Hat_WinterHat",
        "DistinctNames.Hat_WoolyHat",
        "DistinctNames.Hat_Visor_WhiteTINT",
        "DistinctNames.Hat_VisorBlack",
        "DistinctNames.Hat_VisorRed",
      },
      listTankTop = {
        "DistinctNames.Vest_DefaultTEXTURE_TINT",
      },
      listTshirt = {
        -- "DistinctNames.Tshirt_DefaultTEXTURE",
        "DistinctNames.Tshirt_DefaultTEXTURE_TINT",
        "DistinctNames.Tshirt_WhiteTINT",
        -- "DistinctNames.Tshirt_WhiteLongSleeve",
        "DistinctNames.Tshirt_WhiteLongSleeveTINT",
        "DistinctNames.Tshirt_PoloStripedTINT",
        "DistinctNames.Tshirt_PoloTINT",
        -- "DistinctNames.Tshirt_DefaultDECAL",
        "DistinctNames.Tshirt_DefaultDECAL_TINT",
        -- "DistinctNames.Tshirt_SportDECAL",
        "DistinctNames.Tshirt_Rock",
        "DistinctNames.Tshirt_Sport",
        "DistinctNames.Tshirt_ArmyGreen",
        "DistinctNames.Tshirt_CamoDesert",
        "DistinctNames.Tshirt_CamoGreen",
        "DistinctNames.Tshirt_CamoUrban",
        "DistinctNames.Tshirt_Fossoil",
        "DistinctNames.Tshirt_Gas2Go",
        "DistinctNames.Tshirt_McCoys",
        "DistinctNames.Tshirt_PileOCrepe",
        "DistinctNames.Tshirt_PizzaWhirled",
        "DistinctNames.Tshirt_BusinessSpiffo",
        "DistinctNames.Tshirt_SpiffoDECAL",
        "DistinctNames.Tshirt_ThunderGas",
        "DistinctNames.Tshirt_ValleyStation",
        "DistinctNames.Tshirt_IndieStoneDECAL",
        "DistinctNames.Tshirt_Profession_FiremanBlue",
        "DistinctNames.Tshirt_Profession_FiremanRed02",
        "DistinctNames.Tshirt_Profession_FiremanRed",
        "DistinctNames.Tshirt_Profession_FiremanWhite",
        "DistinctNames.Tshirt_Scrubs",
        "DistinctNames.Tshirt_Ranger",
        "DistinctNames.Tshirt_Profession_RangerBrown",
        "DistinctNames.Tshirt_Profession_RangerGreen",
        "DistinctNames.Tshirt_Profession_PoliceBlue",
        "DistinctNames.Tshirt_Profession_PoliceWhite",
        "DistinctNames.Tshirt_PoliceGrey",
        "DistinctNames.Tshirt_PoliceBlue",
        "DistinctNames.Tshirt_Profession_VeterenGreen",
        "DistinctNames.Tshirt_Profession_VeterenRed",
      },
      listShirt = {
        "DistinctNames.Shirt_FormalWhite",
        "DistinctNames.Shirt_Denim",
        "DistinctNames.Shirt_FormalWhite_ShortSleeve",
        "DistinctNames.Shirt_CamoDesert",
        "DistinctNames.Shirt_CamoGreen",
        "DistinctNames.Shirt_CamoUrban",
        "DistinctNames.Shirt_Baseball_KY",
        "DistinctNames.Shirt_Baseball_Rangers",
        "DistinctNames.Shirt_Baseball_Z",
        "DistinctNames.Shirt_HawaiianTINT",
        "DistinctNames.Shirt_HawaiianRed",
        "DistinctNames.Shirt_Jockey01",
        "DistinctNames.Shirt_Jockey02",
        "DistinctNames.Shirt_Jockey03",
        "DistinctNames.Shirt_Jockey04",
        "DistinctNames.Shirt_Jockey05",
        "DistinctNames.Shirt_Jockey06",
        "DistinctNames.Shirt_Lumberjack",
        "DistinctNames.Shirt_Scrubs",
        "DistinctNames.Shirt_Ranger",
        "DistinctNames.Shirt_OfficerWhite",
        "DistinctNames.Shirt_PoliceBlue",
        "DistinctNames.Shirt_PoliceGrey",
        "DistinctNames.Shirt_PrisonGuard",
        "DistinctNames.Shirt_Priest",
        "DistinctNames.Shirt_Workman",
      },
      listSocks = {
        "DistinctNames.Socks_Ankle",
        "DistinctNames.Socks_Long",
      },
      listPants = {
        "DistinctNames.Shorts_CamoGreenLong",
        "DistinctNames.Shorts_LongDenim",
        "DistinctNames.Shorts_LongSport",
        "DistinctNames.Shorts_LongSport_Red",
        "DistinctNames.Shorts_ShortDenim",
        "DistinctNames.Shorts_ShortFormal",
        "DistinctNames.Shorts_ShortSport",
        "DistinctNames.Ghillie_Trousers",
        -- "DistinctNames.Trousers",
        "DistinctNames.TrousersMesh_DenimLight",
        "DistinctNames.Trousers_CamoDesert",
        "DistinctNames.Trousers_CamoGreen",
        "DistinctNames.Trousers_CamoUrban",
        "DistinctNames.Trousers_Chef",
        -- "DistinctNames.Trousers_DefaultTEXTURE",
        -- "DistinctNames.Trousers_DefaultTEXTURE_HUE",
        "DistinctNames.Trousers_DefaultTEXTURE_TINT",
        "DistinctNames.Trousers_Denim",
        "DistinctNames.Trousers_Fireman",
        "DistinctNames.Trousers_JeanBaggy",
        "DistinctNames.Trousers_Padded",
        "DistinctNames.Trousers_Police",
        "DistinctNames.Trousers_PoliceGrey",
        "DistinctNames.Trousers_PrisonGuard",
        "DistinctNames.Trousers_Ranger",
        "DistinctNames.Trousers_Santa",
        "DistinctNames.Trousers_SantaGReen",
        "DistinctNames.Trousers_Scrubs",
        "DistinctNames.Trousers_Suit",
        -- "DistinctNames.Trousers_SuitTEXTURE",
        "DistinctNames.Trousers_SuitWhite",
        -- "DistinctNames.Trousers_WhiteTEXTURE",
        -- "DistinctNames.Trousers_WhiteTINT",
        "DistinctNames.Dungarees",
        "DistinctNames.Trousers_ArmyService",
        "DistinctNames.Trousers_Black",
        "DistinctNames.Trousers_NavyBlue",
      },
      listSkirt = {
        "DistinctNames.Skirt_Long",
        "DistinctNames.Skirt_Normal",
        "DistinctNames.Skirt_Knees",
        "DistinctNames.Skirt_Short",
      },
      listDress = {
        "DistinctNames.Dress_Long",
        "DistinctNames.Dress_Normal",
        "DistinctNames.Dress_Knees",
        "DistinctNames.Dress_Short",
        "DistinctNames.HospitalGown",
      },
      listShoes = {
        -- "DistinctNames.Shoes_Black",
        -- "DistinctNames.Shoes_Brown",
        "DistinctNames.Shoes_Random",
        -- "DistinctNames.Shoes_RedTrainers",
        -- "DistinctNames.Shoes_BlueTrainers",
        "DistinctNames.Shoes_TrainerTINT",
        "DistinctNames.Shoes_BlackBoots",
        "DistinctNames.Shoes_ArmyBoots",
        "DistinctNames.Shoes_ArmyBootsDesert",
        "DistinctNames.Shoes_Wellies",
        "DistinctNames.Shoes_RidingBoots",
        "DistinctNames.Shoes_Slippers",
      },
      listEyes = {
        "DistinctNames.Glasses_Normal",
        "DistinctNames.Glasses_Reading",
        "DistinctNames.Glasses_SafetyGoggles",
        "DistinctNames.Glasses_Shooting",
        "DistinctNames.Glasses_SkiGoggles",
        "DistinctNames.Glasses_SwimmingGoggles",
        "DistinctNames.Glasses_Sun",
        "DistinctNames.Glasses_Aviators",
        "DistinctNames.Glasses",
      },
      listBeltExtra = {
        "DistinctNames.HolsterSimple",
        "DistinctNames.HolsterDouble",
      },
      listMask = {
        "DistinctNames.Hat_BalaclavaFull",
        "DistinctNames.Hat_BalaclavaFace",
        "DistinctNames.Hat_BandanaMask",
        "DistinctNames.Hat_BandanaMaskTINT",
        "DistinctNames.Hat_DustMask",
        "DistinctNames.Hat_SurgicalMask_Blue",
        "DistinctNames.Hat_SurgicalMask_Green",
      },
      listMaskEyes = {
        "DistinctNames.Hat_GasMask",
        "DistinctNames.WeldingMask",
      },
      listUnderwear = {
        "DistinctNames.Bikini_TINT",
        "DistinctNames.Bikini_Pattern01",
        "DistinctNames.SwimTrunks_Blue",
        "DistinctNames.SwimTrunks_Green",
        "DistinctNames.SwimTrunks_Red",
        "DistinctNames.SwimTrunks_Yellow",
        "DistinctNames.Swimsuit_TINT",
      },
      listFullHat = {
        "DistinctNames.Hat_SPHhelmet",
        "DistinctNames.Hat_FootballHelmet",
        "DistinctNames.Hat_CrashHelmetFULL",
        "DistinctNames.Hat_RiotHelmet",
        "DistinctNames.Hat_NBCmask",
        "DistinctNames.Hat_Spiffo",
      },
      listTorso1Legs1 = {
        "DistinctNames.LongJohns",
      },
      listNeck = {
        "DistinctNames.Tie_Full",
        "DistinctNames.Tie_Worn",
        "DistinctNames.Tie_BowTieFull",
        "DistinctNames.Tie_BowTieWorn",
        "DistinctNames.Tie_Full_Spiffo",
        "DistinctNames.Tie_Worn_Spiffo",
      },
      listHands = {
        "DistinctNames.Gloves_FingerlessGloves",
        "DistinctNames.Gloves_LeatherGloves",
        "DistinctNames.Gloves_LeatherGlovesBlack",
        "DistinctNames.Gloves_LongWomenGloves",
        "DistinctNames.Gloves_WhiteTINT",
      },
      listLegs1 = {
        "DistinctNames.LongJohns_Bottoms"
      },
      listSweater = {
        "DistinctNames.Jumper_DiamondPatternTINT",
        "DistinctNames.Jumper_TankTopDiamondTINT",
        "DistinctNames.HoodieDOWN_WhiteTINT",
        "DistinctNames.Jumper_PoloNeck",
        "DistinctNames.Jumper_RoundNeck",
        "DistinctNames.Jumper_VNeck",
        "DistinctNames.Jumper_TankTopTINT",
      },
      listSweaterHat = {
        "DistinctNames.HoodieUP_WhiteTINT",
      },
      listJacket = {
        "DistinctNames.Jacket_WhiteTINT",
        "DistinctNames.Jacket_Black",
        "DistinctNames.JacketLong_Random",
        "DistinctNames.Jacket_Chef",
        "DistinctNames.Jacket_Fireman",
        "DistinctNames.JacketLong_Doctor",
        "DistinctNames.Jacket_ArmyCamoDesert",
        "DistinctNames.Jacket_ArmyCamoGreen",
        "DistinctNames.Jacket_CoatArmy",
        "DistinctNames.Jacket_NavyBlue",
        "DistinctNames.Jacket_PaddedDOWN",
        "DistinctNames.Jacket_Ranger",
        "DistinctNames.Jacket_Police",
        "DistinctNames.PonchoGreenDOWN",
        "DistinctNames.PonchoYellowDOWN",
        "DistinctNames.JacketLong_Santa",
        "DistinctNames.JacketLong_SantaGreen",
        "DistinctNames.Suit_Jacket",
        "DistinctNames.WeddingJacket",
        "DistinctNames.Jacket_Varsity",
      },
      listJacketHat = {
        "DistinctNames.Jacket_Padded",
        "DistinctNames.PonchoGreen",
        "DistinctNames.PonchoYellow",
      },
      listFullSuit = {
        "DistinctNames.Boilersuit",
        "DistinctNames.Boilersuit_BlueRed",
        "DistinctNames.Boilersuit_Flying",
        "DistinctNames.Boilersuit_PrisonerKhaki",
        "DistinctNames.Boilersuit_Prisoner",
        "DistinctNames.SpiffoSuit",
        "DistinctNames.WeddingDress",
      },
      listFullSuitHead = {
        "DistinctNames.HazmatSuit",
      },
      listFullTop = {
        "DistinctNames.Ghillie_Top",
      },
      listBathRobe = {
        "DistinctNames.LongCoat_Bathrobe",
      },
      listTorsoExtra = {
        "DistinctNames.Apron_Black",
        "DistinctNames.Apron_White",
        "DistinctNames.Apron_WhiteTEXTURE",
        "DistinctNames.Apron_IceCream",
        "DistinctNames.Apron_PileOCrepe",
        "DistinctNames.Apron_PizzaWhirled",
        "DistinctNames.Apron_Spiffos",
        "DistinctNames.Vest_BulletCivilian",
        "DistinctNames.Vest_BulletPolice",
        "DistinctNames.Vest_BulletArmy",
        "DistinctNames.Vest_Waistcoat",
        "DistinctNames.Vest_Waistcoat_GigaMart",
        "DistinctNames.Vest_Foreman",
        "DistinctNames.Vest_HighViz",
        "DistinctNames.Vest_Hunting_Grey",
        "DistinctNames.Vest_Hunting_Orange",
        "DistinctNames.Vest_Hunting_Camo",
        "DistinctNames.Vest_Hunting_CamoGreen",
      },
      listTail = {
        "DistinctNames.SpiffoTail",
      },
      listBack = {
        "Base.Bag_ALICEpack_Army",
        "Base.Bag_ALICEpack",
        "Base.Bag_BigHikingBag",
        "Base.Bag_NormalHikingBag",
        "Base.Bag_DuffelBagTINT",
        "Base.Bag_Schoolbag",
      },
      listScarf = {
        "DistinctNames.Scarf_White",
        "DistinctNames.Scarf_StripeBlackWhite",
        "DistinctNames.Scarf_StripeBlueWhite",
        "DistinctNames.Scarf_StripeRedWhite",
      },
}


-- local function addClothing(clothingLists)

    local function merge_Old_New(old,new)
      for k,v in pairs(new) do old[k] = v end;
    end

    local maleTable = ClothingSelectionDefinitions.default.Male
    local femaleTable = ClothingSelectionDefinitions.default.Female

    if clothingLists.listHat then
      maleTable.Hat.chance = 20;
      femaleTable.Hat.chance = 20;
      local maleItems = maleTable.Hat.items;
      local femaleItems = femaleTable.Hat.items;
      merge_Old_New(maleItems,clothingLists.listHat);
      merge_Old_New(femaleItems,clothingLists.listHat);
    end
    if clothingLists.listTankTop then
      maleTable.TankTop.chance = 20;
      femaleTable.TankTop.chance = 20;
      local maleItems = maleTable.TankTop.items;
      local femaleItems = femaleTable.TankTop.items;
      merge_Old_New(maleItems,clothingLists.listTankTop);
      merge_Old_New(femaleItems,clothingLists.listTankTop);
    end
    if clothingLists.listTshirt then
      maleTable.Tshirt.chance = 20;
      femaleTable.Tshirt.chance = 20;
      local maleItems = maleTable.Tshirt.items;
      local femaleItems = femaleTable.Tshirt.items;
      merge_Old_New(maleItems,clothingLists.listTshirt);
      merge_Old_New(femaleItems,clothingLists.listTshirt);
    end
    if clothingLists.listShirt then
      maleTable.Shirt.chance = 20;
      femaleTable.Shirt.chance = 20;
      local maleItems = maleTable.Shirt.items;
      local femaleItems = femaleTable.Shirt.items;
      merge_Old_New(maleItems,clothingLists.listShirt);
      merge_Old_New(femaleItems,clothingLists.listShirt);
    end
    if clothingLists.listSocks then
      maleTable.Socks.chance = 20;
      femaleTable.Socks.chance = 20;
      local maleItems = maleTable.Socks.items;
      local femaleItems = femaleTable.Socks.items;
      merge_Old_New(maleItems,clothingLists.listSocks);
      merge_Old_New(femaleItems,clothingLists.listSocks);
    end
    if clothingLists.listPants then
      maleTable.Pants.chance = 20;
      femaleTable.Pants.chance = 20;
      local maleItems = maleTable.Pants.items;
      local femaleItems = femaleTable.Pants.items;
      merge_Old_New(maleItems,clothingLists.listPants);
      merge_Old_New(femaleItems,clothingLists.listPants);
    end
    if clothingLists.listSkirt then
      maleTable.Skirt.chance = 0;
      femaleTable.Skirt.chance = 20;
      local maleItems = maleTable.Skirt.items;
      local femaleItems = femaleTable.Skirt.items;
      merge_Old_New(maleItems,clothingLists.listSkirt);
      merge_Old_New(femaleItems,clothingLists.listSkirt);
    end
    if clothingLists.listDress then
      maleTable.Dress.chance = 0;
      femaleTable.Dress.chance = 20;
      local maleItems = maleTable.Dress.items;
      local femaleItems = femaleTable.Dress.items;
      merge_Old_New(maleItems,clothingLists.listDress);
      merge_Old_New(femaleItems,clothingLists.listDress);
    end
    if clothingLists.listShoes then
      maleTable.Shoes.chance = 20;
      femaleTable.Shoes.chance = 20;
      local maleItems = maleTable.Shoes.items;
      local femaleItems = femaleTable.Shoes.items;
      merge_Old_New(maleItems,clothingLists.listShoes);
      merge_Old_New(femaleItems,clothingLists.listShoes);
    end
    if clothingLists.listEyes then
      maleTable.Eyes.chance = 20;
      femaleTable.Eyes.chance = 20;
      local maleItems = maleTable.Eyes.items;
      local femaleItems = femaleTable.Eyes.items;
      merge_Old_New(maleItems,clothingLists.listEyes);
      merge_Old_New(femaleItems,clothingLists.listEyes);
    end
    if clothingLists.listBeltExtra then
      maleTable.BeltExtra.chance = 20;
      femaleTable.BeltExtra.chance = 20;
      local maleItems = maleTable.BeltExtra.items;
      local femaleItems = femaleTable.BeltExtra.items;
      merge_Old_New(maleItems,clothingLists.listBeltExtra);
      merge_Old_New(femaleItems,clothingLists.listBeltExtra);
    end
    if clothingLists.listMask then
      maleTable.Mask.chance = 20;
      femaleTable.Mask.chance = 20;
      local maleItems = maleTable.Mask.items;
      local femaleItems = femaleTable.Mask.items;
      merge_Old_New(maleItems,clothingLists.listMask);
      merge_Old_New(femaleItems,clothingLists.listMask);
    end
    if clothingLists.listMaskEyes then
      maleTable.MaskEyes.chance = 20;
      femaleTable.MaskEyes.chance = 20;
      local maleItems = maleTable.MaskEyes.items;
      local femaleItems = femaleTable.MaskEyes.items;
      merge_Old_New(maleItems,clothingLists.listMaskEyes);
      merge_Old_New(femaleItems,clothingLists.listMaskEyes);
    end
    if clothingLists.listUnderwear then
      maleTable.Underwear.chance = 20;
      femaleTable.Underwear.chance = 20;
      local maleItems = maleTable.Underwear.items;
      local femaleItems = femaleTable.Underwear.items;
      merge_Old_New(maleItems,clothingLists.listUnderwear);
      merge_Old_New(femaleItems,clothingLists.listUnderwear);
    end
    if clothingLists.listFullHat then
      maleTable.FullHat.chance = 20;
      femaleTable.FullHat.chance = 20;
      local maleItems = maleTable.FullHat.items;
      local femaleItems = femaleTable.FullHat.items;
      merge_Old_New(maleItems,clothingLists.listFullHat);
      merge_Old_New(femaleItems,clothingLists.listFullHat);
    end
    if clothingLists.listTorso1Legs1 then
      maleTable.Torso1Legs1.chance = 20;
      femaleTable.Torso1Legs1.chance = 20;
      local maleItems = maleTable.Torso1Legs1.items;
      local femaleItems = femaleTable.Torso1Legs1.items;
      merge_Old_New(maleItems,clothingLists.listTorso1Legs1);
      merge_Old_New(femaleItems,clothingLists.listTorso1Legs1);
    end
    if clothingLists.listNeck then
      maleTable.Neck.chance = 20;
      femaleTable.Neck.chance = 20;
      local maleItems = maleTable.Neck.items;
      local femaleItems = femaleTable.Neck.items;
      merge_Old_New(maleItems,clothingLists.listNeck);
      merge_Old_New(femaleItems,clothingLists.listNeck);
    end
    if clothingLists.listHands then
      maleTable.Hands.chance = 20;
      femaleTable.Hands.chance = 20;
      local maleItems = maleTable.Hands.items;
      local femaleItems = femaleTable.Hands.items;
      merge_Old_New(maleItems,clothingLists.listHands);
      merge_Old_New(femaleItems,clothingLists.listHands);
    end
    if clothingLists.listLegs1 then
      maleTable.Legs1.chance = 20;
      femaleTable.Legs1.chance = 20;
      local maleItems = maleTable.Legs1.items;
      local femaleItems = femaleTable.Legs1.items;
      merge_Old_New(maleItems,clothingLists.listLegs1);
      merge_Old_New(femaleItems,clothingLists.listLegs1);
    end
    if clothingLists.listSweater then
      maleTable.Sweater.chance = 20;
      femaleTable.Sweater.chance = 20;
      local maleItems = maleTable.Sweater.items;
      local femaleItems = femaleTable.Sweater.items;
      merge_Old_New(maleItems,clothingLists.listSweater);
      merge_Old_New(femaleItems,clothingLists.listSweater);
    end
    if clothingLists.listSweaterHat then
      maleTable.SweaterHat.chance = 20;
      femaleTable.SweaterHat.chance = 20;
      local maleItems = maleTable.SweaterHat.items;
      local femaleItems = femaleTable.SweaterHat.items;
      merge_Old_New(maleItems,clothingLists.listSweaterHat);
      merge_Old_New(femaleItems,clothingLists.listSweaterHat);
    end
    if clothingLists.listJacket then
      maleTable.Jacket.chance = 20;
      femaleTable.Jacket.chance = 20;
      local maleItems = maleTable.Jacket.items;
      local femaleItems = femaleTable.Jacket.items;
      merge_Old_New(maleItems,clothingLists.listJacket);
      merge_Old_New(femaleItems,clothingLists.listJacket);
    end
    if clothingLists.listJacketHat then
      maleTable.JacketHat.chance = 20;
      femaleTable.JacketHat.chance = 20;
      local maleItems = maleTable.JacketHat.items;
      local femaleItems = femaleTable.JacketHat.items;
      merge_Old_New(maleItems,clothingLists.listJacketHat);
      merge_Old_New(femaleItems,clothingLists.listJacketHat);
    end
    if clothingLists.listFullSuit then
      maleTable.FullSuit.chance = 20;
      femaleTable.FullSuit.chance = 20;
      local maleItems = maleTable.FullSuit.items;
      local femaleItems = femaleTable.FullSuit.items;
      merge_Old_New(maleItems,clothingLists.listFullSuit);
      merge_Old_New(femaleItems,clothingLists.listFullSuit);
    end
    if clothingLists.listFullSuitHead then
      maleTable.FullSuitHead.chance = 20;
      femaleTable.FullSuitHead.chance = 20;
      local maleItems = maleTable.FullSuitHead.items;
      local femaleItems = femaleTable.FullSuitHead.items;
      merge_Old_New(maleItems,clothingLists.listFullSuitHead);
      merge_Old_New(femaleItems,clothingLists.listFullSuitHead);
    end
    if clothingLists.listFullTop then
      maleTable.FullTop.chance = 20;
      femaleTable.FullTop.chance = 20;
      local maleItems = maleTable.FullTop.items;
      local femaleItems = femaleTable.FullTop.items;
      merge_Old_New(maleItems,clothingLists.listFullTop);
      merge_Old_New(femaleItems,clothingLists.listFullTop);
    end
    if clothingLists.listBathRobe then
      maleTable.BathRobe.chance = 20;
      femaleTable.BathRobe.chance = 20;
      local maleItems = maleTable.BathRobe.items;
      local femaleItems = femaleTable.BathRobe.items;
      merge_Old_New(maleItems,clothingLists.listBathRobe);
      merge_Old_New(femaleItems,clothingLists.listBathRobe);
    end
    if clothingLists.listTorsoExtra then
      maleTable.TorsoExtra.chance = 20;
      femaleTable.TorsoExtra.chance = 20;
      local maleItems = maleTable.TorsoExtra.items;
      local femaleItems = femaleTable.TorsoExtra.items;
      merge_Old_New(maleItems,clothingLists.listTorsoExtra);
      merge_Old_New(femaleItems,clothingLists.listTorsoExtra);
    end
    if clothingLists.listTail then
      maleTable.Tail.chance = 20;
      femaleTable.Tail.chance = 20;
      local maleItems = maleTable.Tail.items;
      local femaleItems = femaleTable.Tail.items;
      merge_Old_New(maleItems,clothingLists.listTail);
      merge_Old_New(femaleItems,clothingLists.listTail);
    end
    if clothingLists.listBack then
      maleTable.Back.chance = 20;
      femaleTable.Back.chance = 20;
      local maleItems = maleTable.Back.items;
      local femaleItems = femaleTable.Back.items;
      merge_Old_New(maleItems,clothingLists.listBack);
      merge_Old_New(femaleItems,clothingLists.listBack);
    end
    if clothingLists.listScarf then
      maleTable.Scarf.chance = 20;
      femaleTable.Scarf.chance = 20;
      local maleItems = maleTable.Scarf.items;
      local femaleItems = femaleTable.Scarf.items;
      merge_Old_New(maleItems,clothingLists.listScarf);
      merge_Old_New(femaleItems,clothingLists.listScarf);
    end
-- end

-- addClothing(clothingLists);
