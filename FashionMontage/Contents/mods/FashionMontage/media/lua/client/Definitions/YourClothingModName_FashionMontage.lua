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

_OGSN_FashionMontage.addClothingItems(clothing);
if #bodyLocations > 0 then
  _OGSN_FashionMontage.addBodyLocations(bodyLocations);
end
