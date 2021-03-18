-- NOTE TO MODDERS: Do NOT overwrite this file.
-- If you want to add new clothing, create a new .lua file using the
-- template I have created in media/lua/client/Definitions/YourClothingModName_FashionMontage.lua

-- This file creates empty dropdowns for all the possible BodyLocation options
-- The other lua files in this folder add items to those dropdowns

-- Create a blank slate of empty dropdowns for Male and Female

-- Define the function that will add lists of clothing, vanilla or modded, to the dropdowns

local function addClothing(clothingLists)

    local function merge_Old_New(old,new)
      local last_index = #old
      for k,v in pairs(new) do old[last_index+k] = v end;
    end

    local maleTable = ClothingSelectionDefinitions.default.Male
    local femaleTable = ClothingSelectionDefinitions.default.Female

    if clothingLists.listHat then
      local maleItems = maleTable.Hat.items;
      local femaleItems = femaleTable.Hat.items;
      merge_Old_New(maleItems,clothingLists.listHat);
      merge_Old_New(femaleItems,clothingLists.listHat);
    end
    if clothingLists.listTankTop then
      local maleItems = maleTable.TankTop.items;
      local femaleItems = femaleTable.TankTop.items;
      merge_Old_New(maleItems,clothingLists.listTankTop);
      merge_Old_New(femaleItems,clothingLists.listTankTop);
    end
    if clothingLists.listTshirt then
      local maleItems = maleTable.Tshirt.items;
      local femaleItems = femaleTable.Tshirt.items;
      merge_Old_New(maleItems,clothingLists.listTshirt);
      merge_Old_New(femaleItems,clothingLists.listTshirt);
    end
    if clothingLists.listShirt then
      local maleItems = maleTable.Shirt.items;
      local femaleItems = femaleTable.Shirt.items;
      merge_Old_New(maleItems,clothingLists.listShirt);
      merge_Old_New(femaleItems,clothingLists.listShirt);
    end
    if clothingLists.listSocks then
      local maleItems = maleTable.Socks.items;
      local femaleItems = femaleTable.Socks.items;
      merge_Old_New(maleItems,clothingLists.listSocks);
      merge_Old_New(femaleItems,clothingLists.listSocks);
    end
    if clothingLists.listPants then
      local maleItems = maleTable.Pants.items;
      local femaleItems = femaleTable.Pants.items;
      merge_Old_New(maleItems,clothingLists.listPants);
      merge_Old_New(femaleItems,clothingLists.listPants);
    end
    if clothingLists.listSkirt then
      local maleItems = maleTable.Skirt.items;
      local femaleItems = femaleTable.Skirt.items;
      merge_Old_New(maleItems,clothingLists.listSkirt);
      merge_Old_New(femaleItems,clothingLists.listSkirt);
    end
    if clothingLists.listDress then
      local maleItems = maleTable.Dress.items;
      local femaleItems = femaleTable.Dress.items;
      merge_Old_New(maleItems,clothingLists.listDress);
      merge_Old_New(femaleItems,clothingLists.listDress);
    end
    if clothingLists.listShoes then
      local maleItems = maleTable.Shoes.items;
      local femaleItems = femaleTable.Shoes.items;
      merge_Old_New(maleItems,clothingLists.listShoes);
      merge_Old_New(femaleItems,clothingLists.listShoes);
    end
    if clothingLists.listEyes then
      local maleItems = maleTable.Eyes.items;
      local femaleItems = femaleTable.Eyes.items;
      merge_Old_New(maleItems,clothingLists.listEyes);
      merge_Old_New(femaleItems,clothingLists.listEyes);
    end

    if clothingLists.listLeftEye then
      local maleItems = maleTable.LeftEye.items;
      local femaleItems = femaleTable.LeftEye.items;
      merge_Old_New(maleItems,clothingLists.listLeftEye);
      merge_Old_New(femaleItems,clothingLists.listLeftEye);
    end


    if clothingLists.listRightEye then
      local maleItems = maleTable.RightEye.items;
      local femaleItems = femaleTable.RightEye.items;
      merge_Old_New(maleItems,clothingLists.listRightEye);
      merge_Old_New(femaleItems,clothingLists.listRightEye);
    end

    if clothingLists.listBeltExtra then
      local maleItems = maleTable.BeltExtra.items;
      local femaleItems = femaleTable.BeltExtra.items;
      merge_Old_New(maleItems,clothingLists.listBeltExtra);
      merge_Old_New(femaleItems,clothingLists.listBeltExtra);
    end
    if clothingLists.listAmmoStrap then
      local maleItems = maleTable.AmmoStrap.items;
      local femaleItems = femaleTable.AmmoStrap.items;
      merge_Old_New(maleItems,clothingLists.listAmmoStrap);
      merge_Old_New(femaleItems,clothingLists.listAmmoStrap);
    end
    if clothingLists.listMask then
      local maleItems = maleTable.Mask.items;
      local femaleItems = femaleTable.Mask.items;
      merge_Old_New(maleItems,clothingLists.listMask);
      merge_Old_New(femaleItems,clothingLists.listMask);
    end
    if clothingLists.listMaskEyes then
      local maleItems = maleTable.MaskEyes.items;
      local femaleItems = femaleTable.MaskEyes.items;
      merge_Old_New(maleItems,clothingLists.listMaskEyes);
      merge_Old_New(femaleItems,clothingLists.listMaskEyes);
    end
    if clothingLists.listMaskFull then
      local maleItems = maleTable.MaskFull.items;
      local femaleItems = femaleTable.MaskFull.items;
      merge_Old_New(maleItems,clothingLists.listMaskFull);
      merge_Old_New(femaleItems,clothingLists.listMaskFull);
    end
    if clothingLists.listUnderwear then
      local maleItems = maleTable.Underwear.items;
      local femaleItems = femaleTable.Underwear.items;
      merge_Old_New(maleItems,clothingLists.listUnderwear);
      merge_Old_New(femaleItems,clothingLists.listUnderwear);
    end
    if clothingLists.listFullHat then
      local maleItems = maleTable.FullHat.items;
      local femaleItems = femaleTable.FullHat.items;
      merge_Old_New(maleItems,clothingLists.listFullHat);
      merge_Old_New(femaleItems,clothingLists.listFullHat);
    end
    if clothingLists.listTorso1Legs1 then
      local maleItems = maleTable.Torso1Legs1.items;
      local femaleItems = femaleTable.Torso1Legs1.items;
      merge_Old_New(maleItems,clothingLists.listTorso1Legs1);
      merge_Old_New(femaleItems,clothingLists.listTorso1Legs1);
    end
    if clothingLists.listNeck then
      local maleItems = maleTable.Neck.items;
      local femaleItems = femaleTable.Neck.items;
      merge_Old_New(maleItems,clothingLists.listNeck);
      merge_Old_New(femaleItems,clothingLists.listNeck);
    end
    if clothingLists.listHands then
      local maleItems = maleTable.Hands.items;
      local femaleItems = femaleTable.Hands.items;
      merge_Old_New(maleItems,clothingLists.listHands);
      merge_Old_New(femaleItems,clothingLists.listHands);
    end
    if clothingLists.listLegs1 then
      local maleItems = maleTable.Legs1.items;
      local femaleItems = femaleTable.Legs1.items;
      merge_Old_New(maleItems,clothingLists.listLegs1);
      merge_Old_New(femaleItems,clothingLists.listLegs1);
    end
    if clothingLists.listSweater then
      local maleItems = maleTable.Sweater.items;
      local femaleItems = femaleTable.Sweater.items;
      merge_Old_New(maleItems,clothingLists.listSweater);
      merge_Old_New(femaleItems,clothingLists.listSweater);
    end
    if clothingLists.listJacket then
      local maleItems = maleTable.Jacket.items;
      local femaleItems = femaleTable.Jacket.items;
      merge_Old_New(maleItems,clothingLists.listJacket);
      merge_Old_New(femaleItems,clothingLists.listJacket);
    end
    if clothingLists.listFullSuit then
      local maleItems = maleTable.FullSuit.items;
      local femaleItems = femaleTable.FullSuit.items;
      merge_Old_New(maleItems,clothingLists.listFullSuit);
      merge_Old_New(femaleItems,clothingLists.listFullSuit);
    end
    if clothingLists.listFullSuitHead then
      local maleItems = maleTable.FullSuitHead.items;
      local femaleItems = femaleTable.FullSuitHead.items;
      merge_Old_New(maleItems,clothingLists.listFullSuitHead);
      merge_Old_New(femaleItems,clothingLists.listFullSuitHead);
    end
    if clothingLists.listFullTop then
      local maleItems = maleTable.FullTop.items;
      local femaleItems = femaleTable.FullTop.items;
      merge_Old_New(maleItems,clothingLists.listFullTop);
      merge_Old_New(femaleItems,clothingLists.listFullTop);
    end
    if clothingLists.listBathRobe then
      local maleItems = maleTable.BathRobe.items;
      local femaleItems = femaleTable.BathRobe.items;
      merge_Old_New(maleItems,clothingLists.listBathRobe);
      merge_Old_New(femaleItems,clothingLists.listBathRobe);
    end
    if clothingLists.listTorsoExtra then
      local maleItems = maleTable.TorsoExtra.items;
      local femaleItems = femaleTable.TorsoExtra.items;
      merge_Old_New(maleItems,clothingLists.listTorsoExtra);
      merge_Old_New(femaleItems,clothingLists.listTorsoExtra);
    end
    if clothingLists.listTail then
      local maleItems = maleTable.Tail.items;
      local femaleItems = femaleTable.Tail.items;
      merge_Old_New(maleItems,clothingLists.listTail);
      merge_Old_New(femaleItems,clothingLists.listTail);
    end
    if clothingLists.listBack then
      local maleItems = maleTable.Back.items;
      local femaleItems = femaleTable.Back.items;
      merge_Old_New(maleItems,clothingLists.listBack);
      merge_Old_New(femaleItems,clothingLists.listBack);
    end
    if clothingLists.listScarf then
      local maleItems = maleTable.Scarf.items;
      local femaleItems = femaleTable.Scarf.items;
      merge_Old_New(maleItems,clothingLists.listScarf);
      merge_Old_New(femaleItems,clothingLists.listScarf);
    end
    -- if clothingLists.listFannyPackBack then
      -- local maleItems = maleTable.FannyPackBack.items;
      -- local femaleItems = femaleTable.FannyPackBack.items;
      -- merge_Old_New(maleItems,clothingLists.listFannyPackBack);
      -- merge_Old_New(femaleItems,clothingLists.listFannyPackBack);
    -- end
    if clothingLists.listFannyPackFront then
      local maleItems = maleTable.FannyPackFront.items;
      local femaleItems = femaleTable.FannyPackFront.items;
      merge_Old_New(maleItems,clothingLists.listFannyPackFront);
      merge_Old_New(femaleItems,clothingLists.listFannyPackFront);
    end
    if clothingLists.listNecklace then
      local maleItems = maleTable.Necklace.items;
      local femaleItems = femaleTable.Necklace.items;
      merge_Old_New(maleItems,clothingLists.listNecklace);
      merge_Old_New(femaleItems,clothingLists.listNecklace);
    end
    if clothingLists.listNecklace_Long then
      local maleItems = maleTable.Necklace_Long.items;
      local femaleItems = femaleTable.Necklace_Long.items;
      merge_Old_New(maleItems,clothingLists.listNecklace_Long);
      merge_Old_New(femaleItems,clothingLists.listNecklace_Long);
    end
    if clothingLists.listNose then
      local maleItems = maleTable.Nose.items;
      local femaleItems = femaleTable.Nose.items;
      merge_Old_New(maleItems,clothingLists.listNose);
      merge_Old_New(femaleItems,clothingLists.listNose);
    end

    if clothingLists.listLeftWrist then
      local maleItems = maleTable.LeftWrist.items;
      local femaleItems = femaleTable.LeftWrist.items;
      merge_Old_New(maleItems,clothingLists.listLeftWrist);
      merge_Old_New(femaleItems,clothingLists.listLeftWrist);
    end
    if clothingLists.listRightWrist then
      local maleItems = maleTable.RightWrist.items;
      local femaleItems = femaleTable.RightWrist.items;
      merge_Old_New(maleItems,clothingLists.listRightWrist);
      merge_Old_New(femaleItems,clothingLists.listRightWrist);
    end
    if clothingLists.listRight_RingFinger then
      local maleItems = maleTable.Right_RingFinger.items;
      local femaleItems = femaleTable.Right_RingFinger.items;
      merge_Old_New(maleItems,clothingLists.listRight_RingFinger);
      merge_Old_New(femaleItems,clothingLists.listRight_RingFinger);
    end
    if clothingLists.listLeft_RingFinger then
      local maleItems = maleTable.Left_RingFinger.items;
      local femaleItems = femaleTable.Left_RingFinger.items;
      merge_Old_New(maleItems,clothingLists.listLeft_RingFinger);
      merge_Old_New(femaleItems,clothingLists.listLeft_RingFinger);
    end
    if clothingLists.listRight_MiddleFinger then
      local maleItems = maleTable.Right_MiddleFinger.items;
      local femaleItems = femaleTable.Right_MiddleFinger.items;
      merge_Old_New(maleItems,clothingLists.listRight_MiddleFinger);
      merge_Old_New(femaleItems,clothingLists.listRight_MiddleFinger);
    end
    if clothingLists.listLeft_MiddleFinger then
      local maleItems = maleTable.Left_MiddleFinger.items;
      local femaleItems = femaleTable.Left_MiddleFinger.items;
      merge_Old_New(maleItems,clothingLists.listLeft_MiddleFinger);
      merge_Old_New(femaleItems,clothingLists.listLeft_MiddleFinger);
    end
    if clothingLists.listEars then
      local maleItems = maleTable.Ears.items;
      local femaleItems = femaleTable.Ears.items;
      merge_Old_New(maleItems,clothingLists.listEars);
      merge_Old_New(femaleItems,clothingLists.listEars);
    end
    if clothingLists.listEarTop then
      local maleItems = maleTable.EarTop.items;
      local femaleItems = femaleTable.EarTop.items;
      merge_Old_New(maleItems,clothingLists.listEarTop);
      merge_Old_New(femaleItems,clothingLists.listEarTop);
    end
end

-- Make this function available to other lua files that will add clothing to the dropdowns
_OGSN_FashionMontageBackward = _OGSN_FashionMontageBackward or {}
_OGSN_FashionMontageBackward.addClothing = addClothing
return _OGSN_FashionMontageBackward
