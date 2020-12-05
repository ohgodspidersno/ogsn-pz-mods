If you want to make your modded clothing appear in the Fashion Montage character gen menu, do the following:


Part 1 - Basic Setup
  1. Put a copy of FashionMontage/media/lua/client/Definitions/YourClothingModName_FashionMontage.lua in your mod's media/lua/client/Definitions/ folder
  2. Read the commented code in that file and follow the instructions it gives you
  3. Give the file a unique name




Part 2 (optional) - How to make an item's name in the character gen menu different from its in-game inventory name.
  For example, in the character gen menu you might want your item to be called:
    "Armor - Greaves (Titanium)[SickMods]"
    (so that it is easier for the player to read quickly)
  But then in game have the item display as:
    "Titanium Greaves"
    (so that it doesn't look obnoxious in your inventory)

  1. Give your clothing item a "WeaponSprite" attribute in your script txt file
  2. Set the WeaponSprite attribute equal to whatever you want for its dropdown menu name
  (this is a bit of a hack; the game's code allows a clothing item to have a WeaponSprite attribute but it is never used in the vanilla game, so we are "stealing it" to use here)

  e.g.:

  item TitaniumGreaves {
    ...
    DisplayName = Titanium Greaves,
    WeaponSprite = Armor - Greaves (Titanium)[SickMods]
    ...
  }




Part 3 (Only necessary if your mod adds new BodyLocations)
1. Give the new BodyLocation dropdown a name by adding a Translation file.
2. Read FashionMontage/Contents/mods/FashionMontage/media/lua/shared/Translate/important_translation_note_for_modders.txt for more instructions
