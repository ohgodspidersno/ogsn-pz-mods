-- INSTRUCTIONS - NAMING THE FILE --
-- Rename this file, ideally your mod's ID followed by "_FashionMontage.lua"
-- Make sure this filename starts with an english letter --

-- INSTRUCTIONS - ADDING YOUR ITEMS --
-- Add each of your items to the list that corresponds to its BodyPart
-- If it does not have a unique DisplayName it will not appear in the dropdown


-- This ensures the player won't get any error messages if they aren't using Fashion Montage
if getActivatedMods():contains("FashionMontage") then
  require "Definitions/_OGSN_FashionMontage"
else
  return
end

-- pointless statement is pointless
ClothingSelectionDefinitions = ClothingSelectionDefinitions

local clothing = {
  -- these lists are named after the BodyPart of the item
  -- If your item's BodyPart = Hat then put it in listHat
  listHat = {
    -- "MyModule.MyNewHat",
  },
  listTankTop = {},     -- Remember,
  listTshirt = {},      -- if
  listShirt = {},       -- your
  listSocks = {},       -- item
  listPants = {},       -- doesn't
  listSkirt = {},       -- have
  listDress = {},       -- a
  listShoes = {},       -- unique
  listEyes = {},        -- DisplayName
  listBeltExtra = {},   -- it
  listMask = {},        -- will
  listMaskEyes = {},    -- not
  listUnderwear = {},   -- appear
  listFullHat = {},     -- in
  listTorso1Legs1 = {}, -- the
  listNeck = {},        -- dropdowns
  listHands = {},
  listLegs1 = {},
  listSweater = {},     -- Do
  listJacket = {},      -- not
  listFullSuit = {},    -- rename
  listFullSuitHead = {},-- any
  listFullTop = {},     -- functions
  listBathRobe = {},    -- or
  listTorsoExtra = {},  -- lists
  listTail = {},        -- in
  listBack = {},        -- this
  listScarf = {},       -- file
}


_OGSN_FashionMontage.addClothing(clothing);
