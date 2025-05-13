-- main_game.lua
local main_game = {}

-- Imports
local gameover_menu = require("menu.gameover_menu")
local food = require("game.food")

-- Main game logic
function main_game.load()
    main_game.font = love.graphics.newFont(fontSettings.main_game)
end

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

function main_game.draw()
    -- Set parameters
    love.graphics.clear(0.1, 0.1, 0.1)
    love.graphics.setFont(main_game.font)

    -- Display game
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
        
    -- Draw the food
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle('fill', gameState.food.x, gameState.food.y, gameConfig.gridSize, gameConfig.gridSize)
    
    -- Display the player's score
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Score: " .. gameState.score .. "     High score: " .. gameState.highScore, 10, 10)

    -- Display zone of the game
    love.graphics.setColor(1, 1, 1)
    love.graphics.line(0, 0, gameConfig.screenWidth, 0) -- Top line
    love.graphics.line(gameSize.topleft.x, gameSize.topleft.y, gameSize.topright.x, gameSize.topright.y) -- Score underline
    love.graphics.line(gameConfig.screenWidth, 0, gameConfig.screenWidth, gameConfig.screenHeight) -- Right line
    love.graphics.line(gameConfig.screenWidth, gameConfig.screenHeight, 0, gameConfig.screenHeight) -- Bottom line
    love.graphics.line(0, gameConfig.screenHeight, 0, 0) -- Left line
end

function main_game.keypressed(key)
    local lastDirection = #gameState.directionQueue > 0 and gameState.directionQueue[#gameState.directionQueue] or gameState.direction

    -- Update movement direction
    if (key == 'right' and lastDirection ~= 'left') or
       (key == 'left' and lastDirection ~= 'right') or
       (key == 'up' and lastDirection ~= 'down') or
       (key == 'down' and lastDirection ~= 'up') then

        -- If valid, add direction to the table
        if #gameState.directionQueue < 2 then
            table.insert(gameState.directionQueue, key)
        end
    end

    -- Pause game
    if key == "escape" then
        if not gameState.pause then
            gameState.pause = true
        else
            gameState.pause = false
        end
    end
end

return main_game
