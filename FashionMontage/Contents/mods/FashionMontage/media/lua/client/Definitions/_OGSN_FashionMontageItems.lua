require "Definitions/_OGSN_FashionMontage"
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

_OGSN_FashionMontage.addClothing(clothingLists);
