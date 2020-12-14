function ISInventoryPage:onMouseMove(dx, dy)
	self.mouseOver = true;

--    print(self:getMouseX(), self:getMouseY(), self:getWidth(), self:getHeight())

	if self.moving then
		self:setX(self.x + dx);
		self:setY(self.y + dy);

    end

    if not isGamePaused() then
        if self.isCollapsed and self.player and getSpecificPlayer(self.player) and getSpecificPlayer(self.player):isAiming() then
            return
        end
    end

    local panCameraKey = getCore():getKey("PanCamera")
    if self.isCollapsed and panCameraKey ~= 0 and isKeyDown(panCameraKey) then
        return
    end

    if not isMouseButtonDown(0) and not isMouseButtonDown(1) and not isMouseButtonDown(2) then

        self.collapseCounter = 0;
        if self.isCollapsed and self:getMouseY() < self:titleBarHeight() then
           self.isCollapsed = false;
		   	if isClient() and not self.onCharacter then
				self.inventoryPane.inventory:requestSync();
			end
           self:clearMaxDrawHeight();
           self.collapseCounter = 0;
        end
    end
end


ISInventoryPage.onKeyPressed = function(key)
	if key == getCore():getKey("Toggle Inventory") and getSpecificPlayer(0) and getGameSpeed() > 0 and getPlayerInventory(0) and getCore():getGameMode() ~= "Tutorial" then
        getPlayerInventory(0):setVisible(not getPlayerInventory(0):getIsVisible());
        getPlayerLoot(0):setVisible(getPlayerInventory(0):getIsVisible());
	end
end


function ISInventoryPage:toggleStove()
	if UIManager.getSpeedControls() and UIManager.getSpeedControls():getCurrentGameSpeed() == 0 then
		return
	end

	local object = self.inventoryPane.inventory:getParent()
	if not object then return end
	local className = object:getObjectName()
	TurnOnOff[className].toggle(object)
end
