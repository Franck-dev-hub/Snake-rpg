-- demo_menu.lua
local demo_menu = {}

-- Import menu rendering module
local menu_generic = require("menu.menu_generic")

-- Menu options and selection state
local options = {"BFS", "A*", "Back"}
local selectedOption = 1

-- Initializes the demo menu font
function demo_menu.load()
    demo_menu.menu = menu_generic.new("Snake RPG", {
        {label = "BFS", action = function()
            state.resetGame()
            gameState.currentState = "bfs"
            gameState.gameState = "bfs_game"
        end},
        --{label = "A star", action = function()
            --state.resetGame()
            --gameState.currentState = "game"
            --gameState.gameState = "a_star_game"
        --end},
        {label = "Back", action = function()
            gameState.currentState = "menu"
        end}
    })
    demo_menu.menu.color = {0.27, 0.51, 0.71}
end

-- Updates the demo menu
function demo_menu.update(dt)
    
end

-- Draws the demo menu using the menu rendering module
function demo_menu.draw()
    menu_generic.draw(demo_menu.menu)
end

-- Handles keyboard input for menu navigation and selection
function demo_menu.keypressed(key)
    menu_generic.keypressed(demo_menu.menu, key)
end

return demo_menu