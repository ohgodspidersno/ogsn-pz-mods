require('NecroList');

Events.OnGameStart.Add( function ()
    print ("Adding FMJ items to NecroForge");
    if NecroList then
        print ("Necroforge added");
        if NecroList.Items.FMJBirchBark then
            else
                NecroList.Items.FMJBirchBark = {"Misc.", nil, nil, "Birch Bark", "FMJ.BirchBark", "media/textures/Item_BirchBark.png", nil, nil, nil};
            end
        if NecroList.Items.FMJDandelions then
            else
                NecroList.Items.FMJDandelions = {"Food", nil, nil, "Dandelions", "FMJ.Dandelions", "media/textures/Item_Dandelions.png", nil, nil, nil};
            end
        if NecroList.Items.FMJHerbs then
            else
                NecroList.Items.FMJHerbs = {"Food", nil, nil, "Condiment Herbs", "FMJ.Herbs", "media/textures/Item_Herbs.png", nil, nil, nil};
            end
        if NecroList.Items.FMJNettle then
            else
                NecroList.Items.FMJNettle = {"Food", nil, nil, "Nettle leaves", "FMJ.Nettle", "media/textures/Item_Nettle.png", nil, nil, nil};
            end
        if NecroList.Items.FMJTobacco then
            else
                NecroList.Items.FMJTobacco = {"Misc.", nil, nil, "Tobacco", "FMJ.Tobacco", "media/textures/Item_Tobacco.png", nil, nil, nil};
            end
        if NecroList.Items.FMJWildCarrots then
            else
                NecroList.Items.FMJWildCarrots = {"Food", nil, nil, "Wild Carrots", "FMJ.WildCarrots", "media/textures/Item_WildCarrots.png", nil, nil, nil};
            end
        if NecroList.Items.FMJWildCorn then
            else
                NecroList.Items.FMJWildCorn = {"Food", nil, nil, "Wild Corn", "FMJ.WildCorn", "media/textures/Item_WildCorn.png", nil, nil, nil};
            end
        if NecroList.Items.FMJWildPotatoes then
            else
                NecroList.Items.FMJWildPotatoes = {"Food", nil, nil, "Wild Potatoes", "FMJ.WildPotatoes", "media/textures/Item_WildPotatoes.png", nil, nil, nil};
            end
        if NecroList.Items.FMJWildWheat then
            else
                NecroList.Items.FMJWildWheat = {"Misc.", nil, nil, "Wild Wheat", "FMJ.WildWheat", "media/textures/Item_WildWheat.png", nil, nil, nil};
            end
        if NecroList.Items.FMJWheatGrains then
            else
                NecroList.Items.FMJWheatGrains = {"Food", nil, nil, "Wheat Grains", "FMJ.WheatGrains", "media/textures/Item_WheatGrains.png", nil, nil, nil};
            end
        if NecroList.Items.FMJDeadLizard then
            else
                NecroList.Items.FMJDeadLizard = {"Food", nil, nil, "Dead Lizard", "FMJ.DeadLizard", "media/textures/Item_DeadLizard.png", nil, nil, nil};
            end
        if NecroList.Items.FMJLizardMeat then
            else
                NecroList.Items.FMJLizardMeat = {"Food", nil, nil, "Lizard Meat", "FMJ.LizardMeat", "media/textures/Item_LizardMeat.png", nil, nil, nil};
            end
        if NecroList.Items.FMJDeadPheasant then
            else
                NecroList.Items.FMJDeadPheasant = {"Food", nil, nil, "Dead Pheasant", "FMJ.DeadPheasant", "media/textures/Item_DeadPheasant.png", nil, nil, nil};
            end
        if NecroList.Items.FMJPheasantMeat then
            else
                NecroList.Items.FMJPheasantMeat = {"Food", nil, nil, "Pheasant Meat", "FMJ.PheasantMeat", "media/textures/Item_PheasantMeat.png", nil, nil, nil};
            end
        if NecroList.Items.FMJDeadSnake then
            else
                NecroList.Items.FMJDeadSnake = {"Food", nil, nil, "Dead Snake", "FMJ.DeadSnake", "media/textures/Item_DeadSnake.png", nil, nil, nil};
            end
        if NecroList.Items.FMJSnakeMeat then
            else
                NecroList.Items.FMJSnakeMeat = {"Food", nil, nil, "Snake Meat", "FMJ.SnakeMeat", "media/textures/Item_SnakeMeat.png", nil, nil, nil};
            end
        if NecroList.Items.FMJOmelettes then
            else
                NecroList.Items.FMJOmelettes = {"Food", nil, nil, "Omelettes", "FMJ.Omelettes", "media/textures/Item_Omelettes.png", nil, nil, nil};
            end
        if NecroList.Items.FMJPotatoPancakes then
            else
                NecroList.Items.FMJPotatoPancakes = {"Food", nil, nil, "Potato Pancakes", "FMJ.PotatoPancakes", "media/textures/Item_PotatoPan.png", nil, nil, nil};
            end
        if NecroList.Items.FMJRollUps then
            else
                NecroList.Items.FMJRollUps = {"Food", nil, nil, "Roll Ups", "FMJ.RollUps", "media/textures/Item_RollUps.png", nil, nil, nil};
            end
        if NecroList.Items.FMJQRollUps then
            else
                NecroList.Items.FMJQRollUps = {"Food", nil, nil, "Quality Roll Ups", "FMJ.QRollUps", "media/textures/Item_QRollUps.png", nil, nil, nil};
            end
        if NecroList.Items.JarWildCarrots then
            else
                NecroList.Items.JarWildCarrots = {"Food", nil, nil, "Jar of Wild Carrots", "FMJ.JarWildCarrots", "media/textures/Item_JarBrown.png", nil, nil, nil};
            end
        if NecroList.Items.JarWildCorn then
            else
                NecroList.Items.JarWildCorn = {"Food", nil, nil, "Jar of Wild Corns", "FMJ.JarWildCorn", "media/textures/Item_JarGreen.png", nil, nil, nil};
            end
        if NecroList.Items.JarWildPotatoes then
            else
                NecroList.Items.JarWildPotatoes = {"Food", nil, nil, "Jar of Wild Potatoes", "FMJ.JarWildPotatoes", "media/textures/Item_JarWhite.png", nil, nil, nil};
            end
    else
        print ("Necroforge not found!");
    end
end)
