local ISLightSource_create_original = ISLightSource.create

function ISLightSource:create(x, y, z, north, sprite, ...)
	ISLightSource_create_original(self, x, y, z, north, sprite, ...)
	self.javaObject:setLifeDelta(0);
	-- return result -- not sure if this is necessary
end
