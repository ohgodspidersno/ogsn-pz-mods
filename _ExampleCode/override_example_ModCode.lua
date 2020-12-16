PaintVehicleMenu = {}

local function onSandVehicle(player, vehicle, paintRequired)
    -- Walk to the vehicle
    ISTimedActionQueue.add(ISPathFindAction:pathToVehicleArea(player, vehicle, PaintVehicleConfig.VEHICLE_AREAS[1]))
    -- Unequip a secondary hand item
    PaintVehicleHelper.unequipHandItem(player, false)
    -- Wear PPE
    PaintVehicleHelper.wearPPE(player)
    -- Equip metal brush
    PaintVehicleHelper.equipPrimHandItem(player, PaintVehicleConfig.ITEMS.WIRE_BRUSH)
    ISTimedActionQueue.add(SandVehicleAction:new(player, vehicle, paintRequired))
end

local function onPrimeVehicle(player, vehicle, primerRequired)
    -- Walk to the vehicle
    ISTimedActionQueue.add(ISPathFindAction:pathToVehicleArea(player, vehicle, PaintVehicleConfig.VEHICLE_AREAS[1]))
    -- Unequip a secondary hand item
    PaintVehicleHelper.unequipHandItem(player, false)
    -- Wear PPE
    PaintVehicleHelper.wearPPE(player)
    -- Transfer primer cans to the main inventory
    PaintVehicleHelper.transferUsableItems(player, PaintVehicleConfig.ITEMS.PRIMER, primerRequired)
    -- Equip primer
    PaintVehicleHelper.equipPrimHandItem(player, PaintVehicleConfig.ITEMS.PRIMER)
    ISTimedActionQueue.add(PrimeVehicleAction:new(player, vehicle, primerRequired))
end

---
--- Opens the paint mixing panel.
---
local function onMixPaint(player, vehicle, paintRequired)
    if UIPaintMixingPanel.instance and UIPaintMixingPanel.instance[player:getPlayerNum() + 1] then
        UIPaintMixingPanel.instance[player:getPlayerNum() + 1]:setVehicle(vehicle, paintRequired)
    else
        local panel = UIPaintMixingPanel:new(0, 0, player, vehicle, paintRequired)
        panel:initialise()
        panel:addToUIManager()

        if JoypadState.players[player:getPlayerNum() + 1] then
            setJoypadFocus(player:getPlayerNum(), panel)
        end
    end
end

local function onSprayPaint(player, vehicle, paintEntry, paintRequired)
    -- Walk to the vehicle
    ISTimedActionQueue.add(ISPathFindAction:pathToVehicleArea(player, vehicle, PaintVehicleConfig.VEHICLE_AREAS[1]))
    -- Unequip a secondary hand item
    PaintVehicleHelper.unequipHandItem(player, false)
    -- Wear PPE
    PaintVehicleHelper.wearPPE(player)
    -- Transfer spray cans to the main inventory
    PaintVehicleHelper.transferUsableItems(player, paintEntry.itemType, paintRequired)
    -- Equip spray can
    PaintVehicleHelper.equipPrimHandItem(player, paintEntry.itemType)
    ISTimedActionQueue.add(PaintVehicleWithSprayAction:new(player, vehicle, paintEntry, paintRequired))
end

---@return string,boolean Tooltip text and if option available
local function tooltipRequiredPPE(player)
    local text = ""
    local notAvailable

    local inventory = player:getInventory()
    local hasDustMask = inventory:containsTypeRecurse(PaintVehicleConfig.ITEMS.DUST_MASK)
    local hasSafetyGoggles = inventory:containsTypeRecurse(PaintVehicleConfig.ITEMS.GOGGLES)
    local hasGasMask = inventory:containsTypeRecurse(PaintVehicleConfig.ITEMS.GAS_MASK)
    local hasBioMask = inventory:containsTypeRecurse(PaintVehicleConfig.ITEMS.BIO_MASK)

    if hasDustMask then
        text = " <RGB:1,1,1> " .. getItemNameFromFullType(PaintVehicleConfig.ITEMS.DUST_MASK) .. " "
    else
        text = " <RGB:1,0,0> " .. getItemNameFromFullType(PaintVehicleConfig.ITEMS.DUST_MASK) .. " "
    end
    text = text .. " <RGB:1,1,1> " .. getText("Tooltip_PaintYourRide_and") .. " "
    if hasSafetyGoggles then
        text = text .. " <RGB:1,1,1> " .. getItemNameFromFullType(PaintVehicleConfig.ITEMS.GOGGLES)
    else
        text = text .. " <RGB:1,0,0> " .. getItemNameFromFullType(PaintVehicleConfig.ITEMS.GOGGLES)
    end
    text = text .. " <LINE> <RGB:1,1,1> " .. getText("Tooltip_PaintYourRide_or") .. " "
    if hasGasMask then
        text = text .. " <RGB:1,1,1> " .. getItemNameFromFullType(PaintVehicleConfig.ITEMS.GAS_MASK)
    else
        text = text .. " <RGB:1,0,0> " .. getItemNameFromFullType(PaintVehicleConfig.ITEMS.GAS_MASK)
        notAvailable = true
    end
    text = text .. " <LINE> <RGB:1,1,1> " .. getText("Tooltip_PaintYourRide_or") .. " "
    if hasBioMask then
        text = text .. " <RGB:1,1,1> " .. getItemNameFromFullType(PaintVehicleConfig.ITEMS.BIO_MASK)
    else
        text = text .. " <RGB:1,0,0> " .. getItemNameFromFullType(PaintVehicleConfig.ITEMS.BIO_MASK)
        notAvailable = true
    end
    return text, notAvailable
end

---@return string,boolean Tooltip text and if option available
local function tooltipRequiredWash(vehicle)
    local text = ""
    local notAvailable
    if ISWashVehicle.hasBlood(vehicle) then
        text = " <LINE> <LINE> <RGB:1,0,0> " .. getText("Tooltip_PaintYourRide_Menu_RequiredWash")
        notAvailable = true
    end
    return text, notAvailable
end

---
--- Checks if there are vehicle parts that need to be uninstalled.
---
---@return string,boolean Tooltip text and if option available
local function tooltipRequiredPartsUninstall(vehicle)
    local text = ""
    local notAvailable

    local partsToRemove = {}
    for i = 1, vehicle:getPartCount() do
        local part = vehicle:getPartByIndex(i - 1)
        local partId = part:getId()

        -- Looking for Windshield, WindshieldRear, WindowFrontLeft, WindowFrontRight,
        -- WindowRearLeft, WindowRearRight, WindowMiddleLeft, WindowMiddleRight
        if partId:find("^Wind") ~= nil then
            if part:getItemType() and not part:getItemType():isEmpty() and not part:getInventoryItem() then
                -- part is uninstalled
            else
                table.insert(partsToRemove, partId)
            end
        end
    end

    if #partsToRemove > 0 then
        text = " <LINE> <LINE> <RGB:1,1,1> " .. getText("Tooltip_PaintYourRide_Menu_RequiredUninstall") .. " <LINE> "
        for _, part in ipairs(partsToRemove) do
            text = text .. " <RGB:1,0,0> " .. getText("IGUI_VehiclePart" .. part) .. " <LINE> "
            notAvailable = true
        end
    end
    return text, notAvailable
end

local function addSandOption(player, context, vehicle, paintRequired)
    local hasWireBrush = player:getInventory():containsTypeRecurse(PaintVehicleConfig.ITEMS.WIRE_BRUSH)
    if not hasWireBrush then return end

    local tooltipTextRequiredPPE, notAvailablePPE = tooltipRequiredPPE(player)
    local tooltipTextRequiredWash, notAvailableWash = tooltipRequiredWash(vehicle)
    local tooltipTextRequiredPartsUninstall, notAvailableParts = tooltipRequiredPartsUninstall(vehicle)

    local option = context:addOption(getText("ContextMenu_PaintYourRide_Sand"), player, onSandVehicle, vehicle, paintRequired)
    local tooltip = ISWorldObjectContextMenu.addToolTip()
    option.toolTip = tooltip
    tooltip:setName(getText("ContextMenu_PaintYourRide_Sand"))
    tooltip.description = getText("Tooltip_PaintYourRide_Menu_Sand") .. " <LINE> <LINE> "
    tooltip.description = tooltip.description .. getText("Tooltip_PaintYourRide_Menu_Requirements") .. " <LINE> "
    tooltip.description = tooltip.description .. tooltipTextRequiredPPE
    tooltip.description = tooltip.description .. " <LINE> <RGB:1,1,1> " .. getItemNameFromFullType(PaintVehicleConfig.ITEMS.WIRE_BRUSH) .. " "
    tooltip.description = tooltip.description .. tooltipTextRequiredWash
    tooltip.description = tooltip.description .. tooltipTextRequiredPartsUninstall

    if notAvailablePPE or notAvailableWash or notAvailableParts then
        option.notAvailable = true
    end
end

local function addPrimeOption(player, context, vehicle, paintRequired)
    local hasPrimer = player:getInventory():containsTypeRecurse(PaintVehicleConfig.ITEMS.PRIMER)
    if not hasPrimer then return end

    local tooltipTextRequiredPPE, notAvailablePPE = tooltipRequiredPPE(player)
    local tooltipTextRequiredWash, notAvailableWash = tooltipRequiredWash(vehicle)
    local tooltipTextRequiredPartsUninstall, notAvailableParts = tooltipRequiredPartsUninstall(vehicle)

    local primerRequired = math.ceil(paintRequired * PaintVehicleConfig.COEF_USE_PRIMER)

    local option = context:addOption(getText("ContextMenu_PaintYourRide_Prime"), player, onPrimeVehicle, vehicle, primerRequired)
    local tooltip = ISWorldObjectContextMenu.addToolTip()
    option.toolTip = tooltip
    tooltip:setName(getText("ContextMenu_PaintYourRide_Prime"))
    tooltip.description = getText("Tooltip_PaintYourRide_Menu_Prime") .. " <LINE> <LINE> "
    tooltip.description = tooltip.description .. getText("Tooltip_PaintYourRide_Menu_Requirements") .. " <LINE> "
    tooltip.description = tooltip.description .. tooltipTextRequiredPPE

    local primerAvailable = PaintVehicleHelper.getItemsUsesTotal(player, PaintVehicleConfig.ITEMS.PRIMER)
    if primerAvailable >= primerRequired then
        tooltip.description = tooltip.description .. " <LINE> <LINE> <RGB:1,1,1> " .. getItemNameFromFullType(PaintVehicleConfig.ITEMS.PRIMER) .. " " .. primerAvailable .. "/" .. primerRequired
    else
        tooltip.description = tooltip.description .. " <LINE> <LINE> <RGB:1,0,0> " .. getItemNameFromFullType(PaintVehicleConfig.ITEMS.PRIMER) .. " " .. primerAvailable .. "/" .. primerRequired
        option.notAvailable = true
    end

    tooltip.description = tooltip.description .. tooltipTextRequiredWash
    tooltip.description = tooltip.description .. tooltipTextRequiredPartsUninstall

    if notAvailablePPE or notAvailableWash or notAvailableParts then
        option.notAvailable = true
    end
end

local function addPaintOption(player, context, vehicle, paintRequired)
    local option = context:addOption(getText("ContextMenu_PaintYourRide_Paint"), nil, nil)
    local subMenu = ISContextMenu:getNew(context)
    context:addSubMenu(option, subMenu)

    local tooltipTextRequiredPPE, notAvailablePPE = tooltipRequiredPPE(player)
    local tooltipTextRequiredWash, notAvailableWash = tooltipRequiredWash(vehicle)
    local tooltipTextRequiredPartsUninstall, notAvailableParts = tooltipRequiredPartsUninstall(vehicle)

    -- Mix Paint option
    -- ----------------
    -- Keep track if we've added this option
    local isAddedOptionMix
    -- Need to read the VehiclePaintingMag2
    if player:isRecipeKnown("Paint Mixing") then
        local optionMix = subMenu:addOption(getText("ContextMenu_PaintYourRide_Paint_Mix"), player, onMixPaint, vehicle, paintRequired)
        local tooltip = ISWorldObjectContextMenu.addToolTip()
        optionMix.toolTip = tooltip
        tooltip:setName(getText("ContextMenu_PaintYourRide_Paint_Mix"))
        tooltip.description = getText("Tooltip_PaintYourRide_Menu_Paint") .. " <LINE> <LINE> "
        tooltip.description = tooltip.description .. getText("Tooltip_PaintYourRide_Menu_Requirements") .. " <LINE> "
        tooltip.description = tooltip.description .. tooltipTextRequiredPPE

        local hasSprayGun = player:getInventory():containsTypeRecurse(PaintVehicleConfig.ITEMS.SPRAY_GUN)
        local sprayGun = PaintVehicleHelper.getSprayGunWithMostUses(player)
        -- Battery charge required in percent
        local batteryRequired = math.ceil(paintRequired * PaintVehicleConfig.COEF_USE_SPRAY_GUN)
        if hasSprayGun then
            tooltip.description = tooltip.description .. " <LINE> <RGB:1,1,1> " .. getItemNameFromFullType(PaintVehicleConfig.ITEMS.SPRAY_GUN) .. " "
            if sprayGun:getDelta() >= batteryRequired / 100 then
                tooltip.description = tooltip.description .. getText("Tooltip_PaintYourRide_Menu_RequiredBatteryCharge", batteryRequired)
            else
                tooltip.description = tooltip.description .. " <RGB:1,0,0> " .. getText("Tooltip_PaintYourRide_Menu_RequiredBatteryCharge", batteryRequired)
                optionMix.notAvailable = true
            end
        else
            tooltip.description = tooltip.description .. " <LINE> <RGB:1,0,0> " .. getItemNameFromFullType(PaintVehicleConfig.ITEMS.SPRAY_GUN) .. " "
            tooltip.description = tooltip.description .. getText("Tooltip_PaintYourRide_Menu_RequiredBatteryCharge", batteryRequired)
            optionMix.notAvailable = true
        end

        local basePaintAvailable = PaintVehicleHelper.getItemsUsesTotal(player, PaintVehicleConfig.ITEMS.BASE_PAINT)
        if basePaintAvailable >= paintRequired then
            tooltip.description = tooltip.description .. " <LINE> <LINE> <RGB:1,1,1> " .. getItemNameFromFullType(PaintVehicleConfig.ITEMS.BASE_PAINT) .. " " .. basePaintAvailable .. "/" .. paintRequired
        else
            tooltip.description = tooltip.description .. " <LINE> <LINE> <RGB:1,0,0> " .. getItemNameFromFullType(PaintVehicleConfig.ITEMS.BASE_PAINT) .. " " .. basePaintAvailable .. "/" .. paintRequired
            optionMix.notAvailable = true
        end

        -- Tinting paints
        for _, tint in pairs(PaintVehicleConfig.ITEMS.TINTS) do
            local hasItem = player:getInventory():containsTypeRecurse(tint)
            if hasItem then
                tooltip.description = tooltip.description .. " <LINE> <RGB:1,1,1> " .. getItemNameFromFullType(tint)
            else
                tooltip.description = tooltip.description .. " <LINE> <RGB:0.6,0.6,0.6> " .. getItemNameFromFullType(tint)
            end
        end

        tooltip.description = tooltip.description .. tooltipTextRequiredWash
        tooltip.description = tooltip.description .. tooltipTextRequiredPartsUninstall

        if notAvailablePPE or notAvailableWash or notAvailableParts then
            optionMix.notAvailable = true
        end

        isAddedOptionMix = true
    end

    -- Spray Paint option
    -- ------------------
    local optionSpray = subMenu:addOption(getText("ContextMenu_PaintYourRide_Paint_Spray"), nil, nil)
    local subMenuSprays = ISContextMenu:getNew(subMenu)
    subMenu:addSubMenu(optionSpray, subMenuSprays)

    -- Keep track if we've added any suboptions
    local isAddedOptionSpray
    for _, paint in ipairs(PaintVehicleConfig.ITEMS.SPRAY_PAINT) do
        if player:getInventory():containsTypeRecurse(paint.itemType) then
            local optionPaint = subMenuSprays:addOption(getText("ContextMenu_PaintYourRide_" .. paint.itemType), player, onSprayPaint, vehicle, paint, paintRequired)

            local tooltip = ISWorldObjectContextMenu.addToolTip()
            optionPaint.toolTip = tooltip
            tooltip:setName(getText("ContextMenu_PaintYourRide_Paint_Spray"))
            tooltip.description = getText("Tooltip_PaintYourRide_Menu_Paint") .. " <LINE> <LINE> "
            tooltip.description = tooltip.description .. getText("Tooltip_PaintYourRide_Menu_Requirements") .. " <LINE> "
            tooltip.description = tooltip.description .. tooltipTextRequiredPPE

            local paintAvailable = PaintVehicleHelper.getItemsUsesTotal(player, paint.itemType)
            if paintAvailable >= paintRequired then
                tooltip.description = tooltip.description .. " <LINE> <LINE> <RGB:1,1,1> " .. getItemNameFromFullType("PaintYourRide." .. paint.itemType) .. " " .. paintAvailable .. "/" .. paintRequired
            else
                tooltip.description = tooltip.description .. " <LINE> <LINE> <RGB:1,0,0> " .. getItemNameFromFullType("PaintYourRide." .. paint.itemType) .. " " .. paintAvailable .. "/" .. paintRequired
                optionPaint.notAvailable = true
            end

            tooltip.description = tooltip.description .. tooltipTextRequiredWash
            tooltip.description = tooltip.description .. tooltipTextRequiredPartsUninstall

            if notAvailablePPE or notAvailableWash or notAvailableParts then
                optionPaint.notAvailable = true
            end

            isAddedOptionSpray = true
        end
    end

    -- Remove Spray suboption if no options added
    if not isAddedOptionSpray then
        subMenu:removeLastOption()
        optionSpray.notAvailable = true
    end

    -- Remove Paint option if no suboptions added
    if not isAddedOptionMix and not isAddedOptionSpray then
        context:removeLastOption()
        option.notAvailable = true
    end
end

---
--- Adds new option to the vertical menu when a player is outside of the vehicle.
---
---@param player any The current player.
---@param vehicle any The clicked vehicle.
function PaintVehicleMenu.addOptionToMenuOutsideVehicle(player, context, vehicle)
    -- Need to read the VehiclePaintingMag1
    if not player:isRecipeKnown("Vehicle Painting") then return end

    -- Check the vehicle's id. Should be one from the list
    local paintRequired
    for _, v in pairs(PaintVehicleConfig.VEHICLES) do
        if v.vehicleId == vehicle:getScriptName() then
            paintRequired = v.paintRequired
            break
        end
    end
    if not paintRequired then return end

    local modData = vehicle:getModData()
    if not modData.isSanded and not modData.isPrimed then
        addSandOption(player, context, vehicle, paintRequired)
    elseif modData.isSanded and not modData.isPrimed then
        addPrimeOption(player, context, vehicle, paintRequired)
    elseif modData.isSanded and modData.isPrimed then
        addPaintOption(player, context, vehicle, paintRequired)
    end
end

-- Wrap the original function
PaintVehicleMenu.originalMenuOutsideVehicle = ISVehicleMenu.FillMenuOutsideVehicle
-- Override the original function
function ISVehicleMenu.FillMenuOutsideVehicle(player, context, vehicle, test)
    PaintVehicleMenu.originalMenuOutsideVehicle(player, context, vehicle, test)
    PaintVehicleMenu.addOptionToMenuOutsideVehicle(getSpecificPlayer(player), context, vehicle)
end
