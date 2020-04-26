require('NecroList');

Events.OnGameStart.Add( function ()
    print ("Adding FMJ items to NecroForge");
    if NecroList then
        print ("Necroforge added");
		if NecroList.Items.BobbyPin then
        else
            NecroList.Items.BobbyPin = {"Normal", nil, nil, "Hairpin", "FMJ.BobbyPin", "media/textures/Item_BobbyPin.png", nil, nil, nil};
        end
    if NecroList.Items.LockPickingMag then
        else
            NecroList.Items.LockPickingMag = {"Literature", nil, nil, "Locksmith's Handbook Vol. 1", "FMJ.LockPickingMag", "media/textures/Item_magazine_Lock_01.png", nil, nil, nil};
        end
		if NecroList.Items.LockPickingMag2 then
        else
            NecroList.Items.LockPickingMag2 = {"Literature", nil, nil, "Locksmith's Handbook Vol. 2", "FMJ.LockPickingMag2", "media/textures/Item_magazine_Lock_02.png", nil, nil, nil};
        end
        print ("Necroforge not found!");
    end
end)
