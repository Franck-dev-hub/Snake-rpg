-- main_menu.lua
local main_menu = {}

-- Imports
local menu = require("menu.menu")

-- Variables
local options = {"Play", "Demo", "Quit"}
local selectedOption = 1

-- Main menu logic
function main_menu.load()
	main_menu.font = love.graphics.newFont(fontSettings.main_menu)
end

function main_menu.update(dt)
	
end

function main_menu.draw()
	menu.draw(main_menu, options, selectedOption)
end

function main_menu.keypressed(key, callback)
	if key == "up" then
		selectedOption = selectedOption - 1
		if selectedOption < 1 then selectedOption = 1 end
	elseif key == "down" then
		selectedOption = selectedOption + 1
		if selectedOption > #options then selectedOption = #options end

	elseif key == "return" then
		if selectedOption == 1 then callback("play") end
		if selectedOption == 2 then callback("demo") end
		if selectedOption == 3 then callback("quit") end
	end
end

return main_menu