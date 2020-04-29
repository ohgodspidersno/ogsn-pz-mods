require('NecroList');

Events.OnGameStart.Add( function ()
    print ("Adding FMJ items to NecroForge");
    if NecroList then
        print ("Necroforge added");

        -- Wild Food Mod adds these animals: Lizard, Pheasant, Snake
        -- Specifically it adds these items: FMJDeadLizard, FMJLizardMeat, FMJDeadPheasant, FMJPheasantMeat, FMJDeadSnake, FMJSnakeMeat
        if getActivatedMods():contains("ForkMJfoodWild") then
          if NecroList.Items.JarLizard then
              else
                  NecroList.Items.JarLizard = {"Food", nil, nil, "Jar of Lizard Meats", "FMJ.JarLizard", "media/textures/Item_JarWhite.png", nil, nil, nil};
              end
          if NecroList.Items.JarPheasant then
              else
                  NecroList.Items.JarPheasant = {"Food", nil, nil, "Jar of Pheasant Meats", "FMJ.JarPheasant", "media/textures/Item_MeatJar.png", nil, nil, nil};
              end
          if NecroList.Items.JarSnake then
              else
                  NecroList.Items.JarSnake = {"Food", nil, nil, "Jar of Snake Meats", "FMJ.JarSnake", "media/textures/Item_JarWhite.png", nil, nil, nil};
              end
        end


        -- Vanilla --
        if NecroList.Items.JarChicken then
            else
                NecroList.Items.JarChicken = {"Food", nil, nil, "Jar of Chickens", "FMJ.JarChicken", "media/textures/Item_JarWhite.png", nil, nil, nil};
            end
        if NecroList.Items.JarSteak then
            else
                NecroList.Items.JarSteak = {"Food", nil, nil, "Jar of Steaks", "FMJ.JarSteak", "media/textures/Item_MeatJar.png", nil, nil, nil};
            end
        if NecroList.Items.JarFrogMeat then
            else
                NecroList.Items.JarFrogMeat = {"Food", nil, nil, "Jar of Frog Meats", "FMJ.JarFrogMeat", "media/textures/Item_JarWhite.png", nil, nil, nil};
            end
        if NecroList.Items.JarMeatPatty then
            else
                NecroList.Items.JarMeatPatty = {"Food", nil, nil, "Jar of Meat Patties", "FMJ.JarMeatPatty", "media/textures/Item_MeatJar.png", nil, nil, nil};
            end
        if NecroList.Items.JarMuttonChop then
            else
                NecroList.Items.JarMuttonChop = {"Food", nil, nil, "Jar of Mutton Chops", "FMJ.JarMuttonChop", "media/textures/Item_MeatJar.png", nil, nil, nil};
            end
        if NecroList.Items.JarPorkChop then
            else
                NecroList.Items.JarPorkChop = {"Food", nil, nil, "Jar of Pork Chops", "FMJ.JarPorkChop", "media/textures/Item_MeatJar.png", nil, nil, nil};
            end
        if NecroList.Items.JarRabbitmeat then
            else
                NecroList.Items.JarRabbitmeat = {"Food", nil, nil, "Jar of Rabbit Meats", "FMJ.JarRabbitmeat", "media/textures/Item_MeatJar.png", nil, nil, nil};
            end
        if NecroList.Items.JarSmallanimalmeat then
            else
                NecroList.Items.JarSmallanimalmeat = {"Food", nil, nil, "Jar of Small Animal Meats", "FMJ.JarSmallanimalmeat", "media/textures/Item_MeatJar.png", nil, nil, nil};
            end
        if NecroList.Items.JarSmallbirdmeat then
            else
                NecroList.Items.JarSmallbirdmeat = {"Food", nil, nil, "Jar of Small Bird Meats", "FMJ.JarSmallbirdmeat", "media/textures/Item_MeatJar.png", nil, nil, nil};
            end
        if NecroList.Items.JarSalmon then
            else
                NecroList.Items.JarSalmon = {"Food", nil, nil, "Jar of Salmons", "FMJ.JarSalmon", "media/textures/Item_JarBrown.png", nil, nil, nil};
            end
    else
        print ("Necroforge not found!");
    end
end)
