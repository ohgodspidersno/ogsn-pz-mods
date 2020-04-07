require('NecroList');

Events.OnGameStart.Add( function ()
    print ("Adding FMJ items to NecroForge");
    if NecroList then
        print ("Necroforge added");

		if NecroList.Items.FMJDairyMag then
        else
            NecroList.Items.FMJDairyMag = {"Literature", nil, nil, "The Dairy Magazine vol. 1", "FMJ.DairyMag", "media/textures/Item_DairyMag.png", nil, nil, nil};
        end
		if NecroList.Items.FMJDairyMag2 then
        else
            NecroList.Items.FMJDairyMag2 = {"Literature", nil, nil, "The Dairy Magazine vol. 2", "FMJ.DairyMag2", "media/textures/Item_DairyMag2.png", nil, nil, nil};
        end
		if NecroList.Items.Strainer then
        else
            NecroList.Items.Strainer = {"Misc", nil, nil, "Strainer", "FMJ.Strainer", "media/textures/Item_Strainer.png", nil, nil, nil};
        end
		if NecroList.Items.PowderedMilk then
        else
            NecroList.Items.PowderedMilk = {"Food", nil, nil, "Powdered Milk", "FMJ.PowderedMilk", "media/textures/Item_PowderedMilk.png", nil, nil, nil};
        end
		if NecroList.Items.MilkJar then
        else
            NecroList.Items.MilkJar = {"Food", nil, nil, "Jar of Milk", "FMJ.MilkJar", "media/textures/Item_MilkJar.png", nil, nil, nil};
        end
		if NecroList.Items.MilkWaterBottle then
        else
            NecroList.Items.MilkWaterBottle = {"Food", nil, nil, "Bottle of Milk", "FMJ.MilkWaterBottle", "media/textures/Item_MilkWaterBottle.png", nil, nil, nil};
        end
		if NecroList.Items.MilkPopBottle then
        else
            NecroList.Items.MilkPopBottle = {"Food", nil, nil, "Bottle of Milk", "FMJ.MilkPopBottle", "media/textures/Item_MilkPopBottle.png", nil, nil, nil};
        end
		if NecroList.Items.CheesePrep then
        else
            NecroList.Items.CheesePrep = {"Food", nil, nil, "Cheese Preparation", "FMJ.CheesePrep", "media/textures/Item_CheesePrep.png", nil, nil, nil};
        end
		if NecroList.Items.YogurtCulture then
        else
            NecroList.Items.YogurtCulture = {"Misc", nil, nil, "Yogurt Culture", "FMJ.YogurtCulture", "media/textures/Item_YogurtCulture.png", nil, nil, nil};
        end
		if NecroList.Items.YogurtPrep then
        else
            NecroList.Items.YogurtPrep = {"Food", nil, nil, "Yogurt Preparation", "FMJ.YogurtPrep", "media/textures/Item_DairyPan.png", nil, nil, nil};
        end
		if NecroList.Items.YogurtJar then
        else
            NecroList.Items.YogurtJar = {"Food", nil, nil, "Jar of Yogurt", "FMJ.YogurtJar", "media/textures/Item_YogurtJar.png", nil, nil, nil};
        end

    else
        print ("Necroforge not found!");
    end
end)
