-- INSTRUCTIONS - NAMING THE FILE --
-- rename this file "items_" followed by some identifier unique to your mod --
-- IMPORTANT NOTE #1: Make sure this filename starts with an english letter --

-- INSTRUCTIONS - ADDING YOUR ITEMS --
-- Add your items to the appropriate BodyPart list. Make sure you put it in the correct
-- body part list. They're named after the BodyPart designations that the game uses
-- IMPORTANT NOTE #2: Make sure that your item has a totally unique DisplayName.
-- If it has the same DisplayName as a previous item the game will not add it
-- as an option to the character generator, because it will think it's already there.

require "Definitions/_items_OGSNfashionMontage"
ClothingSelectionDefinitions = ClothingSelectionDefinitions

local listHat = {
  -- "moduleName.Modded_Example_Hat_Item",
}
local listTankTop = {
  -- "moduleName.Modded_Example_Tanktop_Item",
}

local listTshirt = {}
local listShirt = {}
local listSocks = {}
local listPants = {}
local listSkirt = {}
local listDress = {}
local listShoes = {}
local listEyes = {}
local listBeltExtra = {}
local listMask = {}
local listMaskEyes = {}
local listUnderwear = {}
local listFullHat = {}
local listTorso1Legs1 = {}
local listNeck = {}
local listHands = {}
local listLegs1 = {}
local listSweater = {}
local listSweaterHat = {}
local listJacket = {}
local listJacketHat = {}
local listFullSuit = {}
local listFullSuitHead = {}
local listFullTop = {}
local listBathRobe = {}
local listTorsoExtra = {}
local listTail = {}
local listBack = {}
local listScarf = {}

-- table.insert(SuburbsDistributions["cafekitchen"]["all"].items, 5);

if next(listHat) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["Hat"].items,listHat);
  -- table.insert(ClothingSelectionDefinitions["default"]["Male"]["Hat"].chance,0);
end
if next(listTankTop) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["TankTop"].items,listTankTop);
  -- table.insert(ClothingSelectionDefinitions["default"]["Male"]["TankTop"].chance,0);
end
if next(listTshirt) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["Tshirt"].items,listTshirt);
  -- table.insert(ClothingSelectionDefinitions["default"]["Male"]["Tshirt"].chance,0);
end
if next(listShirt) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["Shirt"].items,listShirt);
  -- table.insert(ClothingSelectionDefinitions["default"]["Male"]["Shirt"].chance,0);
end
if next(listSocks) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["Socks"].items,listSocks);
  -- table.insert(ClothingSelectionDefinitions["default"]["Male"]["Socks"].chance,0);
end
if next(listPants) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["Pants"].items,listPants);
  -- table.insert(ClothingSelectionDefinitions["default"]["Male"]["Pants"].chance,0);
end
if next(listSkirt) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["Skirt"].items,listSkirt);
  -- table.insert(ClothingSelectionDefinitions["default"]["Male"]["Skirt"].chance,0);
end
if next(listDress) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["Dress"].items,listDress);
  -- table.insert(ClothingSelectionDefinitions["default"]["Male"]["Dress"].chance,0);
end
if next(listShoes) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["Shoes"].items,listShoes);
  -- table.insert(ClothingSelectionDefinitions["default"]["Male"]["Shoes"].chance,0);
end
if next(listEyes) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["Eyes"].items,listEyes);
  -- table.insert(ClothingSelectionDefinitions["default"]["Male"]["Eyes"].chance,0);
end
if next(listBeltExtra) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["BeltExtra"].items,listBeltExtra);
  -- table.insert(ClothingSelectionDefinitions["default"]["Male"]["BeltExtra"].chance,0);
end
if next(listMask) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["Mask"].items,listMask);
  -- table.insert(ClothingSelectionDefinitions["default"]["Male"]["Mask"].chance,0);
end
if next(listMaskEyes) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["MaskEyes"].items,listMaskEyes);
  -- table.insert(ClothingSelectionDefinitions["default"]["Male"]["MaskEyes"].chance,0);
end
if next(listUnderwear) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["Underwear"].items,listUnderwear);
  -- table.insert(ClothingSelectionDefinitions["default"]["Male"]["Underwear"].chance,0);
end
if next(listFullHat) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["FullHat"].items,listFullHat);
  -- table.insert(ClothingSelectionDefinitions["default"]["Male"]["FullHat"].chance,0);
end
if next(listTorso1Legs1) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["Torso1Legs1"].items,listTorso1Legs1);
  -- table.insert(ClothingSelectionDefinitions["default"]["Male"]["Torso1Legs1"].chance,0);
end
if next(listNeck) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["Neck"].items,listNeck);
  -- table.insert(ClothingSelectionDefinitions["default"]["Male"]["Neck"].chance,0);
end
if next(listHands) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["Hands"].items,listHands);
  -- table.insert(ClothingSelectionDefinitions["default"]["Male"]["Hands"].chance,0);
end
if next(listLegs1) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["Legs1"].items,listLegs1);
  -- table.insert(ClothingSelectionDefinitions["default"]["Male"]["Legs1"].chance,0);
end
if next(listSweater) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["Sweater"].items,listSweater);
  -- table.insert(ClothingSelectionDefinitions["default"]["Male"]["Sweater"].chance,0);
end
if next(listJacket) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["Jacket"].items,listJacket);
  -- table.insert(ClothingSelectionDefinitions["default"]["Male"]["Jacket"].chance,0);
end
if next(listFullSuit) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["FullSuit"].items,listFullSuit);
  -- table.insert(ClothingSelectionDefinitions["default"]["Male"]["FullSuit"].chance,0);
end
if next(listFullSuitHead) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["FullSuitHead"].items,listFullSuitHead);
  -- table.insert(ClothingSelectionDefinitions["default"]["Male"]["FullSuitHead"].chance,0);
end
if next(listFullTop) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["FullTop"].items,listFullTop);
  -- table.insert(ClothingSelectionDefinitions["default"]["Male"]["FullTop"].chance,0);
end
if next(listBathRobe) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["BathRobe"].items,listBathRobe);
  -- table.insert(ClothingSelectionDefinitions["default"]["Male"]["BathRobe"].chance,0);
end
if next(listTorsoExtra) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["TorsoExtra"].items,listTorsoExtra);
  -- table.insert(ClothingSelectionDefinitions["default"]["Male"]["TorsoExtra"].chance,0);
end
if next(listTail) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["Tail"].items,listTail);
  -- table.insert(ClothingSelectionDefinitions["default"]["Male"]["Tail"].chance,0);
end
if next(listBack) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["Back"].items,listBack);
  -- table.insert(ClothingSelectionDefinitions["default"]["Male"]["Back"].chance,0);
end
if next(listScarf) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Male"]["Scarf"].items,listScarf);
  -- table.insert(ClothingSelectionDefinitions["default"]["Male"]["Scarf"].chance,0);
end
if next(listHat) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["Hat"].items,listHat);
  -- table.insert(ClothingSelectionDefinitions["default"]["Female"]["Hat"].chance,0);
end
if next(listTankTop) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["TankTop"].items,listTankTop);
  -- table.insert(ClothingSelectionDefinitions["default"]["Female"]["TankTop"].chance,0);
end
if next(listTshirt) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["Tshirt"].items,listTshirt);
  -- table.insert(ClothingSelectionDefinitions["default"]["Female"]["Tshirt"].chance,0);
end
if next(listShirt) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["Shirt"].items,listShirt);
  -- table.insert(ClothingSelectionDefinitions["default"]["Female"]["Shirt"].chance,0);
end
if next(listSocks) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["Socks"].items,listSocks);
  -- table.insert(ClothingSelectionDefinitions["default"]["Female"]["Socks"].chance,0);
end
if next(listPants) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["Pants"].items,listPants);
  -- table.insert(ClothingSelectionDefinitions["default"]["Female"]["Pants"].chance,0);
end
if next(listSkirt) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["Skirt"].items,listSkirt);
  -- table.insert(ClothingSelectionDefinitions["default"]["Female"]["Skirt"].chance,0);
end
if next(listDress) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["Dress"].items,listDress);
  -- table.insert(ClothingSelectionDefinitions["default"]["Female"]["Dress"].chance,0);
end
if next(listShoes) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["Shoes"].items,listShoes);
  -- table.insert(ClothingSelectionDefinitions["default"]["Female"]["Shoes"].chance,0);
end
if next(listEyes) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["Eyes"].items,listEyes);
  -- table.insert(ClothingSelectionDefinitions["default"]["Female"]["Eyes"].chance,0);
end
if next(listBeltExtra) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["BeltExtra"].items,listBeltExtra);
  -- table.insert(ClothingSelectionDefinitions["default"]["Female"]["BeltExtra"].chance,0);
end
if next(listMask) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["Mask"].items,listMask);
  -- table.insert(ClothingSelectionDefinitions["default"]["Female"]["Mask"].chance,0);
end
if next(listMaskEyes) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["MaskEyes"].items,listMaskEyes);
  -- table.insert(ClothingSelectionDefinitions["default"]["Female"]["MaskEyes"].chance,0);
end
if next(listUnderwear) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["Underwear"].items,listUnderwear);
  -- table.insert(ClothingSelectionDefinitions["default"]["Female"]["Underwear"].chance,0);
end
if next(listFullHat) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["FullHat"].items,listFullHat);
  -- table.insert(ClothingSelectionDefinitions["default"]["Female"]["FullHat"].chance,0);
end
if next(listTorso1Legs1) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["Torso1Legs1"].items,listTorso1Legs1);
  -- table.insert(ClothingSelectionDefinitions["default"]["Female"]["Torso1Legs1"].chance,0);
end
if next(listNeck) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["Neck"].items,listNeck);
  -- table.insert(ClothingSelectionDefinitions["default"]["Female"]["Neck"].chance,0);
end
if next(listHands) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["Hands"].items,listHands);
  -- table.insert(ClothingSelectionDefinitions["default"]["Female"]["Hands"].chance,0);
end
if next(listLegs1) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["Legs1"].items,listLegs1);
  -- table.insert(ClothingSelectionDefinitions["default"]["Female"]["Legs1"].chance,0);
end
if next(listSweater) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["Sweater"].items,listSweater);
  -- table.insert(ClothingSelectionDefinitions["default"]["Female"]["Sweater"].chance,0);
end
if next(listJacket) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["Jacket"].items,listJacket);
  -- table.insert(ClothingSelectionDefinitions["default"]["Female"]["Jacket"].chance,0);
end
if next(listFullSuit) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["FullSuit"].items,listFullSuit);
  -- table.insert(ClothingSelectionDefinitions["default"]["Female"]["FullSuit"].chance,0);
end
if next(listFullSuitHead) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["FullSuitHead"].items,listFullSuitHead);
  -- table.insert(ClothingSelectionDefinitions["default"]["Female"]["FullSuitHead"].chance,0);
end
if next(listFullTop) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["FullTop"].items,listFullTop);
  -- table.insert(ClothingSelectionDefinitions["default"]["Female"]["FullTop"].chance,0);
end
if next(listBathRobe) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["BathRobe"].items,listBathRobe);
  -- table.insert(ClothingSelectionDefinitions["default"]["Female"]["BathRobe"].chance,0);
end
if next(listTorsoExtra) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["TorsoExtra"].items,listTorsoExtra);
  -- table.insert(ClothingSelectionDefinitions["default"]["Female"]["TorsoExtra"].chance,0);
end
if next(listTail) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["Tail"].items,listTail);
  -- table.insert(ClothingSelectionDefinitions["default"]["Female"]["Tail"].chance,0);
end
if next(listBack) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["Back"].items,listBack);
  -- table.insert(ClothingSelectionDefinitions["default"]["Female"]["Back"].chance,0);
end
if next(listScarf) ~= nil then
  table.insert(ClothingSelectionDefinitions["default"]["Female"]["Scarf"].items,listScarf);
  -- table.insert(ClothingSelectionDefinitions["default"]["Female"]["Scarf"].chance,0);
end
