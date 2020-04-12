--***********************************************************
--**                    THE INDIE STONE                    **
--***********************************************************

require "Map/CGlobalObject"

CFuelBarrelGlobalObject = CGlobalObject:derive("CFuelBarrelGlobalObject")

function CFuelBarrelGlobalObject:new(luaSystem, isoObject)
	local o = CGlobalObject.new(self, luaSystem, isoObject)
	return o
end

function CFuelBarrelGlobalObject:getObject()
	return self:getIsoObject()
end

