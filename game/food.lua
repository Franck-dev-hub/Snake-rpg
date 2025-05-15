-- food.lua
local food = {}

-- Spawns a new food item at a random position on the grid, avoiding the snake's body
function food.spawnFood()
    local validPosition = false

    while not validPosition do
        -- Choose a random cell in the grid
        local foodGridX = math.random(0, gameConfig.columns - 1)
        local foodGridY = math.random(0, gameConfig.rows - 1)

        gameState.food.x = foodGridX * gameConfig.gridSize
        gameState.food.y = foodGridY * gameConfig.gridSize + gameConfig.scoreZoneHeight

        validPosition = true
        -- Ensure the food does not spawn on the snake
        for i, segment in ipairs(snakeState.snake) do
            if segment.x == gameState.food.x and segment.y == gameState.food.y then
                validPosition = false
                break
            end
        end
    end

    -- Adjust snake speed based on game state
    if gameState.currentState == "game" then
        gameState.newSpeed = gameState.newSpeed + gameState.speedStep
    elseif gameState.currentState == "bfs" or gameState.currentState == "a_star" then
        gameState.newSpeed = aiSettings.aiSpeed
    end
end

return food