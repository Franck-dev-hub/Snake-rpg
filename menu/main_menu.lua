-- main_menu.lua
local main_menu = {}

-- Import menu rendering module
local menu_generic = require("menu.menu_generic")

-- Menu options and selection state
local options = {"Play", "AI Demo", "Quit"}
local selectedOption = 1

-- Initializes the main menu font
function main_menu.load()
    main_menu.menu = menu_generic.new("Snake RPG", {
        {label = "Play", action = function()
            state.resetGame()
            gameState.currentState = "game"
            gameState.gameState = "player_game"
        end},
        {label = "AI Demo", action = function()
            state.resetGame()
            gameState.currentState = "demo_menu"
        end},
        {label = "Quit", action = function()
            love.event.quit()
        end}
    })
    main_menu.menu.color = {0.13, 0.55, 0.13} 
end

-- Updates the main menu
function main_menu.update(dt)
    
end

-- Draws the main menu using the menu rendering module
function main_menu.draw()
    menu_generic.draw(main_menu.menu)
end

-- Handles keyboard input for menu navigation and selection
function main_menu.keypressed(key)
    menu_generic.keypressed(main_menu.menu, key)
end

return main_menu