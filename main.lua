-- main.lua
io.stdout:setvbuf("no")

-- lua files
local player = require("game.player")
local main_game = require("game.main_game")
local menu = require("menu.menu")
local state = require("game.state")
local main_menu = require("menu.main_menu")
local gameover_menu = require("menu.gameover_menu")
local ia = require("ia.ia")

--imports
json = require("libs.json")

gameConfig = {
    screenWidth = 800, -- Set screen width
    screenHeight = 600, -- Set screen height
    gridSize = 20, -- Set grid size (used for snake and food)
    gameDatas = {},
}

fontSettings = {
    font_path = "assets/font/menu.ttf",
    main_menu = 25,
    main_game = 16,
    gameover_menu = 25,
}

gameSize = {
    topleft = {x = 0, y = gameConfig.gridSize * 2},
    topright = {x = gameConfig.screenWidth, y = gameConfig.gridSize * 2},
    bottomright = {x = gameConfig.screenWidth, y = gameConfig.screenHeight},
    bottomleft = {x = 0, y = gameConfig.screenHeight},
}

-- Snake variables
snakeState = {
    snake = {}, -- Table to store snake body segments
    snakeLength = 5, -- Initial length of the snake
    direction = 'right', -- Initial movement direction
    directionQueue = {}, -- Next movement direction
}

-- Game Variables
gameState = {
    food = {}, -- Food position
    score = 0, -- Player's score
    highScore = 0, -- Player's best score
    gameOver = false, -- Game over flag
    speed = 4.5, -- Base speed of the snake (units per second)
    newSpeed = 4.5, -- Current speed (increased over time)
    speedStep = 0.5, -- Speed increase per food eaten
    moveTimer = 0, -- Timer to control snake movement
    pause = false, -- Pause flag
    currentState = "menu", -- Main menu selection
}

-- Initialize game
function love.load()
    -- Seed the random number generator
    math.randomseed(os.time())

    -- Nearest-neighbor filtering
    love.graphics.setDefaultFilter("nearest", "nearest")

    -- Load menus
    menu.load(fontSettings)
    main_menu.load()
    main_game.load()
    gameover_menu.load()

    -- Load or create player_stats file
    if love.filesystem.getInfo("player_stats.json") then state.loadDatas() else state.saveDatas() end 

    -- Set window size
    love.window.setMode(gameConfig.screenWidth, gameConfig.screenHeight)

    -- Reset variables for a new game
    state.resetGame()
end

-- Main game update function
function love.update(dt)
    if gameState.currentState == "menu" then
        main_menu.update(dt)
    elseif gameState.currentState == "demo" then
        ia.update(dt)
    elseif gameState.currentState == "gameover" then
        gameover_menu.update(dt)
    else
        main_game.update(dt)
    end
end

-- Render the game elements
function love.draw()
    if gameState.currentState == "menu" then
        main_menu.draw()
    else
        main_game.draw()
    end
end

-- Handle keyboard input
function love.keypressed(key)
    if gameState.currentState == "menu" then
        main_menu.keypressed(key, function(action)
            if action == "play" then
                state.resetGame()
                gameState.currentState = "game"
            elseif action == "demo" then
                state.resetGame()
                gameState.currentState = "demo"
            elseif action == "quit" then
                love.event.quit()
            end
        end)
    elseif gameState.currentState == "gameover" then
        gameover_menu.keypressed(key, function(action)
            if action == "menu" then
                gameState.currentState = "menu"
            elseif action == "play" then
                state.resetGame()
                gameState.currentState = "game"
            elseif action == "quit" then
                love.event.quit()
            end
        end) 
    elseif gameState.currentState ~= "demo" then
        main_game.keypressed(key)
    end
end