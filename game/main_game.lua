-- main_game.lua
local main_game = {}

-- Imports
local gameover_menu = require("menu.gameover_menu")
local food = require("game.food")
local bfs = require("ai.bfs")

-- Initializes the main game font
function main_game.load()
    main_game.font = love.graphics.newFont(fontSettings.main_game)
end

-- Updates the main game logic, including snake movement and collision detection
function main_game.update(dt)
    if not gameState.gameOver and not gameState.pause then
        gameState.moveTimer = gameState.moveTimer + dt

        -- Move snake based on speed interval
        if gameState.moveTimer >= 1 / gameState.newSpeed then
            moveSnake()
            checkCollisions()
            gameState.moveTimer = 0
        end
    end
end

-- Draws the main game, including the snake, food, score, and game boundaries
function main_game.draw()
    love.graphics.clear(0.1, 0.1, 0.1)
    love.graphics.setFont(main_game.font)

    -- If the game is over, switch to the game over menu
    if gameState.gameOver then
        gameState.currentState = "gameover"
        gameover_menu.draw()
        return
    end

    -- Draw the snake
    for i, segment in ipairs(snakeState.snake) do
        love.graphics.setColor(0, 1, 0)
        if i == 1 then
            love.graphics.rectangle('fill', segment.x, segment.y, gameConfig.gridSize, gameConfig.gridSize)
        else
            love.graphics.rectangle('fill', segment.x + 1, segment.y + 1, gameConfig.gridSize - 2, gameConfig.gridSize - 2)
        end
    end

    -- Draw AI interface if in demo mode
    if gameState.currentState == "bfs" then
        bfs.draw()
    end

    -- Draw the food
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle('fill', gameState.food.x, gameState.food.y, gameConfig.gridSize, gameConfig.gridSize)

    -- Display the player's score and high score
    love.graphics.setColor(1, 1, 1)
    if gameState.gameState == "player_game" then
        love.graphics.print("Score: " .. gameState.score .. "     High score: " .. game_high_score.high_score, 10, 10)
    elseif gameState.gameState == "bfs_game" then
        love.graphics.print("Score: " .. gameState.score .. "     BFS High score: " .. game_high_score.bfs_high_score, 10, 10)
    end

    -- Draw game boundaries and score zone underline
    love.graphics.setColor(1, 1, 1)
    love.graphics.line(0, 0, gameConfig.screenWidth, 0) -- Top line
    love.graphics.line(0, 40, gameConfig.screenWidth, 40) -- Score underline
    love.graphics.line(gameConfig.screenWidth, 0, gameConfig.screenWidth, gameConfig.screenHeight) -- Right line
    love.graphics.line(gameConfig.screenWidth, gameConfig.screenHeight, 0, gameConfig.screenHeight) -- Bottom line
    love.graphics.line(0, gameConfig.screenHeight, 0, 0) -- Left line
end

-- Handles keyboard input for controlling the snake and pausing the game
function main_game.keypressed(key)
    local lastDirection = #gameState.directionQueue > 0 and gameState.directionQueue[#gameState.directionQueue] or gameState.direction

    -- Update movement direction if valid
    if (key == 'right' and lastDirection ~= 'left') or
       (key == 'left' and lastDirection ~= 'right') or
       (key == 'up' and lastDirection ~= 'down') or
       (key == 'down' and lastDirection ~= 'up') then

        -- Add direction to the queue if not full
        if #gameState.directionQueue < 2 then
            table.insert(gameState.directionQueue, key)
        end
    end

    if gameState.currentState == "bfs" then
        if key == "d" then
            bfs.toggleDebugMode()
        end
    end

    -- Toggle pause state
    if key == "escape" then
        gameState.pause = not gameState.pause
    end
end

return main_game