require('NecroList');

Events.OnGameStart.Add( function ()
    print ("Adding FMJ items to NecroForge");
    if NecroList then
        print ("Necroforge added");
		if NecroList.Items.FMJLockPickingMag then
        else
            NecroList.Items.FMJLockPickingMag = {"Literature", nil, nil, "The Burglar Magazine vol. 1", "FMJ.LockPickingMag", "media/textures/Item_MagazineBlacksmith1.png", nil, nil, nil};
        end
		if NecroList.Items.FMJLockPickingMag2 then
        else
            NecroList.Items.FMJLockPickingMag2 = {"Literature", nil, nil, "The Burglar Magazine vol. 2", "FMJ.LockPickingMag2", "media/textures/Item_MagazineBlacksmith2.png", nil, nil, nil};
        end
        print ("Necroforge not found!");
    end
end)
