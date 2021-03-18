If you want to make your modded clothing appear in the Fashion Montage character gen menu, do the following:

Part 1:
1. Put a copy of FashionMontage/media/lua/client/Definitions/YourClothingModName_FashionMontage.lua in your mod's media/lua/client/Definitions/ folder
2. Read the commented code in that file and follow the instructions it gives you
3. Give the file a unique name

Part 2 (Only necessary if your mod adds new BodyLocations)
1. Give the new BodyLocation dropdown a name by adding a Translation file.
2. Read FashionMontage/Contents/mods/FashionMontage/media/lua/shared/Translate/important_translation_note_for_modders.txt for more instructions


Important Note:
- If your item does not have a unique DisplayName it will not appear in the list
