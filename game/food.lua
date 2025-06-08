-- food.lua
local food = {}

-- Spawns a new food item at a random position on the grid, avoiding the snake's body
function food.spawnFood()
    local validPosition = false

    while not validPosition do
        local foodGridX = math.random(1, gameConfig.columns)
        local foodGridY = math.random(1, gameConfig.rows)

        gameState.food.x = foodGridX * gameConfig.gridSize
        gameState.food.y = foodGridY * gameConfig.gridSize + gameConfig.scoreZoneHeight

        validPosition = true
        for i, segment in ipairs(snakeState.snake) do
            if segment.x == gameState.food.x and segment.y == gameState.food.y then
                validPosition = false
                break
            end
        end
    end

    if gameState.gameState == "player_game" then
        gameState.newSpeed = gameState.newSpeed + gameState.speedStep
    elseif gameState.gameState == "bfs_game" or gameState.gameState == "a_star_game" then
        gameState.newSpeed = aiSettings.aiSpeed
    end
end



return food