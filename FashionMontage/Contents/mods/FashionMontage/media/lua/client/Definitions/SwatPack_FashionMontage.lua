-- INSTRUCTIONS - NAMING THE FILE --
-- Rename this file, ideally your mod's ID followed by "_FashionMontage.lua"
-- Make sure this filename starts with an english letter --

-- INSTRUCTIONS - ADDING YOUR ITEMS --
-- Add each of your items to the list that corresponds to its BodyLocation
-- If it does not have a unique DisplayName it will not appear in the dropdown


-- This ensures the player won't get any error messages if they aren't using Fashion Montage
if getActivatedMods():contains("FashionMontage") then
  require "Definitions/_OGSN_FashionMontage"
  require "Definitions/_OGSN_FashionMontageVanillaClothes"
else
  return
end

-- pointless statement is pointless
ClothingSelectionDefinitions = ClothingSelectionDefinitions

local clothing = {
  -- these lists are named after the BodyLocation of the item
  -- If your item's BodyLocation = Hat then put it in listHat
  listHat = {
    "Base.Hat_SwatHelmet",
    "Base.Hat_PoliceRiotHelmet",
    "Base.Hat_Antibombhelmet",
  },
  listTankTop = {},
  listTshirt = {},
  listShirt = {},
  listSocks = {},
  listPants = {},
  listSkirt = {
    "Base.Trousers_Swat",
  },
  listDress = {},
  listShoes = {
    "Base.Shoes_RiotBoots",
    "Base.Shoes_SwatBoots",
  },
  listEyes = {
    "Base.Glasses_SwatGoggles",
  },
  listBeltExtra = {},
  listMask = {
    "Base.Hat_SwatGasMask",
    "Base.Hat_Balaclava_Swat",
  },
  listMaskEyes = {},
  listUnderwear = {
    "Base.AntibombSuitP2",
  },
  listFullHat = {},
  listTorso1Legs1 = {},
  listNeck = {},
  listHands = {
    "Base.Gloves_SwatGloves",
    "Base.Gloves_RiotGloves",
  },
  listLegs1 = {},
  listSweater = {
    "Base.SwatKneePads",
  },
  listJacket = {
    "Base.Jacket_Swat",
  },
  listFullSuit = {
    "Base.AntibombSuit",
    "Base.RiotArmorSuit",
  },
  listFullSuitHead = {},
  listFullTop = {},
  listBathRobe = {},
  listTorsoExtra = {
    "Base.Vest_BulletSwat",
  },
  listTail = {},
  listBack = {
    "Base.Bag_BigSwatBag",
    "Base.Bag_PoliceBag",
  },
  listScarf = {
    "Base.SwatElbowPads",
  },
}

_OGSN_FashionMontage.addClothing(clothing);
