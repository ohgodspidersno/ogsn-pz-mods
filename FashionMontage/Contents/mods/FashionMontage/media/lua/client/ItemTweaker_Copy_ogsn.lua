-- This is a direct copy of the DarkSlayerEX's Iteam Tweaker API mod.
-- I am including a renamed version of it in my mods primarily so that they are not dependent on another mod that may be removed, deprecated, or abandoned. Secondarily, the IWBUMS switch has made it so that mods with a lot of dependencies seem more fragile, and I selfishly want my mods to be self-contained.
-- All credit goes to DarkSlayerEX, and I am extremely grateful for this elegant and easy-to-use tool that he's given to the modding community. Thank you.

-- DarkSlayerEX's Item Tweaker Core: an API for tweaking existing items without redefining them entirely.
--Initializes the tables needed for the code to run
if not ogsnItemTweaker then  ogsnItemTweaker = {} end
if not OGSNTweakItem then  OGSNTweakItem = {} end
if not OGSNTweakItemData then  OGSNTweakItemData = {} end

--Prep code to make the changes to all item in the OGSNTweakItemData table.
function ogsnItemTweaker.tweakItems()
	local item;
	for k,v in pairs(OGSNTweakItemData) do
		for t,y in pairs(v) do
			item = ScriptManager.instance:getItem(k);
			if item ~= nil then
				item:DoParam(t.." = "..y);
				print(k..": "..t..", "..y);
			end
		end
	end
end

function OGSNTweakItem(itemName, itemProperty, propertyValue)
	if not OGSNTweakItemData[itemName] then
		OGSNTweakItemData[itemName] = {};
	end
	OGSNTweakItemData[itemName][itemProperty] = propertyValue;
end

-- this function adds to the existing value instead of replacing it entirely
function OGSNTweakItemAdditive(itemName, itemProperty, propertyValue)
	if not OGSNTweakItemData[itemName] then
		OGSNTweakItemData[itemName] = {};
	end
	local old_property = OGSNTweakItemData[itemName][itemProperty]
	local new_property = old_property.. ";"..propertyValue
	OGSNTweakItemData[itemName][itemProperty] = new_property;
end

Events.OnGameBoot.Add(ogsnItemTweaker.tweakItems)


--[[
-------------------------------------------------
--------------------IMPORTANT--------------------
-------------------------------------------------
You should be able to modify any aspect of an item such as: DisplayName, DisplayCategory, Weight, Icon, StressReduction, HungerChange
		HOWEVER
DO NOT MODIFY AN ITEM'S TYPE UNLESS YOU WANT PLAYERS TO START A NEW WORLD. ITEMS WITH THEIR TYPES CHANGED ARE DELETED.
If you have a workaround for this in place however, then it should be okay.

You can make compatibility patches, allowing tweaks to only be applied under the proper circumstances.
Examples:


		OGSNTweakItemData["MyMod.MyItem"] = { ["DisplayCategory"] = "Weapon" };

		if getActivatedMods():contains("CustomCategories") then
			OGSNTweakItemData["MyMod.MyItem"] = { ["DisplayCategory"] = "BluntWeapon" };
		end

and

		OGSNTweakItemData["MyMod.Book"] = { ["Weight"] = "0.8" };

		if getActivatedMods():contains("WeightlessBooks") then
			OGSNTweakItemData["MyMod.Book"] = { ["Weight"] = "0" };
		end

]]
