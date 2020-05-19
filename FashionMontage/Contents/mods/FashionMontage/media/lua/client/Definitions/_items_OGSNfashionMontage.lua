-- Lists of all vanilla items --

-- NOTE TO MODDERS: Do NOT overwrite this file.
-- If you want to add new clothing, create a new .lua file using the
-- template I have created in media/lua/client/Definitions/items_ExampleModName.lua

local listHat = {
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
}
local listTankTop = {
  "DistinctNames.Vest_DefaultTEXTURE_TINT",
}
local listTshirt = {
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
}
local listShirt = {
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
}
local listSocks = {
  "DistinctNames.Socks_Ankle",
  "DistinctNames.Socks_Long",
}
local listPants = {
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
}
local listSkirt = {
  "DistinctNames.Skirt_Long",
  "DistinctNames.Skirt_Normal",
  "DistinctNames.Skirt_Knees",
  "DistinctNames.Skirt_Short",
}
local listDress = {
  "DistinctNames.Dress_Long",
  "DistinctNames.Dress_Normal",
  "DistinctNames.Dress_Knees",
  "DistinctNames.Dress_Short",
  "DistinctNames.HospitalGown",
}
local listShoes = {
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
}
local listEyes = {
  "DistinctNames.Glasses_Normal",
  "DistinctNames.Glasses_Reading",
  "DistinctNames.Glasses_SafetyGoggles",
  "DistinctNames.Glasses_Shooting",
  "DistinctNames.Glasses_SkiGoggles",
  "DistinctNames.Glasses_SwimmingGoggles",
  "DistinctNames.Glasses_Sun",
  "DistinctNames.Glasses_Aviators",
  "DistinctNames.Glasses",
}
local listBeltExtra = {
  "DistinctNames.HolsterSimple",
  "DistinctNames.HolsterDouble",
}
local listMask = {
  "DistinctNames.Hat_BalaclavaFull",
  "DistinctNames.Hat_BalaclavaFace",
  "DistinctNames.Hat_BandanaMask",
  "DistinctNames.Hat_BandanaMaskTINT",
  "DistinctNames.Hat_DustMask",
  "DistinctNames.Hat_SurgicalMask_Blue",
  "DistinctNames.Hat_SurgicalMask_Green",
}
local listMaskEyes = {
  "DistinctNames.Hat_GasMask",
  "DistinctNames.WeldingMask",
}
local listUnderwear = {
  "DistinctNames.Bikini_TINT",
  "DistinctNames.Bikini_Pattern01",
  "DistinctNames.SwimTrunks_Blue",
  "DistinctNames.SwimTrunks_Green",
  "DistinctNames.SwimTrunks_Red",
  "DistinctNames.SwimTrunks_Yellow",
  "DistinctNames.Swimsuit_TINT",
}
local listFullHat = {
  "DistinctNames.Hat_SPHhelmet",
  "DistinctNames.Hat_FootballHelmet",
  "DistinctNames.Hat_CrashHelmetFULL",
  "DistinctNames.Hat_RiotHelmet",
  "DistinctNames.Hat_NBCmask",
  "DistinctNames.Hat_Spiffo",
}
local listTorso1Legs1 = {
  "DistinctNames.LongJohns",
}
local listNeck = {
  "DistinctNames.Tie_Full",
  "DistinctNames.Tie_Worn",
  "DistinctNames.Tie_BowTieFull",
  "DistinctNames.Tie_BowTieWorn",
  "DistinctNames.Tie_Full_Spiffo",
  "DistinctNames.Tie_Worn_Spiffo",
}
local listHands = {
  "DistinctNames.Gloves_FingerlessGloves",
  "DistinctNames.Gloves_LeatherGloves",
  "DistinctNames.Gloves_LeatherGlovesBlack",
  "DistinctNames.Gloves_LongWomenGloves",
  "DistinctNames.Gloves_WhiteTINT",
}
local listLegs1 = {
  "DistinctNames.LongJohns_Bottoms"
}
local listSweater = {
  "DistinctNames.Jumper_DiamondPatternTINT",
  "DistinctNames.Jumper_TankTopDiamondTINT",
  "DistinctNames.HoodieDOWN_WhiteTINT",
  "DistinctNames.Jumper_PoloNeck",
  "DistinctNames.Jumper_RoundNeck",
  "DistinctNames.Jumper_VNeck",
  "DistinctNames.Jumper_TankTopTINT",
}
local listSweaterHat = {
  "DistinctNames.HoodieUP_WhiteTINT",
}
local listJacket = {
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
}
local listJacketHat = {
  "DistinctNames.Jacket_Padded",
  "DistinctNames.PonchoGreen",
  "DistinctNames.PonchoYellow",
}
local listFullSuit = {
  "DistinctNames.Boilersuit",
  "DistinctNames.Boilersuit_BlueRed",
  "DistinctNames.Boilersuit_Flying",
  "DistinctNames.Boilersuit_PrisonerKhaki",
  "DistinctNames.Boilersuit_Prisoner",
  "DistinctNames.SpiffoSuit",
  "DistinctNames.WeddingDress",
}
local listFullSuitHead = {
  "DistinctNames.HazmatSuit",
}
local listFullTop = {
  "DistinctNames.Ghillie_Top",
}
local listBathRobe = {
  "DistinctNames.LongCoat_Bathrobe",
}
local listTorsoExtra = {
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
}
local listTail = {
  "DistinctNames.SpiffoTail",
}
local listBack = {
  "Base.Bag_ALICEpack_Army",
  "Base.Bag_ALICEpack",
  "Base.Bag_BigHikingBag",
  "Base.Bag_NormalHikingBag",
  "Base.Bag_DuffelBagTINT",
  "Base.Bag_Schoolbag",
}
local listScarf = {
  "DistinctNames.Scarf_White",
  "DistinctNames.Scarf_StripeBlackWhite",
  "DistinctNames.Scarf_StripeBlueWhite",
  "DistinctNames.Scarf_StripeRedWhite",
}

-- ClothingSelectionDefinitions = ClothingSelectionDefinitions or {};
-- ClothingSelectionDefinitions.default.Male = {};
-- ClothingSelectionDefinitions.default.Female = {};

-- ClothingSelectionDefinitions.default.Male.Hat = {}
ClothingSelectionDefinitions.default.Male.Hat.items = {}
ClothingSelectionDefinitions.default.Male.Hat.chance = 25

-- ClothingSelectionDefinitions.default.Male.TankTop = {}
ClothingSelectionDefinitions.default.Male.TankTop.items = {}
ClothingSelectionDefinitions.default.Male.TankTop.chance = 25

-- ClothingSelectionDefinitions.default.Male.Tshirt = {}
ClothingSelectionDefinitions.default.Male.Tshirt.items = {}
ClothingSelectionDefinitions.default.Male.Tshirt.chance = 25

-- ClothingSelectionDefinitions.default.Male.Shirt = {}
ClothingSelectionDefinitions.default.Male.Shirt.items = {}
ClothingSelectionDefinitions.default.Male.Shirt.chance = 25

-- ClothingSelectionDefinitions.default.Male.Socks = {}
ClothingSelectionDefinitions.default.Male.Socks.items = {}
ClothingSelectionDefinitions.default.Male.Socks.chance = 25

-- ClothingSelectionDefinitions.default.Male.Pants = {}
ClothingSelectionDefinitions.default.Male.Pants.items = {}
ClothingSelectionDefinitions.default.Male.Pants.chance = 25

-- ClothingSelectionDefinitions.default.Male.Skirt = {}
ClothingSelectionDefinitions.default.Male.Skirt.items = {}
ClothingSelectionDefinitions.default.Male.Skirt.chance = 25

-- ClothingSelectionDefinitions.default.Male.Dress = {}
ClothingSelectionDefinitions.default.Male.Dress.items = {}
ClothingSelectionDefinitions.default.Male.Dress.chance = 25

-- ClothingSelectionDefinitions.default.Male.Shoes = {}
ClothingSelectionDefinitions.default.Male.Shoes.items = {}
ClothingSelectionDefinitions.default.Male.Shoes.chance = 25

-- ClothingSelectionDefinitions.default.Male.Eyes = {}
ClothingSelectionDefinitions.default.Male.Eyes.items = {}
ClothingSelectionDefinitions.default.Male.Eyes.chance = 25

-- ClothingSelectionDefinitions.default.Male.BeltExtra = {}
ClothingSelectionDefinitions.default.Male.BeltExtra.items = {}
ClothingSelectionDefinitions.default.Male.BeltExtra.chance = 25

-- ClothingSelectionDefinitions.default.Male.Mask = {}
ClothingSelectionDefinitions.default.Male.Mask.items = {}
ClothingSelectionDefinitions.default.Male.Mask.chance = 25

-- ClothingSelectionDefinitions.default.Male.MaskEyes = {}
ClothingSelectionDefinitions.default.Male.MaskEyes.items = {}
ClothingSelectionDefinitions.default.Male.MaskEyes.chance = 25

-- ClothingSelectionDefinitions.default.Male.Underwear = {}
ClothingSelectionDefinitions.default.Male.Underwear.items = {}
ClothingSelectionDefinitions.default.Male.Underwear.chance = 25

-- ClothingSelectionDefinitions.default.Male.FullHat = {}
ClothingSelectionDefinitions.default.Male.FullHat.items = {}
ClothingSelectionDefinitions.default.Male.FullHat.chance = 25

-- ClothingSelectionDefinitions.default.Male.Torso1Legs1 = {}
ClothingSelectionDefinitions.default.Male.Torso1Legs1.items = {}
ClothingSelectionDefinitions.default.Male.Torso1Legs1.chance = 25

-- ClothingSelectionDefinitions.default.Male.Neck = {}
ClothingSelectionDefinitions.default.Male.Neck.items = {}
ClothingSelectionDefinitions.default.Male.Neck.chance = 25

-- ClothingSelectionDefinitions.default.Male.Hands = {}
ClothingSelectionDefinitions.default.Male.Hands.items = {}
ClothingSelectionDefinitions.default.Male.Hands.chance = 25

-- ClothingSelectionDefinitions.default.Male.Legs1 = {}
ClothingSelectionDefinitions.default.Male.Legs1.items = {}
ClothingSelectionDefinitions.default.Male.Legs1.chance = 25

-- ClothingSelectionDefinitions.default.Male.Sweater = {}
ClothingSelectionDefinitions.default.Male.Sweater.items = {}
ClothingSelectionDefinitions.default.Male.Sweater.chance = 25

-- ClothingSelectionDefinitions.default.Male.Jacket = {}
ClothingSelectionDefinitions.default.Male.Jacket.items = {}
ClothingSelectionDefinitions.default.Male.Jacket.chance = 25

-- ClothingSelectionDefinitions.default.Male.FullSuit = {}
ClothingSelectionDefinitions.default.Male.FullSuit.items = {}
ClothingSelectionDefinitions.default.Male.FullSuit.chance = 25

-- ClothingSelectionDefinitions.default.Male.FullSuitHead = {}
ClothingSelectionDefinitions.default.Male.FullSuitHead.items = {}
ClothingSelectionDefinitions.default.Male.FullSuitHead.chance = 25

-- ClothingSelectionDefinitions.default.Male.FullTop = {}
ClothingSelectionDefinitions.default.Male.FullTop.items = {}
ClothingSelectionDefinitions.default.Male.FullTop.chance = 25

-- ClothingSelectionDefinitions.default.Male.BathRobe = {}
ClothingSelectionDefinitions.default.Male.BathRobe.items = {}
ClothingSelectionDefinitions.default.Male.BathRobe.chance = 25

-- ClothingSelectionDefinitions.default.Male.TorsoExtra = {}
ClothingSelectionDefinitions.default.Male.TorsoExtra.items = {}
ClothingSelectionDefinitions.default.Male.TorsoExtra.chance = 25

-- ClothingSelectionDefinitions.default.Male.Tail = {}
ClothingSelectionDefinitions.default.Male.Tail.items = {}
ClothingSelectionDefinitions.default.Male.Tail.chance = 25

-- ClothingSelectionDefinitions.default.Male.Back = {}
ClothingSelectionDefinitions.default.Male.Back.items = {}
ClothingSelectionDefinitions.default.Male.Back.chance = 25

-- ClothingSelectionDefinitions.default.Male.Scarf = {}
ClothingSelectionDefinitions.default.Male.Scarf.items = {}
ClothingSelectionDefinitions.default.Male.Scarf.chance = 25

-- ClothingSelectionDefinitions.default.Female.Hat = {}
ClothingSelectionDefinitions.default.Female.Hat.items = {}
ClothingSelectionDefinitions.default.Female.Hat.chance = 25

-- ClothingSelectionDefinitions.default.Female.TankTop = {}
ClothingSelectionDefinitions.default.Female.TankTop.items = {}
ClothingSelectionDefinitions.default.Female.TankTop.chance = 25

-- ClothingSelectionDefinitions.default.Female.Tshirt = {}
ClothingSelectionDefinitions.default.Female.Tshirt.items = {}
ClothingSelectionDefinitions.default.Female.Tshirt.chance = 25

-- ClothingSelectionDefinitions.default.Female.Shirt = {}
ClothingSelectionDefinitions.default.Female.Shirt.items = {}
ClothingSelectionDefinitions.default.Female.Shirt.chance = 25

-- ClothingSelectionDefinitions.default.Female.Socks = {}
ClothingSelectionDefinitions.default.Female.Socks.items = {}
ClothingSelectionDefinitions.default.Female.Socks.chance = 25

-- ClothingSelectionDefinitions.default.Female.Pants = {}
ClothingSelectionDefinitions.default.Female.Pants.items = {}
ClothingSelectionDefinitions.default.Female.Pants.chance = 25

-- ClothingSelectionDefinitions.default.Female.Skirt = {}
ClothingSelectionDefinitions.default.Female.Skirt.items = {}
ClothingSelectionDefinitions.default.Female.Skirt.chance = 25

-- ClothingSelectionDefinitions.default.Female.Dress = {}
ClothingSelectionDefinitions.default.Female.Dress.items = {}
ClothingSelectionDefinitions.default.Female.Dress.chance = 25

-- ClothingSelectionDefinitions.default.Female.Shoes = {}
ClothingSelectionDefinitions.default.Female.Shoes.items = {}
ClothingSelectionDefinitions.default.Female.Shoes.chance = 25

-- ClothingSelectionDefinitions.default.Female.Eyes = {}
ClothingSelectionDefinitions.default.Female.Eyes.items = {}
ClothingSelectionDefinitions.default.Female.Eyes.chance = 25

-- ClothingSelectionDefinitions.default.Female.BeltExtra = {}
ClothingSelectionDefinitions.default.Female.BeltExtra.items = {}
ClothingSelectionDefinitions.default.Female.BeltExtra.chance = 25

-- ClothingSelectionDefinitions.default.Female.Mask = {}
ClothingSelectionDefinitions.default.Female.Mask.items = {}
ClothingSelectionDefinitions.default.Female.Mask.chance = 25

-- ClothingSelectionDefinitions.default.Female.MaskEyes = {}
ClothingSelectionDefinitions.default.Female.MaskEyes.items = {}
ClothingSelectionDefinitions.default.Female.MaskEyes.chance = 25

-- ClothingSelectionDefinitions.default.Female.Underwear = {}
ClothingSelectionDefinitions.default.Female.Underwear.items = {}
ClothingSelectionDefinitions.default.Female.Underwear.chance = 25

-- ClothingSelectionDefinitions.default.Female.FullHat = {}
ClothingSelectionDefinitions.default.Female.FullHat.items = {}
ClothingSelectionDefinitions.default.Female.FullHat.chance = 25

-- ClothingSelectionDefinitions.default.Female.Torso1Legs1 = {}
ClothingSelectionDefinitions.default.Female.Torso1Legs1.items = {}
ClothingSelectionDefinitions.default.Female.Torso1Legs1.chance = 25

-- ClothingSelectionDefinitions.default.Female.Neck = {}
ClothingSelectionDefinitions.default.Female.Neck.items = {}
ClothingSelectionDefinitions.default.Female.Neck.chance = 25

-- ClothingSelectionDefinitions.default.Female.Hands = {}
ClothingSelectionDefinitions.default.Female.Hands.items = {}
ClothingSelectionDefinitions.default.Female.Hands.chance = 25

-- ClothingSelectionDefinitions.default.Female.Legs1 = {}
ClothingSelectionDefinitions.default.Female.Legs1.items = {}
ClothingSelectionDefinitions.default.Female.Legs1.chance = 25

-- ClothingSelectionDefinitions.default.Female.Sweater = {}
ClothingSelectionDefinitions.default.Female.Sweater.items = {}
ClothingSelectionDefinitions.default.Female.Sweater.chance = 25

-- ClothingSelectionDefinitions.default.Female.Jacket = {}
ClothingSelectionDefinitions.default.Female.Jacket.items = {}
ClothingSelectionDefinitions.default.Female.Jacket.chance = 25

-- ClothingSelectionDefinitions.default.Female.FullSuit = {}
ClothingSelectionDefinitions.default.Female.FullSuit.items = {}
ClothingSelectionDefinitions.default.Female.FullSuit.chance = 25

-- ClothingSelectionDefinitions.default.Female.FullSuitHead = {}
ClothingSelectionDefinitions.default.Female.FullSuitHead.items = {}
ClothingSelectionDefinitions.default.Female.FullSuitHead.chance = 25

-- ClothingSelectionDefinitions.default.Female.FullTop = {}
ClothingSelectionDefinitions.default.Female.FullTop.items = {}
ClothingSelectionDefinitions.default.Female.FullTop.chance = 25

-- ClothingSelectionDefinitions.default.Female.BathRobe = {}
ClothingSelectionDefinitions.default.Female.BathRobe.items = {}
ClothingSelectionDefinitions.default.Female.BathRobe.chance = 25

-- ClothingSelectionDefinitions.default.Female.TorsoExtra = {}
ClothingSelectionDefinitions.default.Female.TorsoExtra.items = {}
ClothingSelectionDefinitions.default.Female.TorsoExtra.chance = 25

-- ClothingSelectionDefinitions.default.Female.Tail = {}
ClothingSelectionDefinitions.default.Female.Tail.items = {}
ClothingSelectionDefinitions.default.Female.Tail.chance = 25

-- ClothingSelectionDefinitions.default.Female.Back = {}
ClothingSelectionDefinitions.default.Female.Back.items = {}
ClothingSelectionDefinitions.default.Female.Back.chance = 25

-- ClothingSelectionDefinitions.default.Female.Scarf = {}
ClothingSelectionDefinitions.default.Female.Scarf.items = {}
ClothingSelectionDefinitions.default.Female.Scarf.chance = 25

if next(listHat) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["Hat"].items,listHat);
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["Hat"].chance,0);
end
if next(listTankTop) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["TankTop"].items,listTankTop);
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["TankTop"].chance,0);
end
if next(listTshirt) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["Tshirt"].items,listTshirt);
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["Tshirt"].chance,0);
end
if next(listShirt) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["Shirt"].items,listShirt);
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["Shirt"].chance,0);
end
if next(listSocks) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["Socks"].items,listSocks);
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["Socks"].chance,0);
end
if next(listPants) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["Pants"].items,listPants);
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["Pants"].chance,0);
end
if next(listSkirt) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["Skirt"].items,listSkirt);
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["Skirt"].chance,0);
end
if next(listDress) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["Dress"].items,listDress);
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["Dress"].chance,0);
end
if next(listShoes) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["Shoes"].items,listShoes);
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["Shoes"].chance,0);
end
if next(listEyes) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["Eyes"].items,listEyes);
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["Eyes"].chance,0);
end
if next(listBeltExtra) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["BeltExtra"].items,listBeltExtra);
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["BeltExtra"].chance,0);
end
if next(listMask) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["Mask"].items,listMask);
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["Mask"].chance,0);
end
if next(listMaskEyes) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["MaskEyes"].items,listMaskEyes);
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["MaskEyes"].chance,0);
end
if next(listUnderwear) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["Underwear"].items,listUnderwear);
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["Underwear"].chance,0);
end
if next(listFullHat) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["FullHat"].items,listFullHat);
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["FullHat"].chance,0);
end
if next(listTorso1Legs1) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["Torso1Legs1"].items,listTorso1Legs1);
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["Torso1Legs1"].chance,0);
end
if next(listNeck) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["Neck"].items,listNeck);
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["Neck"].chance,0);
end
if next(listHands) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["Hands"].items,listHands);
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["Hands"].chance,0);
end
if next(listLegs1) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["Legs1"].items,listLegs1);
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["Legs1"].chance,0);
end
if next(listSweater) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["Sweater"].items,listSweater);
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["Sweater"].chance,0);
end
if next(listJacket) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["Jacket"].items,listJacket);
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["Jacket"].chance,0);
end
if next(listFullSuit) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["FullSuit"].items,listFullSuit);
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["FullSuit"].chance,0);
end
if next(listFullSuitHead) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["FullSuitHead"].items,listFullSuitHead);
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["FullSuitHead"].chance,0);
end
if next(listFullTop) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["FullTop"].items,listFullTop);
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["FullTop"].chance,0);
end
if next(listBathRobe) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["BathRobe"].items,listBathRobe);
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["BathRobe"].chance,0);
end
if next(listTorsoExtra) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["TorsoExtra"].items,listTorsoExtra);
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["TorsoExtra"].chance,0);
end
if next(listTail) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["Tail"].items,listTail);
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["Tail"].chance,0);
end
if next(listBack) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["Back"].items,listBack);
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["Back"].chance,0);
end
if next(listScarf) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["Scarf"].items,listScarf);
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["Scarf"].chance,0);
end
if next(listHat) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["Hat"].items,listHat);
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["Hat"].chance,0);
end
if next(listTankTop) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["TankTop"].items,listTankTop);
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["TankTop"].chance,0);
end
if next(listTshirt) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["Tshirt"].items,listTshirt);
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["Tshirt"].chance,0);
end
if next(listShirt) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["Shirt"].items,listShirt);
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["Shirt"].chance,0);
end
if next(listSocks) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["Socks"].items,listSocks);
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["Socks"].chance,0);
end
if next(listPants) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["Pants"].items,listPants);
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["Pants"].chance,0);
end
if next(listSkirt) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["Skirt"].items,listSkirt);
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["Skirt"].chance,0);
end
if next(listDress) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["Dress"].items,listDress);
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["Dress"].chance,0);
end
if next(listShoes) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["Shoes"].items,listShoes);
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["Shoes"].chance,0);
end
if next(listEyes) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["Eyes"].items,listEyes);
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["Eyes"].chance,0);
end
if next(listBeltExtra) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["BeltExtra"].items,listBeltExtra);
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["BeltExtra"].chance,0);
end
if next(listMask) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["Mask"].items,listMask);
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["Mask"].chance,0);
end
if next(listMaskEyes) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["MaskEyes"].items,listMaskEyes);
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["MaskEyes"].chance,0);
end
if next(listUnderwear) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["Underwear"].items,listUnderwear);
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["Underwear"].chance,0);
end
if next(listFullHat) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["FullHat"].items,listFullHat);
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["FullHat"].chance,0);
end
if next(listTorso1Legs1) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["Torso1Legs1"].items,listTorso1Legs1);
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["Torso1Legs1"].chance,0);
end
if next(listNeck) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["Neck"].items,listNeck);
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["Neck"].chance,0);
end
if next(listHands) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["Hands"].items,listHands);
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["Hands"].chance,0);
end
if next(listLegs1) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["Legs1"].items,listLegs1);
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["Legs1"].chance,0);
end
if next(listSweater) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["Sweater"].items,listSweater);
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["Sweater"].chance,0);
end
if next(listJacket) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["Jacket"].items,listJacket);
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["Jacket"].chance,0);
end
if next(listFullSuit) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["FullSuit"].items,listFullSuit);
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["FullSuit"].chance,0);
end
if next(listFullSuitHead) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["FullSuitHead"].items,listFullSuitHead);
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["FullSuitHead"].chance,0);
end
if next(listFullTop) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["FullTop"].items,listFullTop);
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["FullTop"].chance,0);
end
if next(listBathRobe) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["BathRobe"].items,listBathRobe);
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["BathRobe"].chance,0);
end
if next(listTorsoExtra) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["TorsoExtra"].items,listTorsoExtra);
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["TorsoExtra"].chance,0);
end
if next(listTail) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["Tail"].items,listTail);
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["Tail"].chance,0);
end
if next(listBack) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["Back"].items,listBack);
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["Back"].chance,0);
end
if next(listScarf) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["Scarf"].items,listScarf);
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["Scarf"].chance,0);
end


-- startingOutfit --
ClothingSelectionDefinitions.starting = {}
ClothingSelectionDefinitions.starting.Male = {}
ClothingSelectionDefinitions.starting.Female = {}

ClothingSelectionDefinitions.starting.Male.Shoes = {chance=100, items = {"DistinctNames2.Shoes_TrainerTINT"}}
ClothingSelectionDefinitions.starting.Male.TankTop = {chance=100, items = {"DistinctNames2.Vest_DefaultTEXTURE_TINT"}}
ClothingSelectionDefinitions.starting.Male.Socks = {chance=100, items = {"DistinctNames2.Socks_Ankle"}}
ClothingSelectionDefinitions.starting.Male.Pants = {chance=100, items = {"DistinctNames2.Trousers_WhiteTINT"}}

ClothingSelectionDefinitions.starting.Female.Shoes = {chance=100, items = {"DistinctNames2.Shoes_TrainerTINT"}}
ClothingSelectionDefinitions.starting.Female.TankTop = {chance=100, items = {"DistinctNames2.Vest_DefaultTEXTURE_TINT"}}
ClothingSelectionDefinitions.starting.Female.Socks = {chance=100, items = {"DistinctNames2.Socks_Ankle"}}
ClothingSelectionDefinitions.starting.Female.Pants = {chance=100, items = {"DistinctNames2.Trousers_WhiteTINT"}}
