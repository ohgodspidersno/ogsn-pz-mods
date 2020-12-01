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
  -- as long as you also include the new bodyLocation's name
  -- in the next array (see below)
}

local bodyLocations = {
  -- if your mod adds brand new bodyLocations, list each of them here as strings
  -- for example:
  -- "KneePads",
  -- "ThirdArm",
  -- "SidewaysBaseballCap",
}

_OGSN_FashionMontage.addClothingItems(clothing);
_OGSN_FashionMontage.addBodyLocations(bodyLocations);
