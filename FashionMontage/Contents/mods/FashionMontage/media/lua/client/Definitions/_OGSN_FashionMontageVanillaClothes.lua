require "Definitions/_OGSN_FashionMontage"
-- Lists of all vanilla items --

-- NOTE TO MODDERS: Do NOT overwrite this file.
-- If you want to add new clothing, create a new .lua file using the
-- template I have created in media/lua/client/Definitions/YourClothingModName_FashionMontage.lua

local clothing = {
      Hat = {
        "Base.Hat_Bandana",
        "Base.Hat_BandanaTied",
        "Base.Hat_BandanaTINT",
        "Base.Hat_BandanaTiedTINT",
        "Base.Hat_BaseballCap",
        "Base.Hat_BaseballCapBlue",
        "Base.Hat_BaseballCapRed",
        "Base.Hat_BaseballCapGreen",
        "Base.Hat_BaseballCapArmy",
        "Base.Hat_BaseballCapKY",
        "Base.Hat_BaseballCapKY_Red",
        "Base.Hat_Beany",
        "Base.Hat_Beret",
        "Base.Hat_BeretArmy",
        "Base.Hat_BonnieHat_CamoGreen",
        "Base.Hat_BonnieHat",
        "Base.Hat_BucketHat",
        "Base.Hat_ChefHat",
        "Base.Hat_Cowboy",
        "Base.Hat_EarMuffs",
        "Base.Hat_EarMuff_Protectors",
        "Base.Hat_Fedora",
        "Base.Hat_Fedora_Delmonte",
        "Base.Hat_Ranger",
        "Base.Hat_Police_Grey",
        "Base.Hat_Police",
        "Base.Hat_GolfHatTINT",
        "Base.Hat_GolfHat",
        "Base.Hat_HardHat",
        "Base.Hat_HardHat_Miner",
        "Base.Hat_Army",
        "Base.Hat_BaseballHelmet_KY",
        "Base.Hat_BaseballHelmet_Rangers",
        "Base.Hat_BaseballHelmet_Z",
        "Base.Hat_BicycleHelmet",
        "Base.Hat_CrashHelmet",
        "Base.Hat_CrashHelmet_Police",
        "Base.Hat_CrashHelmet_Stars",
        "Base.Hat_Fireman",
        "Base.Hat_HockeyHelmet",
        "Base.Hat_JockeyHelmet01",
        "Base.Hat_JockeyHelmet02",
        "Base.Hat_JockeyHelmet03",
        "Base.Hat_JockeyHelmet04",
        "Base.Hat_JockeyHelmet05",
        "Base.Hat_JockeyHelmet06",
        "Base.Hat_RidingHelmet",
        "Base.Hat_PeakedCapArmy",
        "Base.Hat_NewspaperHat",
        "Base.Hat_PartyHat_TINT",
        "Base.Hat_PartyHat_Stars",
        "Base.Hat_Raccoon",
        "Base.Hat_FastFood",
        "Base.Hat_FastFood_IceCream",
        "Base.Hat_FastFood_Spiffo",
        "Base.Hat_SantaHat",
        "Base.Hat_SantaHatGreen",
        "Base.Hat_ShowerCap",
        "Base.Hat_SummerHat",
        "Base.Hat_SurgicalCap_Blue",
        "Base.Hat_SurgicalCap_Green",
        "Base.Hat_Sweatband",
        "Base.Hat_TinFoilHat",
        "Base.Hat_Visor_WhiteTINT",
        "Base.Hat_VisorBlack",
        "Base.Hat_VisorRed",
        "Base.Hat_WeddingVeil",
        "Base.Hat_WinterHat",
        "Base.Hat_WoolyHat",
      },
      TankTop = {
        "Base.Vest_DefaultTEXTURE_TINT",
      },
      Tshirt = {
        -- "Base.Tshirt_DefaultTEXTURE",
        "Base.Tshirt_DefaultTEXTURE_TINT",
        "Base.Tshirt_WhiteTINT",
        -- "Base.Tshirt_WhiteLongSleeve",
        "Base.Tshirt_WhiteLongSleeveTINT",
        "Base.Tshirt_PoloStripedTINT",
        "Base.Tshirt_PoloTINT",
        -- "Base.Tshirt_DefaultDECAL",
        "Base.Tshirt_DefaultDECAL_TINT",
        -- "Base.Tshirt_SportDECAL",
        "Base.Tshirt_Rock",
        "Base.Tshirt_Sport",
        "Base.Tshirt_ArmyGreen",
        "Base.Tshirt_CamoDesert",
        "Base.Tshirt_CamoGreen",
        "Base.Tshirt_CamoUrban",
        "Base.Tshirt_Fossoil",
        "Base.Tshirt_Gas2Go",
        "Base.Tshirt_McCoys",
        "Base.Tshirt_PileOCrepe",
        "Base.Tshirt_PizzaWhirled",
        "Base.Tshirt_BusinessSpiffo",
        "Base.Tshirt_SpiffoDECAL",
        "Base.Tshirt_ThunderGas",
        "Base.Tshirt_ValleyStation",
        "Base.Tshirt_IndieStoneDECAL",
        "Base.Tshirt_Profession_FiremanBlue",
        "Base.Tshirt_Profession_FiremanRed02",
        "Base.Tshirt_Profession_FiremanRed",
        "Base.Tshirt_Profession_FiremanWhite",
        "Base.Tshirt_Scrubs",
        "Base.Tshirt_Ranger",
        "Base.Tshirt_Profession_RangerBrown",
        "Base.Tshirt_Profession_RangerGreen",
        "Base.Tshirt_Profession_PoliceBlue",
        "Base.Tshirt_Profession_PoliceWhite",
        "Base.Tshirt_PoliceGrey",
        "Base.Tshirt_PoliceBlue",
        "Base.Tshirt_Profession_VeterenGreen",
        "Base.Tshirt_Profession_VeterenRed",
      },
      Shirt = {
        "Base.Shirt_FormalWhite",
        "Base.Shirt_Denim",
        "Base.Shirt_FormalWhite_ShortSleeve",
        "Base.Shirt_CamoDesert",
        "Base.Shirt_CamoGreen",
        "Base.Shirt_CamoUrban",
        "Base.Shirt_Baseball_KY",
        "Base.Shirt_Baseball_Rangers",
        "Base.Shirt_Baseball_Z",
        "Base.Shirt_HawaiianTINT",
        "Base.Shirt_HawaiianRed",
        "Base.Shirt_Jockey01",
        "Base.Shirt_Jockey02",
        "Base.Shirt_Jockey03",
        "Base.Shirt_Jockey04",
        "Base.Shirt_Jockey05",
        "Base.Shirt_Jockey06",
        "Base.Shirt_Lumberjack",
        "Base.Shirt_Scrubs",
        "Base.Shirt_Ranger",
        "Base.Shirt_OfficerWhite",
        "Base.Shirt_PoliceBlue",
        "Base.Shirt_PoliceGrey",
        "Base.Shirt_PrisonGuard",
        "Base.Shirt_Priest",
        "Base.Shirt_Workman",
      },
      Socks = {
        "Base.Socks_Ankle",
        "Base.Socks_Long",
      },
      Pants = {
        "Base.Shorts_CamoGreenLong",
        "Base.Shorts_CamoUrbanLong",
        "Base.Shorts_LongDenim",
        "Base.Shorts_LongSport",
        "Base.Shorts_LongSport_Red",
        "Base.Shorts_ShortDenim",
        "Base.Shorts_ShortFormal",
        "Base.Shorts_ShortSport",
        "Base.Ghillie_Trousers",
        -- "Base.Trousers",
        "Base.TrousersMesh_DenimLight",
        "Base.Trousers_CamoDesert",
        "Base.Trousers_CamoGreen",
        "Base.Trousers_CamoUrban",
        "Base.Trousers_Chef",
        -- "Base.Trousers_DefaultTEXTURE",
        -- "Base.Trousers_DefaultTEXTURE_HUE",
        "Base.Trousers_DefaultTEXTURE_TINT",
        "Base.Trousers_Denim",
        "Base.Trousers_Fireman",
        "Base.Trousers_JeanBaggy",
        "Base.Trousers_Padded",
        "Base.Trousers_Police",
        "Base.Trousers_PoliceGrey",
        "Base.Trousers_PrisonGuard",
        "Base.Trousers_Ranger",
        "Base.Trousers_Santa",
        "Base.Trousers_SantaGReen",
        "Base.Trousers_Scrubs",
        "Base.Trousers_Suit",
        -- "Base.Trousers_SuitTEXTURE",
        "Base.Trousers_SuitWhite",
        -- "Base.Trousers_WhiteTEXTURE",
        -- "Base.Trousers_WhiteTINT",
        "Base.Dungarees",
        "Base.Trousers_ArmyService",
        "Base.Trousers_Black",
        "Base.Trousers_NavyBlue",
      },
      Skirt = {
        "Base.Skirt_Long",
        "Base.Skirt_Normal",
        "Base.Skirt_Knees",
        "Base.Skirt_Short",
      },
      Dress = {
        "Base.Dress_Long",
        "Base.Dress_Normal",
        "Base.Dress_Knees",
        "Base.Dress_Short",
        "Base.HospitalGown",
      },
      Shoes = {
        -- "Base.Shoes_Black",
        -- "Base.Shoes_Brown",
        "Base.Shoes_Random",
        -- "Base.Shoes_RedTrainers",
        -- "Base.Shoes_BlueTrainers",
        "Base.Shoes_TrainerTINT",
        "Base.Shoes_BlackBoots",
        "Base.Shoes_ArmyBoots",
        "Base.Shoes_ArmyBootsDesert",
        "Base.Shoes_FlipFlop",
        "Base.Shoes_Wellies",
        "Base.Shoes_RidingBoots",
        "Base.Shoes_Slippers",
      },
      Eyes = {
        "Base.Glasses_Normal",
        "Base.Glasses_Reading",
        "Base.Glasses_SafetyGoggles",
        "Base.Glasses_Shooting",
        "Base.Glasses_SkiGoggles",
        "Base.Glasses_SwimmingGoggles",
        "Base.Glasses_Sun",
        "Base.Glasses_Aviators",
        "Base.Glasses",
      },
      LeftEye = {
        "Glasses_Eyepatch_Left",
      },
      RightEye = {
        "Glasses_Eyepatch_Right",
      },
      BeltExtra = {
        "Base.HolsterSimple",
        "Base.HolsterDouble",
      },
      AmmoStrap = {
        "Base.AmmoStrap_Bullets",
        "Base.AmmoStrap_Shells",
      },
      Mask = {
        "Base.Hat_BalaclavaFull",
        "Base.Hat_BalaclavaFace",
        "Base.Hat_BandanaMask",
        "Base.Hat_BandanaMaskTINT",
        "Base.Hat_DustMask",
        "Base.Hat_SurgicalMask_Blue",
        "Base.Hat_SurgicalMask_Green",
      },
      MaskEyes = {
        "Base.Hat_GasMask",
        "Base.Hat_HockeyMask",
      },
      MaskFull = {
        "Base.WeldingMask",
      },
      Underwear = {
        "Base.Bikini_TINT",
        "Base.Bikini_Pattern01",
        "Base.SwimTrunks_Blue",
        "Base.SwimTrunks_Green",
        "Base.SwimTrunks_Red",
        "Base.SwimTrunks_Yellow",
        "Base.Swimsuit_TINT",
      },
      FullHat = {
        "Base.Hat_SPHhelmet",
        "Base.Hat_FootballHelmet",
        "Base.Hat_CrashHelmetFULL",
        "Base.Hat_RiotHelmet",
        "Base.Hat_NBCmask",
        "Base.Hat_Spiffo",
      },
      Torso1Legs1 = {
        "Base.LongJohns",
      },
      Neck = {
        "Base.Tie_Full",
        "Base.Tie_Worn",
        "Base.Tie_BowTieFull",
        "Base.Tie_BowTieWorn",
        "Base.Tie_Full_Spiffo",
        "Base.Tie_Worn_Spiffo",
        "Base.Necklace_Choker",
        "Base.Necklace_Choker_Sapphire",
        "Base.Necklace_Choker_Amber",
        "Base.Necklace_Choker_Diamond",
      },
      Hands = {
        "Base.Gloves_FingerlessGloves",
        "Base.Gloves_LeatherGloves",
        "Base.Gloves_LeatherGlovesBlack",
        "Base.Gloves_LongWomenGloves",
        "Base.Gloves_WhiteTINT",
        "Base.Gloves_Surgical",
      },
      Legs1 = {
        "Base.LongJohns_Bottoms"
      },
      Sweater = {
        "Base.Jumper_DiamondPatternTINT",
        "Base.HoodieDOWN_WhiteTINT",
        "Base.Jumper_PoloNeck",
        "Base.Jumper_RoundNeck",
        "Base.Jumper_VNeck",
      },
      Jacket = {
        "Base.Jacket_WhiteTINT",
        "Base.Jacket_Black",
        "Base.JacketLong_Random",
        "Base.Jacket_Chef",
        "Base.Jacket_Fireman",
        "Base.JacketLong_Doctor",
        "Base.Jacket_ArmyCamoDesert",
        "Base.Jacket_ArmyCamoGreen",
        "Base.Jacket_CoatArmy",
        "Base.Jacket_NavyBlue",
        "Base.Jacket_PaddedDOWN",
        "Base.Jacket_Ranger",
        "Base.Jacket_Police",
        "Base.PonchoGreenDOWN",
        "Base.PonchoYellowDOWN",
        "Base.JacketLong_Santa",
        "Base.JacketLong_SantaGreen",
        "Base.Suit_Jacket",
        "Base.WeddingJacket",
        "Base.Jacket_Varsity",
      },
      FullSuit = {
        "Base.Boilersuit",
        "Base.Boilersuit_BlueRed",
        "Base.Boilersuit_Flying",
        "Base.Boilersuit_PrisonerKhaki",
        "Base.Boilersuit_Prisoner",
        "Base.SpiffoSuit",
        "Base.WeddingDress",
      },
      FullSuitHead = {
        "Base.HazmatSuit",
      },
      FullTop = {
        "Base.Ghillie_Top",
      },
      BathRobe = {
        "Base.LongCoat_Bathrobe",
      },
      TorsoExtra = {
        "Base.Apron_Black",
        "Base.Apron_White",
        "Base.Apron_WhiteTEXTURE",
        "Base.Apron_IceCream",
        "Base.Apron_PileOCrepe",
        "Base.Apron_PizzaWhirled",
        "Base.Apron_Spiffos",
        "Base.Vest_BulletCivilian",
        "Base.Vest_BulletPolice",
        "Base.Vest_BulletArmy",
        "Base.Jumper_TankTopDiamondTINT",
        "Base.Jumper_TankTopTINT",
        "Base.Vest_Waistcoat",
        "Base.Vest_Waistcoat_GigaMart",
        "Base.Vest_Foreman",
        "Base.Vest_HighViz",
        "Base.Vest_Hunting_Grey",
        "Base.Vest_Hunting_Orange",
        "Base.Vest_Hunting_Camo",
        "Base.Vest_Hunting_CamoGreen",
      },
      Tail = {
        "Base.SpiffoTail",
      },
      Back = {
        "Base.Bag_ALICEpack_Army",
        "Base.Bag_ALICEpack",
        "Base.Bag_BigHikingBag",
        "Base.Bag_NormalHikingBag",
        "Base.Bag_DuffelBagTINT",
        "Base.Bag_Schoolbag",
        "Base.Bag_Satchel",
      },
      Scarf = {
        "Base.Scarf_White",
        "Base.Scarf_StripeBlackWhite",
        "Base.Scarf_StripeBlueWhite",
        "Base.Scarf_StripeRedWhite",
      },
      -- FannyPackBack= {
      --   "Base.Bag_FannyPackBack",
      -- },
      FannyPackFront= {
        "Base.Bag_FannyPackFront",
      },
      Necklace = {
        "Base.Necklace_DogTag",
        "Base.Necklace_Gold",
        "Base.Necklace_GoldRuby",
        "Base.Necklace_GoldDiamond",
        "Base.Necklace_Silver",
        "Base.Necklace_SilverSapphire",
        "Base.Necklace_SilverCrucifix",
        "Base.Necklace_SilverDiamond",
        "Base.Necklace_Crucifix",
        "Base.Necklace_YingYang",
        "Base.Necklace_Pearl",
      },
      Necklace_Long = {
        "Base.NecklaceLong_Gold",
        "Base.NecklaceLong_GoldDiamond",
        "Base.NecklaceLong_Silver",
        "Base.NecklaceLong_SilverEmerald",
        "Base.NecklaceLong_SilverSapphire",
        "Base.NecklaceLong_SilverDiamond",
        "Base.NecklaceLong_Amber",
      },
      Nose = {
        "Base.NoseRing_Gold",
        "Base.NoseRing_Silver",
        "Base.NoseStud_Gold",
        "Base.NoseStud_Silver",
      },
      LeftWrist = {
        "Base.WristWatch_Left_ClassicBlack",
        "Base.WristWatch_Left_ClassicBrown",
        "Base.WristWatch_Left_ClassicMilitary",
        "Base.WristWatch_Left_ClassicGold",
        "Base.WristWatch_Left_DigitalBlack",
        "Base.WristWatch_Left_DigitalRed",
        "Base.WristWatch_Left_DigitalDress",
        "Base.Bracelet_BangleLeftGold",
        "Base.Bracelet_ChainLeftGold",
        "Base.Bracelet_BangleLeftSilver",
        "Base.Bracelet_ChainLeftSilver",
        "Base.Bracelet_LeftFriendshipTINT",
      },
      RightWrist = {
        "Base.WristWatch_Right_ClassicBlack",
        "Base.WristWatch_Right_ClassicBrown",
        "Base.WristWatch_Right_ClassicMilitary",
        "Base.WristWatch_Right_ClassicGold",
        "Base.WristWatch_Right_DigitalBlack",
        "Base.WristWatch_Right_DigitalRed",
        "Base.WristWatch_Right_DigitalDress",
        "Base.Bracelet_BangleRightGold",
        "Base.Bracelet_ChainRightGold",
        "Base.Bracelet_BangleRightSilver",
        "Base.Bracelet_ChainRightSilver",
        "Base.Bracelet_RightFriendshipTINT",
      },
      Right_RingFinger = {
        "Base.Ring_Right_RingFinger_Gold",
        "Base.Ring_Right_RingFinger_Silver",
        "Base.Ring_Right_RingFinger_SilverDiamond",
        "Base.Ring_Right_RingFinger_GoldRuby",
        "Base.Ring_Right_RingFinger_GoldDiamond",
      },
      Left_RingFinger = {
        "Base.Ring_Left_RingFinger_Gold",
        "Base.Ring_Left_RingFinger_Silver",
        "Base.Ring_Left_RingFinger_SilverDiamond",
        "Base.Ring_Left_RingFinger_GoldRuby",
        "Base.Ring_Left_RingFinger_GoldDiamond",
      },
      Right_MiddleFinger = {
        "Base.Ring_Right_MiddleFinger_Gold",
        "Base.Ring_Right_MiddleFinger_Silver",
        "Base.Ring_Right_MiddleFinger_SilverDiamond",
        "Base.Ring_Right_MiddleFinger_GoldRuby",
        "Base.Ring_Right_MiddleFinger_GoldDiamond",
      },
      Left_MiddleFinger = {
        "Base.Ring_Left_MiddleFinger_Gold",
        "Base.Ring_Left_MiddleFinger_Silver",
        "Base.Ring_Left_MiddleFinger_SilverDiamond",
        "Base.Ring_Left_MiddleFinger_GoldRuby",
        "Base.Ring_Left_MiddleFinger_GoldDiamond",
      },
      Ears = {
        "Base.Earring_LoopLrg_Gold",
        "Base.Earring_LoopLrg_Silver",
        "Base.Earring_LoopMed_Silver",
        "Base.Earring_LoopMed_Gold",
        "Base.Earring_LoopSmall_Silver_Both",
        "Base.Earring_LoopSmall_Gold_Both",
        "Base.Earring_Stud_Gold",
        "Base.Earring_Stud_Silver",
        "Base.Earring_Stone_Sapphire",
        "Base.Earring_Stone_Emerald",
        "Base.Earring_Stone_Ruby",
        "Base.Earring_Pearl",
        "Base.Earring_Dangly_Sapphire",
        "Base.Earring_Dangly_Emerald",
        "Base.Earring_Dangly_Ruby",
        "Base.Earring_Dangly_Diamond",
        "Base.Earring_Dangly_Pearl",
      },
      EarTop = {
        "Base.Earring_LoopSmall_Gold_Top",
        "Base.Earring_LoopSmall_Silver_Top",
      },
      -- SkeletonSuit = {},
      -- SlendermanSuit = {},
      -- Torso1 = {},
      -- ShortSleeveShirt = {},
      -- Legs5 = {},
      -- ShirtUntucked = {},
      -- BodyCostume = {},
      -- LeftHand = {},
      -- RightHand = {},
      -- Billboard = {},
      -- Pupils = {},
      -- Wig = {},
      -- Belt419 = {},
      -- Belt420 = {},
      -- TorsoRig = {},
      -- waistbags = {},
      -- waistbagsComplete = {},
      -- waistbagsf = {},
      -- Kneepads = {},
}

local bodyLocations = {
-- Modders, if your mod adds new modded BodyLocations, list them here as strings, e.g.
-- "KneePads",
-- "SidewaysBaseballCap",

-- If you only use vanilla BodyLocations then you don't have to put
-- anything here.
-- The vanilla bodyLocations are already added by the main lua file.
}

_OGSN_FashionMontage.addClothingItems(clothing);
if #bodyLocations > 0 then
  _OGSN_FashionMontage.addBodyLocations(bodyLocations);
end
