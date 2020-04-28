require "ISUI/ISContextMenu"

function ISContextMenu:removeOption(option)
    self.options[option] =  nil;
    self.numOptions = self.numOptions -1;
	self:calcHeight()
end
