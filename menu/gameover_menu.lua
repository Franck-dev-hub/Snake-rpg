-- gameover_menu.lua
local gameover_menu = {}

-- Import menu rendering module
local menu_generic = require("menu.menu_generic")

-- Menu options and selection state
local options = {"Main menu", "Play", "AI Demo", "Quit"}
local selectedOption = 1

-- Initializes the gameover menu font
function gameover_menu.load()
    gameover_menu.menu = menu_generic.new("Snake RPG", {
        {label = "Main menu", action = function()
            gameState.currentState = "menu"
        end},
        {label = "Quit", action = function()
            love.event.quit()
        end}
    })
    gameover_menu.menu.color = {0.86, 0.08, 0.23}
end

-- Updates the gameover menu
function gameover_menu.update(dt)
    
end

-- Draws the demo menu using the menu rendering module
function gameover_menu.draw()
    menu_generic.draw(gameover_menu.menu)
end

-- Handles keyboard input for menu navigation and selection
function gameover_menu.keypressed(key)
    menu_generic.keypressed(gameover_menu.menu, key)
end

return gameover_menu