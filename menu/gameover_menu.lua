-- gameover_menu.lua
local gameover_menu = {}

-- Imports
local menu = require("menu.menu")

-- Variables
local options = {"Main menu", "Play again", "Quit"}
local selectedOption = 1

-- Game over logic
function gameover_menu.load()
	gameover_menu.font = love.graphics.newFont(fontSettings.gameover_menu)
end

function gameover_menu.update(dt)
	
end

function gameover_menu.draw()
	menu.draw(gameover_menu, options, selectedOption)
end

function gameover_menu.keypressed(key, callback)
	if key == "up" then
		selectedOption = selectedOption - 1
		if selectedOption < 1 then selectedOption = 1 end
	elseif key == "down" then
		selectedOption = selectedOption + 1
		if selectedOption > #options then selectedOption = #options end
	elseif key == "return" then
		if selectedOption == 1 then callback("menu") end
		if selectedOption == 2 then callback("play") end
		if selectedOption == 3 then callback("quit") end
	end
end

return gameover_menu