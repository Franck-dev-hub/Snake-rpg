-- food.lua
local food = {}

-- Spawn a new food item at a random position on the screen
function food.spawnFood()
    local validPosition = false

    while not validPosition do
        -- Randomly generate food position within the grid
        gameState.food.x = math.floor(math.random(0, gameConfig.screenWidth / gameConfig.gridSize - 1)) * gameConfig.gridSize
        gameState.food.y = math.floor(math.random(0, (gameConfig.screenHeight / gameConfig.gridSize) - 3)) * gameConfig.gridSize + (2 * gameConfig.gridSize)

        validPosition = true

        for i, segment in ipairs(snakeState.snake) do
            if segment.x == gameState.food.x and segment.y == gameState.food.y then
                validPosition = false
                break
            end
        end
    end
    
    -- Increase the snake's speed after each food spawn
    gameState.newSpeed = gameState.newSpeed + gameState.speedStep
end

return food