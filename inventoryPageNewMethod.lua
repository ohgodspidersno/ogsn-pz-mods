-- modded
require "ISUI/ISInventoryPage"
local old_ISInventoryPage_new = ISInventoryPage.new
ISInventoryPage.new = function(...)
	local o = old_ISInventoryPage_new(...)

    o.containerIconMaps = {
        floor=o.conFloor,
        crate=o.conCrate,
        officedrawers=o.conDrawer,
        bin=o.conGarbage,
        fridge=o.conFridge,
        sidetable=o.conDrawer,
        wardrobe=o.conCabinet,
        counter=o.conCounter,
        medicine= o.conMedicine,
        barbecue= o.conOven,
        fireplace= o.conOven,
        woodstove = o.conOven,
        stove= o.conOven,
        shelves= o.conShelf,
        filingcabinet= o.conCabinet,
        garage_storage= o.conCrate,
        smallcrate= o.conCrate,
        smallbox= o.conCrate,
		inventorymale = o.conMaleZombie;
		inventoryfemale = o.conFemaleZombie;
        microwave = o.conMicrowave;
        vendingGt = o.conVending;
        logs = o.logs;
        fruitbusha = o.plant;
        fruitbushb = o.plant;
        fruitbushc = o.plant;
        fruitbushd = o.plant;
        fruitbushe = o.plant;
        corn = o.plant;
        vendingsnack = o.conVending;
        vendingpop = o.conVending;
        campfire = o.conCampfire;
        freezer = o.conFreezer;
        icecream = o.conFreezer;
        GloveBox = o.conglovebox;

        SeatFrontLeft = o.conseat;
        SeatFrontRight = o.conseat;
        SeatMiddleLeft = o.conseat;
        SeatMiddleRight = o.conseat;
        SeatRearLeft = o.conseat;
        SeatRearRight = o.conseat;

--	FOR 8-10 PASSENGER TEMPLATES BY ARSENAL26
        SeatRow2Left = o.conseat;
        SeatRow2Right = o.conseat;
        SeatRow3Left = o.conseat;
        SeatRow3Right = o.conseat;
        SeatRow4Left = o.conseat;
        SeatRow4Right = o.conseat;
        SeatRow5Left = o.conseat;
        SeatRow5Right = o.conseat;
        SeatRow6Left = o.conseat;
        SeatRow6Right = o.conseat;
        SeatCargo1Left = o.conCrate;
        SeatCargo1Right = o.conCrate;
        SeatCargo2Left = o.conCrate;
        SeatCargo2Right = o.conCrate;
        SeatCargo3Left = o.conCrate;
        SeatCargo3Right = o.conCrate;

        TruckBed = o.contrunk;
        TruckBedOpen = o.contrunk;	}

	return o
end


--************************************************************************--
--** ISInventoryPage:new
--**
--************************************************************************--
function ISInventoryPage:new (x, y, width, height, inventory, onCharacter, zoom)
	local o = {}
	--o.data = {}
	o = ISPanel:new(x, y, width, height);
    setmetatable(o, self)
    self.__index = self
	o.x = x;
	o.y = y;
    o.anchorLeft = true;
    o.anchorRight = true;
    o.anchorTop = true;
    o.anchorBottom = true;
	o.borderColor = {r=0.4, g=0.4, b=0.4, a=1};
	o.backgroundColor = {r=0, g=0, b=0, a=0.8};
	o.width = width;
	o.height = height;
	o.anchorLeft = true;
    o.backpackChoice = 1;
    o.zoom = zoom;
    o.isCollapsed = true;
    if o.zoom == nil then o.zoom = 1; end

	o.inventory = inventory;
    o.onCharacter = onCharacter;
    o.titlebarbkg = getTexture("media/ui/Panel_TitleBar.png");
    o.infoBtn = getTexture("media/ui/Panel_info_button.png");
    o.statusbarbkg = getTexture("media/ui/Panel_StatusBar.png");
    o.resizeimage = getTexture("media/ui/Panel_StatusBar_Resize.png");
    o.invbasic = getTexture("media/ui/Icon_InventoryBasic.png");
    o.closebutton = getTexture("media/ui/Dialog_Titlebar_CloseIcon.png");
    o.collapsebutton = getTexture("media/ui/Panel_Icon_Collapse.png");
    o.pinbutton = getTexture("media/ui/Panel_Icon_Pin.png");

    o.conFloor = getTexture("media/ui/Container_Floor.png");
    o.conOven = getTexture("media/ui/Container_Oven.png");
    o.conCabinet = getTexture("media/ui/Container_Cabinet.png");
    o.conSack = getTexture("media/ui/Container_Sack.png");
    o.conShelf = getTexture("media/ui/Container_Shelf.png");
    o.conCounter = getTexture("media/ui/Container_Counter.png");
    o.conMedicine = getTexture("media/ui/Container_Medicine.png");
    o.conGarbage = getTexture("media/ui/Container_Garbage.png");
    o.conFridge = getTexture("media/ui/Container_Fridge.png");
    o.conFreezer = getTexture("media/ui/Container_Freezer.png");
    o.conDrawer = getTexture("media/ui/Container_Drawer.png");
    o.conCrate = getTexture("media/ui/Container_Crate.png");
	o.conFemaleZombie = getTexture("media/ui/Container_DeadPerson_FemaleZombie.png");
	o.conMaleZombie = getTexture("media/ui/Container_DeadPerson_MaleZombie.png");
    o.conMicrowave = getTexture("media/ui/Container_Microwave.png");
    o.conVending = getTexture("media/ui/Container_Vendingt.png");
    o.logs = getTexture("media/ui/Item_Logs.png");
    o.plant = getTexture("media/ui/Container_Plant.png");
    o.conCampfire = getTexture("media/ui/Container_Campfire.png");
    o.conglovebox = getTexture("media/ui/Container_GloveCompartment.png");
    o.conseat = getTexture("media/ui/Container_Carseat.png");
    o.contrunk = getTexture("media/ui/Container_TruckBed.png");
    o.clothingdryer = getTexture("media/ui/Container_ClothingDryer.png")
    o.clothingwasher = getTexture("media/ui/Container_ClothingWasher.png")

    o.conDefault = o.conShelf;
    o.highlightColors = {r=0.98,g=0.56,b=0.11};

    o.containerIconMaps = {
        floor=o.conFloor,
        crate=o.conCrate,
        officedrawers=o.conDrawer,
        bin=o.conGarbage,
        fridge=o.conFridge,
        dresser = o.conDrawer,
        sidetable=o.conDrawer,
        wardrobe=o.conCabinet,
        counter=o.conCounter,
        medicine= o.conMedicine,
        barbecue= o.conOven,
        desk = o.conDrawer,
        fireplace= o.conOven,
        woodstove = o.conOven,
        stove= o.conOven,
        shelves= o.conShelf,
        metal_shelves = o.conShelf,
        filingcabinet= o.conDrawer,
        garage_storage= o.conCrate,
        smallcrate= o.conCrate,
        smallbox= o.conCrate,
		inventorymale = o.conMaleZombie;
		inventoryfemale = o.conFemaleZombie;
        microwave = o.conMicrowave;
        vendingGt = o.conVending;
        logs = o.logs;
        fruitbusha = o.plant;
        fruitbushb = o.plant;
        fruitbushc = o.plant;
        fruitbushd = o.plant;
        fruitbushe = o.plant;
        corn = o.plant;
        vendingsnack = o.conVending;
        vendingpop = o.conVending;
        campfire = o.conCampfire;
        freezer = o.conFreezer;
        icecream = o.conFreezer;
        GloveBox = o.conglovebox;
        SeatRearLeft = o.conseat;
        SeatMiddleRight = o.conseat;
        SeatRearRight = o.conseat;
        SeatMiddleLeft = o.conseat;
        SeatFrontLeft = o.conseat;
        SeatFrontRight = o.conseat;
        TruckBed = o.contrunk;
        TruckBedOpen = o.contrunk;
        TrailerTrunk = o.contrunk;
        clothingdryer = o.clothingdryer;
        clothingwasher = o.clothingwasher;
    }

    o.pin = true;
    o.isCollapsed = false;
    o.backpacks = {}
    o.collapseCounter = 0;
	o.title = nil;
	o.titleFont = UIFont.Small
	o.titleFontHgt = getTextManager():getFontHeight(o.titleFont)
   return o
end
