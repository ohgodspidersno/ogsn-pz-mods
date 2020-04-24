ISInventoryPaneContextMenu.createMenu = function(player, isInPlayerInventory, items, x, y, origin)
    if isAllLiterature and not getSpecificPlayer(player):getTraits():isIlliterate() then
    		local readOption = context:addOption(getText("ContextMenu_Read"), items, ISInventoryPaneContextMenu.onLiteratureItems, player);
            if getSpecificPlayer(player):isAsleep() then
                readOption.notAvailable = true;
                local tooltip = ISInventoryPaneContextMenu.addToolTip();
                tooltip.description = getText("ContextMenu_NoOptionSleeping");
                readOption.toolTip = tooltip;
            end
        end
      end
end
