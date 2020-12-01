-- NOTE TO MODDERS: Do NOT overwrite this file.
-- If you want to add new clothing, create a new .lua file using the
-- template I have created in media/lua/client/Definitions/YourClothingModName_FashionMontage.lua

-- This file creates empty dropdowns for all the possible BodyLocation options
-- The other lua files in this folder add items to those dropdowns

-- Create a blank slate of empty dropdowns for Male and Female

local function merge_Old_New(old, new)
  local last_index = #old
  for k, v in pairs(new) do
    if not old[v] then
      old[last_index + k] = v
    end
  end;
end


allBodyLocations = allBodyLocations or {}

local vanillaBodyLocations = {
  "Hat",
  "TankTop",
  "Tshirt",
  "Shirt",
  "Socks",
  "Pants",
  "Skirt",
  "Dress",
  "Shoes",
  "Eyes",
  "LeftEye",
  "RightEye",
  "BeltExtra",
  "AmmoStrap",
  "Mask",
  "MaskEyes",
  "MaskFull",
  "Underwear",
  "FullHat",
  "Torso1Legs1",
  "Neck",
  "Hands",
  "Legs1",
  "Sweater",
  "Jacket",
  "FullSuit",
  "FullSuitHead",
  "FullTop",
  "BathRobe",
  "TorsoExtra",
  "Tail",
  "Back",
  "Scarf",
  "FannyPackFront",
  "Necklace",
  "Necklace_Long",
  "Nose",
  "LeftWrist",
  "RightWrist",
  "Right_RingFinger",
  "Left_RingFinger",
  "Right_MiddleFinger",
  "Left_MiddleFinger",
  "Ears",
  "EarTop",
}
local DTbodyLocations = {
  "SkeletonSuit",
  "SlendermanSuit",
  "Torso1",
  "ShortSleeveShirt",
  "Legs5",
  "ShirtUntucked",
  "BodyCostume",
  "Billboard",
}
local PLLbodyLocations = {
  "Pupils",
  "Wig",
  "Belt419",
  "Belt420",
  "TorsoRig",
  "waistbags",
  "waistbagsComplete",
  "waistbagsf",
  "Kneepads",
}

local function addBodyLocations(bodyLocationList)
  merge_Old_New = merge_Old_New
  local bodyLocationList = bodyLocationList or {}
  for k, v in pairs(bodyLocationList) do
    ClothingSelectionDefinitions.default["Male"][v] = {}
    ClothingSelectionDefinitions.default["Male"][v]["items"] = {}
    ClothingSelectionDefinitions.default["Male"][v]["chance"] = 20
    ClothingSelectionDefinitions.default["Female"][v] = {}
    ClothingSelectionDefinitions.default["Female"][v]["items"] = {}
    ClothingSelectionDefinitions.default["Female"][v]["chance"] = 20
  end
  merge_Old_New(allBodyLocations, bodyLocationList)
end

addBodyLocations(vanillaBodyLocations)

if getActivatedMods():contains("DressingTime") then
  addBodyLocations(DTbodyLocations)
end

if getActivatedMods():contains("PLLoot") then
  addBodyLocations(PLLbodyLocations)
end

-- Make the default starting outfit something really basic and easy for the player to replace
ClothingSelectionDefinitions.starting = {}
ClothingSelectionDefinitions.starting.Male = {}
ClothingSelectionDefinitions.starting.Female = {}

ClothingSelectionDefinitions.starting.Male.Shoes = {chance = 100, items = {"Base.Shoes_TrainerTINT"}}
ClothingSelectionDefinitions.starting.Male.TankTop = {chance = 100, items = {"Base.Vest_DefaultTEXTURE_TINT"}}
ClothingSelectionDefinitions.starting.Male.Socks = {chance = 100, items = {"Base.Socks_Ankle"}}
ClothingSelectionDefinitions.starting.Male.Pants = {chance = 100, items = {"Base.Trousers_WhiteTINT"}}

ClothingSelectionDefinitions.starting.Female.Shoes = {chance = 100, items = {"Base.Shoes_TrainerTINT"}}
ClothingSelectionDefinitions.starting.Female.TankTop = {chance = 100, items = {"Base.Vest_DefaultTEXTURE_TINT"}}
ClothingSelectionDefinitions.starting.Female.Socks = {chance = 100, items = {"Base.Socks_Ankle"}}
ClothingSelectionDefinitions.starting.Female.Pants = {chance = 100, items = {"Base.Trousers_WhiteTINT"}}

-- Define the function that will add lists of clothing, vanilla or modded, to the dropdowns
local function addClothingItems(clothingLists)
  merge_Old_New = merge_Old_New
  local maleTable = ClothingSelectionDefinitions.default["Male"]
  local femaleTable = ClothingSelectionDefinitions.default["Female"]

  for k, v in pairs(clothingLists) do
    print('in k,v in pairs clothingLists do')
    print('k and v:')
    local locationName = k
    local locationItemsTable = v
    print(k)
    print(v)
    print('#locationItemsTable')
    print(#locationItemsTable)
    if locationItemsTable and #locationItemsTable > 0 then
      local maleItems = maleTable[locationName]["items"];
      local femaleItems = femaleTable[locationName]["items"];
      merge_Old_New(maleItems, locationItemsTable);
      merge_Old_New(femaleItems, locationItemsTable);
    end
  end
end

-- Make this function available to other lua files that will add clothing to the dropdowns
require "Definitions/_OGSN_FashionMontageBackward"
_OGSN_FashionMontage = _OGSN_FashionMontage or {}
_OGSN_FashionMontage.addBodyLocations = addBodyLocations
_OGSN_FashionMontage.addClothingItems = addClothingItems
_OGSN_FashionMontage.addClothing = _OGSN_FashionMontageBackward.addClothing
return _OGSN_FashionMontage
