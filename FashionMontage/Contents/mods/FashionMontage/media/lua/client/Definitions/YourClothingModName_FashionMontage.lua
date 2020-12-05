-- INSTRUCTIONS - NAMING THE FILE --
-- Rename this file, ideally your mod's ID followed by "_FashionMontage.lua"
-- Make sure this filename starts with an english letter --

-- INSTRUCTIONS - ADDING YOUR ITEMS --
-- Add each of your items to the list that corresponds to its BodyLocation

-- INSTRUCTIONS - HOW THE ITEM IS NAMED IN DROPDOWN MENU
-- WARNING: An item's dropdown menu name MUST BE UNIQUE (not shared by any other item already added to the dropdown menu) or it will not be added to the menu!!!

-- How to assign its dropdown menu name:
-- In your script file, assign it a parameter "WeaponSprite" with a string value.
-- Whatever you choose will be how it shows up in the dropdown menu.
-- Once in-game, the item will have its normal DisplayName


-- example:
-- ## media/scripts/modded_clothing_items.txt ## --
--
-- item TitaniumGreaves {
--   ...
--   DisplayName = Titanium Greaves,
--   WeaponSprite = Armor - Greaves (Titanium)[SickMods]
--   ...
-- }

-- This item in game will be called
--        "Titanium Greaves"
-- But in its character gen dropdown menu it will be called
--        "Armor - Greaves (Titanium)[SickMods]"

-- If WeaponSprite is not defined, it will try its normal DisplayName (DisplayName is sampled AFTER it has been changed by lua/shared/Translation/ files)



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
  -- If your item's BodyLocation = Hat then put it in "Hat"
  Hat = {
    -- "MyModule.MyNewHat",
  },
  TankTop = {},     -- Remember,
  Tshirt = {},      -- if
  Shirt = {},       -- your
  Socks = {},       -- item
  Pants = {},       -- doesn't
  Skirt = {},       -- have
  Dress = {},       -- a
  Shoes = {},       -- unique
  Eyes = {},        -- DisplayName
  LeftEye = {},
  RightEye = {},
  BeltExtra = {},   -- it
  AmmoStrap = {},
  Mask = {},        -- will
  MaskEyes = {},    -- not
  Underwear = {},   -- appear
  FullHat = {},     -- in
  Torso1Legs1 = {}, -- the
  Neck = {},        -- dropdowns
  Hands = {},
  Legs1 = {},
  Sweater = {},     -- Do
  Jacket = {},      -- not
  FullSuit = {},    -- rename
  FullSuitHead = {},-- any
  FullTop = {},     -- functions
  BathRobe = {},    -- or
  TorsoExtra = {},  -- lists
  Tail = {},        -- in
  Back = {},        -- this
  Scarf = {},       -- file
  FannyPackFront = {},
  Necklace = {},
  Necklace_Long = {},
  Nose = {},
  LeftWrist = {},
  RightWrist = {},
  Right_RingFinger = {},
  Left_RingFinger = {},
  Right_MiddleFinger = {},
  Left_MiddleFinger = {},
  Ears = {},
  EarTop = {},
  MaskFull = {},
  -- If your mod adds new bodylocations, you can include its items here
  -- as long as you also include the new BodyLocation's name
  -- in the next array (see below)
}

local bodyLocations = {
  -- if your mod adds brand new bodyLocations, list each of them here as strings
  -- for example:
  -- "KneePads",
  -- "ThirdArm",
  -- "SidewaysBaseballCap",

  -- IMPORTANT NOTE: If you add BodyLocations you'll also have to add a translation txt file
  -- otherwise it will show up in the menu as UI_ClothingType_NewBodyLocationName
  -- Please add it for as many languages as you can. Check out the lua/shared/Translate folder for reference

  -- lua/shared/Translate/note_to_modders.txt will tell you which encoding to use for each language
}

if #bodyLocations > 0 then
  _OGSN_FashionMontage.addBodyLocations(bodyLocations);
end

_OGSN_FashionMontage.addClothingItems(clothing);
