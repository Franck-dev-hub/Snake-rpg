-- player.lua
local player = {}

-- Imports
local food = require("game.food")
local state = require("game.state")

-- Initializes the snake with a default length and position at the center of the grid
function createSnake()
    local centerX = math.floor(gameConfig.columns / 2)
    local centerY = math.floor(gameConfig.rows / 2)
    snakeState.snake = {
        {
            x = centerX * gameConfig.gridSize,
            y = centerY * gameConfig.gridSize + gameConfig.scoreZoneHeight
        },
        {
            x = (centerX - 1) * gameConfig.gridSize,
            y = centerY * gameConfig.gridSize + gameConfig.scoreZoneHeight
        },
        {
            x = (centerX - 2) * gameConfig.gridSize,
            y = centerY * gameConfig.gridSize + gameConfig.scoreZoneHeight
        },
        {
            x = (centerX - 3) * gameConfig.gridSize,
            y = centerY * gameConfig.gridSize + gameConfig.scoreZoneHeight
        },
        {
            x = (centerX - 4) * gameConfig.gridSize,
            y = centerY * gameConfig.gridSize + gameConfig.scoreZoneHeight
        }
    }
end

-- Moves the snake based on the current direction and handles food consumption
function moveSnake()
    local head = snakeState.snake[1]
    local newHead = {x = head.x, y = head.y}

    -- Update direction from the queue if available
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

    -- Insert the new head at the front of the snake
    table.insert(snakeState.snake, 1, newHead)

    -- If the snake hasn't eaten, remove the last segment
    if newHead.x ~= gameState.food.x or newHead.y ~= gameState.food.y then
        table.remove(snakeState.snake)
    else
        if gameState.gameState == "player_game" then
            -- If food is eaten, increase score and spawn new food
            gameState.score = gameState.score + 1
            if game_high_score.high_score <= gameState.score then
                game_high_score.high_score = gameState.score
            end
        elseif gameState.gameState == "bfs_game" then
            -- If food is eaten, increase score and spawn new food
            gameState.score = gameState.score + 1
            if game_high_score.bfs_high_score <= gameState.score then
                game_high_score.bfs_high_score = gameState.score
            end
        end
        food.spawnFood()
    end
end

-- Checks for collisions with the wall or with the snake itself
function checkCollisions()
    local head = snakeState.snake[1]

    local function handleGameOver()
        gameState.gameOver = true
        gameState.newSpeed = gameState.speed
        if gameState.gameState == "player_game" then
            state.setVar("Highscore", game_high_score.high_score)
            state.save()
        elseif gameState.gameState == "bfs_game" then
            state.setVar("BFS_Highscore", game_high_score.bfs_high_score)
            state.save()
        end
    end

    -- Check horizontal boundaries
    if head.x < 0 or head.x >= gameConfig.columns * gameConfig.gridSize then
        handleGameOver()
        return
    end

    -- Check vertical boundaries (considering scoreZoneHeight offset)
    if head.y < gameConfig.scoreZoneHeight or head.y >= gameConfig.rows * gameConfig.gridSize + gameConfig.scoreZoneHeight then
        handleGameOver()
        return
    end

    -- Check if the snake collides with itself
    for i = 2, #snakeState.snake do
        if head.x == snakeState.snake[i].x and head.y == snakeState.snake[i].y then
            handleGameOver()
            return
        end
    end
end

return player