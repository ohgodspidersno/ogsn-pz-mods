ISColorPicker = ISColorPicker

function ISColorPicker:new(x, y, HSBFactor)
	local buttonSize = 20
	local borderSize = 12
	local columns = 18
	local rows = 12
	local width = columns * buttonSize + borderSize * 2
	local height = rows * buttonSize + borderSize * 2
	local o = ISPanelJoypad.new(self, x, y, width, height)
	o.backgroundColor.a = 1
	o.borderSize = borderSize
	o.buttonSize = buttonSize
	o.columns = columns
	o.rows = rows
	o.index = 1
	o.pickedArgs = {}

	o.colors = {}
	local i = 0
	for red = 0,255,51 do
		for green = 0,255,51 do
			for blue = 0,255,51 do
				local col = i % columns
				local row = math.floor(i / columns)
				if row % 2 == 0 then row = row / 2 else row = math.floor(row / 2) + 6 end
				o.colors[col + row * columns + 1] = { r = red/255, g = green/255, b = blue/255 }
				i = i + 1
			end
		end
	end

	return o
end
