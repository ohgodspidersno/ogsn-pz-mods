
VehicleDistributions.Mysterymachine = {
       TruckBed =
       {
               rolls = 3,
               items = {
                       "Bread", 7,
                       "Steak", 4,
                       "Burger", 4,
                       "Burger", 4,
                       "Burger", 4,
                       "Burger", 4,
                       "Burger", 4,
                       "Burger", 4,
                       "Fries", 4,
                       "Fries", 4,
                       "Chicken", 3,
                       "Ham", 3,
                       "Cheese", 4,
                       "Cheese", 4,
                       "Pop", 4,
                       "Pop2", 4,
                       "Pop3", 4,
                       "PopBottle", 3,
                       "Lettuce", 3,
                       "Mustard", 3,
                       "Ketchup", 3,
                       "Processedcheese", 3,
                       "Processedcheese", 3,
                       "farming.Cabbage", 4,
                       "farming.Bacon", 4,
                       "farming.Bacon", 4,
               }
       },

       GloveBox =
       {
               rolls = 3,
               items = {
                       "Bread", 7,
                       "Steak", 4,
                       "Burger", 4,
                       "Burger", 4,
                       "Burger", 4,
                       "Burger", 4,
                       "Burger", 4,
                       "Burger", 4,
                       "Fries", 4,
                       "Fries", 4,
                       "Chicken", 3,
                       "Ham", 3,
                       "Cheese", 4,
                       "Cheese", 4,
                       "Pop", 4,
                       "Pop2", 4,
                       "Pop3", 4,
                       "PopBottle", 3,
                       "Lettuce", 3,
                       "Mustard", 3,
                       "Ketchup", 3,
                       "Processedcheese", 3,
                       "Processedcheese", 3,
                       "farming.Cabbage", 4,
                       "farming.Bacon", 4,
                       "farming.Bacon", 4,
               }
       },



local distributionTable = {
...
       -- Mysterymachine
       VanMysterymachine = { Normal = VehicleDistributions.Mysterymachine; },
 }
 table.insert(VehicleDistributions, 1, distributionTable);
