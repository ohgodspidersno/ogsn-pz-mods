require "ISUI/CheatCore"
--require "ISUI/crucibleUI/crucibleMain"
require "ISUI/compassUI/compassMain"


ISUICheatMenu = ISUICheatMenu or {}; -- Acecool
ISUICheatMenu._index = ISUICheatMenu

local versionNumber = tonumber(string.match(getCore():getVersionNumber(), "%d+"))
--[[
--
-- Helper function to simplify populating the compass entries... = Josh 'Acecool' Moser
--
function CheatCoreCM:PopulateCompassPresets( _context, _menu, _teleport )
	-- For each
	for town, locations in pairs( self.CompassPresets ) do
		local _option = _menu:addOption( ( self.Language.Towns[ town ] or town ) .. "...", worldobjects, nil);
		local _menu = _menu:getNew( _menu );
		_context:addSubMenu( _option, _menu );

		-- For each of the locations we read location name, x and y...
		for k, location in pairs( locations ) do
			local _name = location.Name;
			local _x, _y, _z = location.X, location.Y, location.Z;
			_menu:addOption( ( self.Language.Towns[ _name ] or _name ), worldobjects, function( )
				self.markHome( nil, _name, _x, _y, _z, ( _teleport or false ) );
			end );
		end
	end
end
--]]
function ISUICheatMenu:createTerraformMenu()
	local context, subMenu = self.context, self.subMenu
	--local DoNotDeleteFloorOption = subMenuDelete:addOption("Toggle Do Not Delete Floor Mode", worldobjects, function() CheatCoreCM.HandleToggle("Do Not Delete Floor", "CheatCoreCM.DoNotDeleteFloor", "CheatCoreCM.HandleCheck('CheatCoreCM.IsDelete', 'Delete Mode')", "if CheatCoreCM.IsTerraforming == true then if CheatCoreCM.DoNotToggleFloor == true then getPlayer():Say('Do Not Delete Floor Mode Enabled, Terraform Mode Disabled') else getPlayer():Say('Do Not Delete Floor Mode Disabled, Terraform Mode Disabled') end; CheatCoreCM.IsTerraforming = false; end") end)

	local TerraformOption = subMenu:addOption("Terraforming (X to Terraform)", worldobjects)
	local subMenuTerraform = subMenu:getNew(subMenu)
	context:addSubMenu(TerraformOption, subMenuTerraform)

	if CheatCoreCM.IsTerraforming then
		subMenuTerraform:addOption("Disable", worldobjects, function() CheatCoreCM.HandleToggle("Terraforming", "CheatCoreCM.IsTerraforming") end)
	end
	subMenuTerraform:addOption("Toggle Do Not Fill In Empty Square", worldobjects, function() CheatCoreCM.HandleToggle("Do Not Fill In Empty Floor Mode", "CheatCoreCM.DoNotFill") end)

	local tileTable = {
	optionTable = {},
	subMenuTable = {},
	categoryKey = {}
	} -- creates a table of sub menus.

	for k1,v1 in pairs(CheatCoreCM.TerraformTiles.MenuCategories) do -- assigns sub menu values
		tileTable.optionTable[v1] = subMenuTerraform:addOption(v1.."...", worldobjects)
		tileTable.subMenuTable[v1] = subMenuTerraform:getNew(subMenuTerraform)
		tileTable.categoryKey[v1] = v1
		context:addSubMenu(tileTable.optionTable[v1], tileTable.subMenuTable[v1])
		--print(#optionTable)
	end

	for k,v in pairs(CheatCoreCM.TerraformTiles.TileTypes) do
		if v["Category"] == tileTable.categoryKey[v["Category"]] then -- if the category of the tile type is the category of the current MenuCategories iteration, it will add it to the category menu
			local ranges;
			if #v["Ranges"] > 1 then
				ranges = "{"..v["Ranges"][1]..","..v["Ranges"][2].."}"
			else
				ranges = "{"..v["Ranges"][1].."}"
			end
			tileTable.subMenuTable[v["Category"]]:addOption(v["Name"], worldobjects, function() CheatCoreCM.HandleToggle(nil, nil, "CheatCoreCM.HandleCheck('CheatCoreCM.IsTerraforming', 'Terraform Mode')", "CheatCoreCM.Terraform = '"..v["Tileset"].."'; CheatCoreCM.TerraformRanges = "..ranges) end) -- iterates through the tile types
		end
	end
end

function ISUICheatMenu:createBarricadeMenu()
	local context, subMenu = self.context, self.subMenu

	local BarricadeOption = subMenu:addOption("Toggle Barricade Mode (Z To Barricade)...", worldobjects, nil)
	local subMenuBarricade = subMenu:getNew(subMenu);
	context:addSubMenu(BarricadeOption, subMenuBarricade);

	local BarricadeToggle = subMenuBarricade:addOption("Toggle Barricade Mode", worldobjects, function() CheatCoreCM.HandleToggle("Barricade Brush", "CheatCoreCM.IsBarricade", "CheatCoreCM.BarricadeType = 'wood'; CheatCoreCM.BarricadeLevel = 4") end)

	local PlankTypeOption = subMenuBarricade:addOption("Type of material...", worldobjects)
	local subMenuPlankType = subMenuBarricade:getNew(subMenuBarricade)
	context:addSubMenu(PlankTypeOption, subMenuPlankType)

	subMenuPlankType:addOption("Wood [DEFAULT]", worldobjects, function() CheatCoreCM.HandleToggle("Barricade Brush", nil, "CheatCoreCM.HandleCheck('CheatCoreCM.IsBarricade', 'Barricade Brush')", "CheatCoreCM.BarricadeType = 'wood'; CheatCoreCM.BarricadeLevel = CheatCoreCM.BarricadeLevel or 4") end)
	subMenuPlankType:addOption("Metal", worldobjects, function() CheatCoreCM.HandleToggle("Barricade Brush", nil, "CheatCoreCM.HandleCheck('CheatCoreCM.IsBarricade', 'Barricade Brush')", "CheatCoreCM.BarricadeType = 'metal'; CheatCoreCM.BarricadeLevel = CheatCoreCM.BarricadeLevel or 4") end)

	local PlankAmountOption = subMenuBarricade:addOption("Number of barricades...", worldobjects)
	local subMenuPlankAmount = subMenuBarricade:getNew(subMenuBarricade)
	context:addSubMenu(PlankAmountOption, subMenuPlankAmount)

	--populate subMenuPlankAmount--
	for i = 4,0,-1 do
		local stringName;
		if i == 1 then -- I use this to check if I should use a plural or not
			stringName = "Barricade object with 1 plank"
		elseif i == 0 then -- Setting the planks to 0 removes them
			stringName = "Remove all planks"
		else
			stringName = "Barricade object with "..tostring(i).." planks"
		end
		subMenuPlankAmount:addOption(stringName, worldobjects, function() CheatCoreCM.HandleToggle("Barricade Brush", nil, "CheatCoreCM.HandleCheck('CheatCoreCM.IsBarricade', 'Barricade Brush')", "CheatCoreCM.BarricadeLevel = "..tostring(i)) end)
	end
end

function ISUICheatMenu:createXPMenu()
	local context, subMenu = self.context, self.subMenu

	local XPOption = subMenu:addOption("Set Skill Level...", worldobjects, nil);
	local subMenuXP = subMenu:getNew(subMenu);
	context:addSubMenu(XPOption, subMenuXP);


	local MaxOption = subMenuXP:addOption("Max All Skills", worldobjects, CheatCoreCM.DoMaxAllSkills);

	local masterTable = {} -- table for all perk categories to go into

	local pf = PerkFactory.PerkList
	local pfSize = pf:size()

	for i = pfSize-1, 0, -1 do -- loop through PerkList and build masterTable
		local obj = pf:get(i)
		local par = PerkFactory.getPerkName(obj:getParent()) -- get the name of the category
		if obj and obj:getParent() ~= Perks.None then
			if masterTable[par] == nil then masterTable[par] = {} end -- if the table for the category doesn't exist, make it
			masterTable[par][obj:getName()] = obj:getType()
		end
	end

	for k,v in pairs(masterTable) do
		local option = subMenuXP:addOption(tostring(k).."..."); -- base subMenu, basically the category for all skill menus to go into
		local subMenuOption = subMenuXP:getNew(subMenuXP);
		context:addSubMenu(option, subMenuOption);

		for key,val in pairs(v) do
			local SkillOption = subMenuOption:addOption(key .. " to...") -- create subMenu for the skill, use key for the name (resulting string would be something like "Sprinting to...")
			local subMenuSkill = subMenuOption:getNew(subMenuOption)
			context:addSubMenu(SkillOption, subMenuSkill)

			for i = 0,10 do -- for each level, create an option for it
				subMenuSkill:addOption(tostring(i), worldobjects, function() CheatCoreCM.DoMaxSkill(val, i) end)
			end
		end
	end
end

function ISUICheatMenu:createWeatherMenu()
	local context, subMenu = self.context, self.subMenu

	if versionNumber <= 39 then -- only appears in versions with legacy weather system
		local WeatherOption = subMenu:addOption("Change Weather...", worldobjects, nil);

		local subMenuWeather = subMenu:getNew(subMenu)
		context:addSubMenu(WeatherOption, subMenuWeather)

		local weatherTable = {
			thunder = {"Thunder", "thunder"}, -- Name, string that IsoWorld recognizes
			rain = {"Rain", "rain"},
			clear = {"Sunny", "sunny"},
			cloudy = {"Cloudy", "cloud"}
		}

		for k,v in pairs(weatherTable) do -- Generate the submenus instead of manually writing each one.
			subMenuWeather:addOption("Toggle "..v[1], worldobjects, function() CheatCoreCM.SetWeather(v[2]) end)
		end
	end
end

function ISUICheatMenu:createTimeMenu()
	local context, subMenu = self.context, self.subMenu

	local TimeOption = subMenu:addOption("Warp Time To...", worldobjects, nil);
	local subMenuTime = subMenu:getNew(subMenu);
	context:addSubMenu(TimeOption, subMenuTime);

	local FreezeOption = subMenu:addOption("Freeze Day/Night Cycle", worldobjects, function() CheatCoreCM.HandleToggle("Day/Night Cycle Freeze", "CheatCoreCM.IsFreezeTime") end);

	local YearWarpOption = subMenuTime:addOption("Years...")
	local subMenuYears = subMenuTime:getNew(subMenuTime);
	context:addSubMenu(YearWarpOption, subMenuYears)

	local MonthWarpOption = subMenuTime:addOption("Months...");
	local subMenuMonths = subMenuTime:getNew(subMenuTime);
	context:addSubMenu(MonthWarpOption, subMenuMonths);

	local DayWarpOption = subMenuTime:addOption("Days...");
	local subMenuDays = subMenuTime:getNew(subMenuTime);

	context:addSubMenu(DayWarpOption, subMenuDays);

	local dayMenuTable = {}

	for i = 1,3 do
		local option = subMenuDays:addOption(tostring(i) .. "0...");
		local subMenu = subMenuDays:getNew(subMenuDays);
		dayMenuTable[i] = subMenu
		context:addSubMenu(option, subMenu);
	end

	local AMOption = subMenuTime:addOption("A.M...");
	local subMenuAM = subMenuTime:getNew(subMenuTime);
	context:addSubMenu(AMOption, subMenuAM);

	local PMOption = subMenuTime:addOption("P.M...");
	local subMenuPM = subMenuTime:getNew(subMenuTime);
	context:addSubMenu(PMOption, subMenuPM);



	--looping through year options creation--

	for i = 1993,2077 do -- loops through 1 to 20 and makes a submenu
		subMenuYears:addOption(tostring(i), worldobjects, function() CheatCoreCM.SetTime(i, "Year") end) -- passes i to CheatCoreCM.SetTime
	end

	--looping through month options creation--

	for i = 1,12 do -- loops through 1 to 12 and makes a submenu
		subMenuMonths:addOption(tostring(i), worldobjects, function() CheatCoreCM.SetTime(i-1, "Month") end) -- passes i to CheatCoreCM.SetTime
	end


	--looping through day options creation--

	for i = 1,getGameTime():daysInMonth(getGameTime():getYear(), getGameTime():getMonth()) do -- loops through 1 to the month's days (typically between 29-31) and adds an option to the submenu
		local index = math.floor(i / 10)
	    if i <= 10 then
			index = 1;
		end
		dayMenuTable[index]:addOption(tostring(i), worldobjects, function() CheatCoreCM.SetTime(i-1, 'Day') end) -- passes i to CheatCoreCM.SetTime
	end


	--looping through AM options creation--

	for i = 0,11 do -- loops through 1 to 11 and makes a submenu
		subMenuAM:addOption(tostring(i)..":00", worldobjects, function() CheatCoreCM.SetTime(i, "Time") end) -- passes i to CheatCoreCM.SetTime
	end

	--looping through PM options creation--

	for i = 12,23 do
		subMenuPM:addOption(tostring(i)..":00", worldobjects, function() CheatCoreCM.SetTime(i, "Time") end) -- passes i to CheatCoreCM.SetTime
	end
end

function ISUICheatMenu:createZombieMenu()
	local context, subMenu = self.context, self.subMenu

	local ZombieOption = subMenu:addOption("Zombie Brush...", worldobjects, nil);
	local subMenuZombie = subMenu:getNew(subMenu);
	context:addSubMenu(ZombieOption, subMenuZombie);

	--[[
	local zombUI = ISUIGenericWindow.IDs["Zombie"] -- returns ISUIGenericWindow(). used to get the input window (or create if nil) without creating a new UI instance every time the context menu is opened
		f zombUI == nil then -- the window isn't expected to exist at startup, if zombUI returns nil then that means it's the first time the context menu has been opened.
		local newUI = ISUIGenericWindow:new("Zombie Amount", "Zombie", function(val) CheatCoreCM.HandleToggle('Zombie Brush', nil, "CheatCoreCM.HandleCheck('CheatCoreCM.ZombieBrushEnabled', 'Zombie Brush')", "CheatCoreCM.ZombiesToSpawn = "..tostring(val) ); end)
		zombUI = ISUIGenericWindow.IDs["Zombie"]
		newUI:initialise()
		newUI:addToUIManager()
		newUI:setVisible(false)
	end
	--]]

	local zombUI = ISUIGenericWindow:checkExists("Zombie Amount", "Zombie", function(val) CheatCoreCM.HandleToggle('Zombie Brush', nil, "CheatCoreCM.HandleCheck('CheatCoreCM.ZombieBrushEnabled', 'Zombie Brush')", "CheatCoreCM.ZombiesToSpawn = "..tostring(val)); end, nil)

	subMenuZombie:addOption("Toggle", worldobjects, function() CheatCoreCM.HandleToggle("Zombie Brush", "CheatCoreCM.ZombieBrushEnabled") end);
	subMenuZombie:addOption("Set Amount", worldobjects, function() zombUI:setVisible(true) end);
end

function ISUICheatMenu:createStatsMenu()
	local context, subMenu = self.context, self.subMenu

	local StatOption = subMenu:addOption("Toggle Stats", worldobjects, nil); -- I add yet another new option
	local subMenuStats = subMenu:getNew(subMenu); -- I give this option its own subMenu.
	context:addSubMenu(StatOption, subMenuStats);

	local statsTable = {"Hunger", "Thirst", "Panic", {"Sanity", "No Insanity", 1}, "Stress", {"Fatigue", "No Sleep", 0}, "Boredom", "Anger", "Pain", "Sickness", "Drunkenness", {"Endurance", "Infinite Endurance", 1}, {"Fitness", "Infinite Fitness", 1}}

	subMenuStats:addOption("Toggle All", worldobjects, CheatCoreCM.AllStatsToggle); -- I add these options to the StatOption submenu

	for i = 1,#statsTable do
		local tbl = statsTable[i]
		if type(tbl) == "string" then
			subMenuStats:addOption("No ".. tbl, worldobjects, function() CheatCoreCM.HandleToggle("No ".. tbl, "CheatCoreCM.Is" .. tbl) end);
		else
			subMenuStats:addOption(tbl[2], worldobjects, function() CheatCoreCM.HandleToggle(tbl[2], "CheatCoreCM.Is" .. tbl[1]) end);
		end
	end


	subMenuStats:addOption("Never unhappy", worldobjects, function() CheatCoreCM.HandleToggle("Never Unhappy", "CheatCoreCM.IsUnhappy") end);
	subMenuStats:addOption("Never wet", worldobjects, function() CheatCoreCM.HandleToggle("Never Wet", "CheatCoreCM.IsWet") end);
	subMenuStats:addOption("Never hot/cold", worldobjects, function() CheatCoreCM.HandleToggle("Never Hot/Cold", "CheatCoreCM.IsTemperature") end);
end

function ISUICheatMenu:createVehicleMenu()
	local context, subMenu = self.context, self.subMenu

	local VehicleOption = subMenu:addOption("Vehicles...", worldobjects, nil);
	local subMenuVehicle = subMenu:getNew(subMenu);
	context:addSubMenu(VehicleOption, subMenuVehicle);
	local spawnOption = subMenuVehicle:addOption("Spawn Vehicle...", worldobjects, nil)
	local subMenuSpawn = subMenuVehicle:getNew(subMenuVehicle)
	context:addSubMenu(spawnOption,subMenuSpawn)

	local vehicleTable = {
		["Standard"] = {
			{"Chevalier Dart", "Base.SmallCar", "Standard"},
			{"Chevalier Cerise Wagon", "Base.CarStationWagon2", "Standard"},
			{"Dash Rancher", "Base.OffRoad", "Standard"},
			{"Masterson Horizon", "Base.SmallCar02", "Standard"},
		},
		["Sports"] = {
			{"Chevalier Cossette", "Base.SportsCar", "Sport"},
			{"Chevalier Nyala", "Base.CarNormal", "Sport"},
			{"Chevalier Nyala (Ranger)", "Base.CarLights", "Sport"},
			{"Chevalier Nyala (Police)", "Base.CarLightsPolice", "Sport"},
			{"Chevalier Nyala (Taxi/Yellow)", "Base.CarTaxi", "Sport"},
			{"Chevalier Nyala (Taxi/Green)", "Base.CarTaxi2", "Sport"},
			{"Mercia Lang 4000", "Base.CarLuxury", "Sport"},
			{"Chevalier Primani", "Base.ModernCar02", "Sport"},
			{"Dash Elite", "Base.ModernCar", "Sport"},
		},
		["Heavy Duty"] = {
			{"Franklin All-Terrain", "Base.SUV", "Heavy-Duty"},
			{"Chevalier Step Van", "Base.StepVan", "Heavy-Duty"},
			{"Chevalier Step Van (Mail)", "Base.StepVanMail", "Heavy-Duty"},
			{"Dash Bulldriver", "Base.PickUpVan", "Heavy-Duty"},
			{"Dash Bulldriver (Fossoil/Ranger)", "Base.PickUpVanLights", "Heavy-Duty"},
			{"Dash Bulldriver (Fire Dept.)", "Base.PickUpVanLightsFire", "Heavy-Duty"},
			{"Dash Bulldriver (Police)", "Base.PickUpVanPolice", "Heavy-Duty"},
			{"Dash Bulldriver (McCoy Logging Co.)", "Base.PickUpVanMccoy", "Heavy-Duty"},
			{"Franklin Valuline", "Base.Van", "Heavy-Duty"},
			{"Franklin Valuline (Spiffo's)", "Base.VanSpiffo", "Heavy-Duty"},
			{"Franklin Valuline (6 Seater)", "Base.VanSeats", "Heavy-Duty"},
			{"Franklin Valuline (Ambulance)", "Base.VanAmbulance", "Heavy-Duty"},
			{"Franklin Valuline (Radio)", "Base.VanRadio", "Heavy-Duty"},
			{"Franklin Valuline (McCoy/Fossoil/Mail", "Base.Van", "Heavy-Duty"},
			{"Chevalier D6", "Base.PickUpTruck", "Heavy-Duty"},
			{"Chevalier D6 (McCoy Logging Co.)", "Base.PickUpTruckMccoy", "Heavy-Duty"},
			{"Chevalier D6 (Fossoil/Ranger)", "Base.PickUpTruckLights", "Heavy-Duty"},
			{"Chevalier D6 (Fire Dept.)", "Base.PickUpTruckFire", "Heavy-Duty"}
		}
	}

	if getActivatedMods():contains("FRUsedCarsBETA") then
		vehicleTable["Filibuster"] = {
			{"Roanoke Goat", "Base.65gto", "Filibuster"},
			{"Chevalier El Chimera", "Base.68elcamino", "Filibuster"},
			{"Utana Lynx", "Base.68wildcat", "Filibuster"},
			{"Utana Lynx", "Base.68wildcatconvert", "Filibuster"},
			{"Dash Blitzer", "Base.69charger", "Filibuster"},
			{"Dash Blitzer R/P Edition", "Base.69chargerdaytona", "Filibuster"},
			{"Chevalier Bulette", "Base.70chevelle", "Filibuster"},
			{"Chevalier El Chimera", "Base.70elcamino", "Filibuster"},
			{"Chevalier Nyala", "Base.71impala", "Filibuster"},
			{"Franklin Thundercougar", "Base.73falcon", "Filibuster"},
			{"Franklin Jalapeno", "Base.73pinto", "Filibuster"},
			{"Roanoke Grand Slam", "Base.77transam", "Filibuster"},
			{"Laumet Davis Hogg", "Base.79brougham", "Filibuster"},
			{"Franklin Crest Andarta LTD", "Base.85vicranger", "Filibuster"},
			{"Franklin Crest Andarta LTD", "Base.85vicsed", "Filibuster"},
			{"Franklin Crest Andarta LTD", "Base.85vicsheriff", "Filibuster"},
			{"Franklin Crest Andarta Wagon", "Base.85vicwag", "Filibuster"},
			{"Franklin Crest Andarta Wagon", "Base.85vicwag2", "Filibuster"},
			{"Franklin Trip", "Base.86bounder", "Filibuster"},
			{"Slavski Nogo", "Base.86yugo", "Filibuster"},
			{"Chevalier Kobold", "Base.87blazer", "Filibuster"},
			{"Chevalier D20", "Base.87c10fire", "Filibuster"},
			{"Chevalier D20", "Base.87c10lb", "Filibuster"},
			{"Chevalier D20", "Base.87c10mccoy", "Filibuster"},
			{"Chevalier D20", "Base.87c10sb", "Filibuster"},
			{"Chevalier D20", "Base.87c10utility", "Filibuster"},
			{"Chevalier Carnifex", "Base.87suburban", "Filibuster"},
			{"Dash Buck", "Base.90ramlb", "Filibuster"},
			{"Dash Buck", "Base.90ramsb", "Filibuster"},
			{"Chevalier Kobold", "Base.91blazerpd", "Filibuster"},
			{"Tokai Renaissance", "Base.91crx", "Filibuster"},
			{"Chevalier Cosmo", "Base.astrovan", "Filibuster"},
			{"Franklin EF70 Box Truck", "Base.f700box", "Filibuster"},
			{"Franklin EF70 Dump Truck", "Base.f700dump", "Filibuster"},
			{"Franklin EF70 Flatbed", "Base.f700flatbed", "Filibuster"},
			{"Fire Engine", "Base.firepumper", "Filibuster"},
			{"The General Lee", "Base.generallee", "Filibuster"},
			{"The General Meh", "Base.generalmeh", "Filibuster"},
			{"M1025", "Base.hmmwvht", "Filibuster"},
			{"M1069", "Base.hmmwvtr", "Filibuster"},
			{"Pazuzu N5", "Base.isuzubox", "Filibuster"},
			{"Pazuzu N5", "Base.isuzuboxelec", "Filibuster"},
			{"Pazuzu N5", "Base.isuzuboxfood", "Filibuster"},
			{"Pazuzu N5", "Base.isuzuboxmccoy", "Filibuster"},
			{"M151A2", "Base.m151canvas", "Filibuster"},
			{"M35A2", "Base.m35a2bed", "Filibuster"},
			{"M35A2", "Base.m35a2covered", "Filibuster"},
			{"Move Urself Box Truck", "Base.moveurself", "Filibuster"},
			{"Pursuit Special", "Base.pursuitspecial", "Filibuster"},
			{"Franklin BE70 School Bus", "Base.schoolbus", "Filibuster"},
			{"Franklin BE70 School Bus", "Base.schoolbusshort", "Filibuster"},
			{"Bohag 244", "Base.volvo244", "Filibuster"},
		}
	end

	if getActivatedMods():contains("VileM113APC") then
		vehicleTable["VileM113APC"] = {
			{"M113A1","Base.m113a1", "Vile M113APC"},
		}
	end

	if getActivatedMods():contains("ZIL130PACK2") then
		vehicleTable["ZIL130PACK2"] = {
			{"ZIL-130","Base.zil130", "ZIL-130 #2"},
			{"AC-40(130)","Base.ac40", "ZIL-130 #2"},
			{"ZIL-130 Bread Furgon","Base.zil130bread", "ZIL-130 #2"},
			{"ZIL-130","Base.zil130tent", "ZIL-130 #2"},
			{"ZIL-MMZ-555","Base.zil130mmz555", "ZIL-130 #2"},
			{"ZIL-130 Milk Furgon","Base.zil130milk", "ZIL-130 #2"},
			{"ZIL-130 Furgon","Base.zil130furgon", "ZIL-130 #2"},
			{"ZIL-130G","Base.zil130g", "ZIL-130 #2"},
			{"ZIL-130G","Base.zil130gtent", "ZIL-130 #2"},
			{"ZIL-130 Food Furgon","Base.zil130products", "ZIL-130 #2"},
		}
	end

	if getActivatedMods():contains("MysteryMachineOGSN") then
		vehicleTable["MysteryMachineOGSN"] = {
			{"Mystery Machine","Base.VanMysterymachine", "Mystery Machine"},
		}
	end

	for k,v in pairs(vehicleTable) do
		local op = subMenuSpawn:addOption(k, worldobjects, nil)
		local sm = subMenuSpawn:getNew(subMenuSpawn)
		context:addSubMenu(op,sm)
		for k,v in pairs(v) do
			sm:addOption(v[1],worldobjects,function() CheatCoreCM.SpawnVehicle(v[2]) end)
		end
	end


	local carTable = {}
	if CheatCoreCM.IsReady == true then -- vehicle select function (defined in CheatCore.lua) sets IsReady to true
 		local bodyOption = subMenuVehicle:addOption("Individual Parts...", worldobjects, nil);
		local subMenuBody = subMenuVehicle:getNew(subMenuVehicle);
		context:addSubMenu(bodyOption, subMenuBody)

		local car = CheatCoreCM.SelectedVehicle
		local script = car:getScript();
		local deselect = function() CheatCoreCM.IsReady = false; CheatCoreCM.SelectedVehicle = nil; for i = 2,#subMenuVehicle.options do subMenuVehicle.options[i] = nil end end
		local inputUI = ISUIGenericWindow:checkExists("Set Value", "Vehicle", function() print("[Cheat Menu] Error generating inputUI") end, nil)

		subMenuVehicle:addOption("Toggle Vehicle Godmode", worldobjects, function() CheatCoreCM.HandleToggle("Vehicle Godmode", "CheatCoreCM.MadMax") end)
		subMenuVehicle:addOption("Repair All Parts", worldobjects, function() car:repair() end)
		subMenuVehicle:addOption("Toggle Hotwire", worldobjects, function() car:setHotwired(not car:isHotwired()) end)
		subMenuVehicle:addOption("Add Key to Inventory", worldobjects, function() if car:getCurrentKey() ~= nil then getPlayer():getInventory():AddItem(car:getCurrentKey()) else getPlayer():getInventory():AddItem(car:createVehicleKey()) end end)
		--local massOption = subMenuVehicle:addOption("Set Mass", worldobjects, function() inputUI:setVisible(true); inputUI.func = function(val) car:setMass(tonumber(val)) end end)
		subMenuVehicle:addOption("Set Rust", worldobjects, function() inputUI:setVisible(true); inputUI.func = function(val) car:setRust(tonumber(val)) end end)

		subMenuVehicle:addOption("Open Colour Editor", worldobjects, function() ISUIColourWindow.makeWindow()end)

		--local vehicleTypeOption = subMenuVehicle:addOption("Change Vehicle Type", worldobjects, function() print(car:getVehicleType()) end)
		local permaRemoveOption = subMenuVehicle:addOption("Permanently Remove Vehicle", worldobjects, function() car:permanentlyRemove(); deselect() end)

		for k,v in pairs(CheatCoreCM.Parts) do
			if k ~= "nodisplay" then

				local catOption = subMenuBody:addOption(getText("IGUI_VehiclePartCat" .. k), worldobjects, nil);
				local subMenuCat = subMenuBody:getNew(subMenuBody);
				context:addSubMenu(catOption, subMenuCat)
				--print(k)


				for k,v in pairs(v) do
					local modOption = subMenuCat:addOption(getText("IGUI_VehiclePart" .. k), worldobjects, nil);
					local subMenuMod = subMenuCat:getNew(subMenuCat)
					context:addSubMenu(modOption, subMenuMod)
					local repair = subMenuMod:addOption("Repair", worldobjects, function() v:setCondition(100) end)
					local setCondition = subMenuMod:addOption("Set Condition", worldobjects, function() inputUI:setVisible(true); inputUI.func = function(val) v:setCondition(tonumber(val)) end end)
					--if v:getCategory() == "tire" then
						--subMenuMod:addOption("Set Pressure", worldobjects, function() inputUI:setVisible(true); inputUI.func = function(val) v:setContainerContentAmount(tonumber(val), false, false) end end)
					if v:isContainer() == true then
						subMenuMod:addOption("Set Resource Amount", worldobjects, function() inputUI:setVisible(true); inputUI.func = function(val) v:setContainerContentAmount(tonumber(val), false, false) end end)
					elseif k == "Engine" then
						subMenuMod:addOption("Set Quality", worldobjects, function() inputUI:setVisible(true); inputUI.func = function(val) car:setEngineFeature(tonumber(val), car:getEngineLoudness(), car:getEnginePower()) end end)
						subMenuMod:addOption("Set Loudness", worldobjects, function() inputUI:setVisible(true); inputUI.func = function(val) car:setEngineFeature(car:getEngineQuality(), tonumber(val), car:getEnginePower()) end end)
						subMenuMod:addOption("Set Power", worldobjects, function() inputUI:setVisible(true); inputUI.func = function(val) car:setEngineFeature(car:getEngineQuality(), car:getEngineLoudness(), tonumber(val)) end end)
						local RPMOption = subMenuMod:addOption("Change RPM Type...", worldobjects, nil)
						local subMenuRPM = subMenuMod:getNew(subMenuMod)
						context:addSubMenu(RPMOption,subMenuRPM)
						local tbl = {{"firebird","Sport"},{"van","Heavy-Duty"},{"jeep","Standard"}} -- RPM types
						for i = 1,#tbl do
							subMenuRPM:addOption(tbl[i][2], worldobjects, function() car:getScript():setEngineRPMType(tbl[i][1]) end)
						end
						--subMenuMod:addOption("Set Max Speed", worldobjects, function() inputUI:setVisible(true); inputUI.func = function(val) car:setMaxSpeed(tonumber(val)) end end) -- chokes acceleration for some reason
					elseif v:getDoor() ~= nil then
						local door = v:getDoor()
						subMenuMod:addOption("Toggle Lock", worldobjects, function() if door:isLocked() then door:setLocked(false) else door:setLocked(true) end end)
					end
					local uninstall = subMenuMod:addOption("Uninstall", worldobjects, function() v:setInventoryItem(nil); car:update() end)

					if v:getItemType() ~= nil then
						local changeOption = subMenuMod:addOption("Change to...")
						local subMenuChange = subMenuMod:getNew(subMenuMod)
						context:addSubMenu(changeOption, subMenuChange)


						for i = 0, v:getItemType():size() - 1 do
							local obj = v:getItemType():get(i)
							if v:isContainer() == true then
								--print(v:getContainerContentType())
								subMenuChange:addOption(instanceItem(obj):getName(), worldobjects, function() v:setInventoryItem(instanceItem(obj), 10); v:setContainerContentAmount(999, false, false); car:update() end) -- every container has a maximum amount that it cant exceed so the value I set it to doesnt really matter, I set it to 999 to ensure it'll be full
							else
								subMenuChange:addOption(instanceItem(obj):getName(), worldobjects, function() v:setInventoryItem(instanceItem(obj), 10); car:update() end)
							end
						end
					end
				end

			end
		end

		local selectOption = subMenuVehicle:addOption("Deselect Vehicle", worldobjects, deselect);
	else
		local selectOption = subMenuVehicle:addOption("Select Existing Vehicle", worldobjects, function() CheatCoreCM.HandleToggle(nil, "CheatCoreCM.IsSelect", function() getPlayer():Say("Selection Mode " .. ( CheatCoreCM.IsSelect and "Enabled" or "Disabled") .. ", click on a vehicle to select it.") end) end)
	end
end



ISUICheatMenu.createMenuEntries = function(_player, _context, _worldObjects)

	local context = _context;
	local worldobjects = _worldObjects;


	local CheatOption = context:addOption("Cheat Menu", worldobjects);
	local subMenu = ISContextMenu:getNew(context);
	context:addSubMenu(CheatOption, subMenu);

	ISUICheatMenu.context = context
	ISUICheatMenu.subMenu = subMenu
	--[[ depreciated
	local godFuncCall = "getPlayer():setGodMod(CheatCoreCM.IsGod)"
	if versionNumber <= 39 then	-- the new cheat uses the game's built-in isGodMod() function that was added in build 40. The legacy function is used for builds 39 and under.
		godFuncCall = nil
	end
	--]]


	subMenu:addOption("God", worldobjects, function() CheatCoreCM.HandleToggle("God Mode", "CheatCoreCM.IsGod", CheatCoreCM.dragDownDisable) end);
	subMenu:addOption("Creative", worldobjects, function() CheatCoreCM.HandleToggle("Creative Mode", "CheatCoreCM.buildCheat") end);
	subMenu:addOption("Ghost Mode", worldobjects, function() CheatCoreCM.HandleToggle("Ghost Mode", "CheatCoreCM.IsGhost") end);
	subMenu:addOption("Heal Yourself", worldobjects, CheatCoreCM.DoHeal);
	subMenu:addOption("Noclip", worldobjects, function() CheatCoreCM.HandleToggle("Noclip", "CheatCoreCM.IsNoClip", "getPlayer():setNoClip(CheatCoreCM.IsNoClip)") end);
	subMenu:addOption("Refill Ammo", worldobjects, CheatCoreCM.DoRefillAmmo);
	subMenu:addOption("Infinite Ammo", worldobjects, function() CheatCoreCM.HandleToggle("Infinite Ammo", "CheatCoreCM.IsAmmo") end);
	subMenu:addOption("No Delay Between Shots", worldobjects, function() CheatCoreCM.HandleToggle("No Shot Delay", "CheatCoreCM.NoReload", "CheatCoreCM.DoNoReload()") end);
	subMenu:addOption("Open Item Spawner", worldobjects, function() if crucibleCore.mainWindow == nil then crucibleUI.makeWindow() else crucibleCore.mainWindow:setVisible(true) end end)
	subMenu:addOption("Open Teleport Menu", worldobjects, compassCore.makeWindow);
	subMenu:addOption("Open Lua Interpreter/File Editor", worldobjects, function() ISUILuaWindow.SetupBar() end);
	subMenu:addOption("Toggle Delete Mode (X to Delete)", worldobjects, function() CheatCoreCM.HandleToggle("Delete Mode", "CheatCoreCM.IsDelete") end);

	ISUICheatMenu:createTerraformMenu()

	ISUICheatMenu:createBarricadeMenu()

	subMenu:addOption("Toggle Fire Brush (N To Start Fire, F To Extinguish)", worldobjects, function() CheatCoreCM.HandleToggle("Fire Brush", "CheatCoreCM.FireBrushEnabled") end);
	subMenu:addOption("Toggle Fly Mode (Up/Down Arrow To Change Height)", worldobjects, function() CheatCoreCM.HandleToggle("Fly Mode", "CheatCoreCM.IsFly") end);

	ISUICheatMenu:createZombieMenu()

	subMenu:addOption("Infinite Carryweight", worldobjects, CheatCoreCM.DoCarryweightCheat);
	subMenu:addOption("Prevent death", worldobjects, function() CheatCoreCM.HandleToggle("Prevent Death", "CheatCoreCM.DoPreventDeath") end);
	subMenu:addOption("Insta-Kill Melee", worldobjects, function() CheatCoreCM.HandleToggle("Insta-kill Melee", "CheatCoreCM.IsMelee","CheatCoreCM.DoWeaponDamage()") end);
	subMenu:addOption("Infinite Weapon Durability", worldobjects, function() CheatCoreCM.HandleToggle("Infinite Weapon Durability", "CheatCoreCM.IsRepair") end);
	subMenu:addOption("Repair Equipped Item", worldobjects, function() CheatCoreCM.HandleToggle(nil, nil, "CheatCoreCM.DoRepair()", "getPlayer():Say('Weapon Repaired!')") end);
	subMenu:addOption("Learn All Recipes", worldobjects, function() CheatCoreCM.DoLearnRecipes() end)
	subMenu:addOption("Toggle Instant/Free Crafting", worldobjects, function() CheatCoreCM.HandleToggle("Instant Crafting", "CheatCoreCM.IsCraftingCheat", "CheatCoreCM.ToggleInstantCrafting()") end);
	subMenu:addOption("Toggle Instant Actions", worldobjects, function() CheatCoreCM.HandleToggle("Instant Actions", "CheatCoreCM.IsActionCheat", "CheatCoreCM.ToggleInstantActions()") end);
	--local NutritionOption = subMenu:addOption("Nutrition...", worldobjects);


	ISUICheatMenu:createStatsMenu()
	ISUICheatMenu:createTimeMenu()
	ISUICheatMenu:createWeatherMenu()
	ISUICheatMenu:createXPMenu()
	ISUICheatMenu:createVehicleMenu()

	-----------------------------
	--Making the Nutrition menu--
	-----------------------------

	--[[
	local subMenuNutrition = subMenu:getNew(subMenu);
	context:addSubMenu(NutritionOption, subMenuNutrition)

	local HealthyOption = subMenuNutrition:addOption("Become Healthy", worldobjects, CheatCoreCM.becomeHealthy)

	local EditOption = subMenuNutrition:addOption("Edit...", worldobjects)
	local subMenuEdit = subMenuNutrition:getNew(subMenuNutrition)
	context:addSubMenu(EditOption, subMenuEdit)

	local NutrTable = {
	"Calories",
	"Carbohydrates",
	"Lipids",
	"Proteins",
	"Weight"
	}

	for k,v in ipairs(NutrTable) do
		subMenuEdit:addOption(v, worldobjects, function() CheatCoreCM.editNutrition(v) end)
	end
	--]]


	--[[
	subMenuStats:addOption("No Hunger", worldobjects, function() CheatCoreCM.HandleToggle("No Hunger", "CheatCoreCM.IsHunger") end);
	subMenuStats:addOption("No Thirst", worldobjects, function() CheatCoreCM.HandleToggle("No Thirst", "CheatCoreCM.IsThirst") end);
	subMenuStats:addOption("Never panic", worldobjects, function() CheatCoreCM.HandleToggle("Never Panic", "CheatCoreCM.IsPanic") end);
	subMenuStats:addOption("Always sane", worldobjects, function() CheatCoreCM.HandleToggle("Always Sane", "CheatCoreCM.IsSanity") end);
	subMenuStats:addOption("No stress", worldobjects, function()CheatCoreCM.HandleToggle("No Stress", "CheatCoreCM.IsStress") end);
	subMenuStats:addOption("No boredom", worldobjects, function() CheatCoreCM.HandleToggle("No Boredom", "CheatCoreCM.IsBoredom") end);
	subMenuStats:addOption("Never angry", worldobjects, function() CheatCoreCM.HandleToggle("Never Angry", "CheatCoreCM.IsAnger") end);
	subMenuStats:addOption("Never feel pain", worldobjects, function() CheatCoreCM.HandleToggle("Never Feel Pain", "CheatCoreCM.IsPain") end);
	subMenuStats:addOption("Never sick/remove sickness", worldobjects, function() CheatCoreCM.HandleToggle("Never Sick/Remove Sickness", "CheatCoreCM.IsSick") end);
	subMenuStats:addOption("Never drunk", worldobjects, function() CheatCoreCM.HandleToggle("Never Drunk", "CheatCoreCM.IsDrunk") end);
	subMenuStats:addOption("Infinite endurance", worldobjects, function() CheatCoreCM.HandleToggle("Infinite Endurance", "CheatCoreCM.IsEndurance") end);
	subMenuStats:addOption("Infinite fitness", worldobjects, function() CheatCoreCM.HandleToggle("Infinite Fitness", "CheatCoreCM.IsFitness") end);
	subMenuStats:addOption("Never tired", worldobjects, function() CheatCoreCM.HandleToggle("Never Tired", "CheatCoreCM.IsSleep") end);
	--]]


end

print("[CHEAT MENU] ISUICheatMenu successfully loaded")

CheatCoreCM.shouldStart = function()
	if CheatCoreCM.isAdmin() then
		print("[CHEAT MENU] User "..getOnlineUsername().." is authorized! This message will appear the next time the client connects.")
		Events.OnPlayerUpdate.Add(CheatCoreCM.DoCheats);
		Events.OnTick.Add(CheatCoreCM.DoTickCheats);
		Events.OnMouseDown.Add(CheatCoreCM.OnClick);
		Events.OnKeyKeepPressed.Add(CheatCoreCM.OnKeyKeepPressed);
		Events.OnKeyPressed.Add(CheatCoreCM.OnKeyPressed);
		Events.OnPlayerMove.Add(CheatCoreCM.updateCoords);
		Events.OnFillWorldObjectContextMenu.Add(ISUICheatMenu.createMenuEntries);
		Events.OnMouseMove.Add(CheatCoreCM.highlightSquare);
		Events.OnTick.Remove(CheatCoreCM.shouldStart);
	end
	--elseif not CheatCoreCM.isAdmin() and CheatCoreCM.doNotWarn ~= true then
		--print("[CHEAT MENU] User "..getOnlineUsername().." is not authorized! This message will appear the next time the client connects.")
		--CheatCoreCM.doNotWarn = true
	--end
end

Events.OnTick.Add(CheatCoreCM.shouldStart);
