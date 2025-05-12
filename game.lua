local game = {}

-- Spawn a new food item at a random position on the screen
function spawnFood()
    -- Randomly generate food position within the grid
    food.x = math.floor(math.random(0, screenWidth / gridSize - 1)) * gridSize
    food.y = math.floor(math.random(0, screenHeight / gridSize - 1)) * gridSize
    
    -- Increase the snake's speed after each food spawn
    newSpeed = newSpeed + speedStep
end

return game
