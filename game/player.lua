-- player.lua
local player = {}

-- Imports
local food = require("game.food")
local state = require("game.state")

-- Initialize the snake with a default length and position
function createSnake()
    snakeState.snake = {
        {x = gameConfig.screenWidth / 2, y = gameConfig.screenHeight / 2},  -- Snake head
        {x = gameConfig.screenWidth / 2 - gameConfig.gridSize, y = gameConfig.screenHeight / 2},
        {x = gameConfig.screenWidth / 2 - 2 * gameConfig.gridSize, y = gameConfig.screenHeight / 2},
        {x = gameConfig.screenWidth / 2 - 3 * gameConfig.gridSize, y = gameConfig.screenHeight / 2},
        {x = gameConfig.screenWidth / 2 - 4 * gameConfig.gridSize, y = gameConfig.screenHeight / 2},
    }
end

-- Move the snake based on the current direction
function moveSnake()
    local head = snakeState.snake[1]
    local newHead = {x = head.x, y = head.y}

    -- Update next direction if valid
    if #gameState.directionQueue > 0 then
        gameState.direction = table.remove(gameState.directionQueue, 1)
    end
    
    -- Update the new head's position based on the direction
    if gameState.direction == 'right' then
        newHead.x = head.x + gameConfig.gridSize
    elseif gameState.direction == 'left' then
        newHead.x = head.x - gameConfig.gridSize
    elseif gameState.direction == 'up' then
        newHead.y = head.y - gameConfig.gridSize
    elseif gameState.direction == 'down' then
        newHead.y = head.y + gameConfig.gridSize
    end

    -- Add the new head to the front of the snake
    table.insert(snakeState.snake, 1, newHead)

    -- If the snake hasn't eaten, remove the last segment
    if newHead.x ~= gameState.food.x or newHead.y ~= gameState.food.y then
        table.remove(snakeState.snake)
    else
        -- If food is eaten, increase score and spawn new food
        gameState.score = gameState.score + 1
        if gameState.highScore <= gameState.score then gameState.highScore = gameState.score end
        food.spawnFood()
    end
end

-- Check for collisions with the wall or with the snake itself
function checkCollisions()
    local head = snakeState.snake[1]

    -- Check if the snake hits the screen boundaries
    if head.x < 0 or head.x >= gameConfig.screenWidth or head.y < gameConfig.gridSize * 2 or head.y >= gameConfig.screenHeight then
        gameState.gameOver = true
        gameState.newSpeed = gameState.speed
        state.saveDatas()
        return
    end

    -- Check if the snake collides with itself
    for i = 2, #snakeState.snake do
        if head.x == snakeState.snake[i].x and head.y == snakeState.snake[i].y then
            gameState.gameOver = true
            gameState.newSpeed = gameState.speed
            state.saveDatas()
            return
        end
    end
end

return player