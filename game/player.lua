-- player.lua
local player = {}

-- Imports
local food = require("game.food")
local state = require("game.state")

-- Initializes the snake with a default length and position at the center of the grid
function player.createSnake()
    local centerX = math.floor(gameConfig.columns / 2)
    local centerY = math.floor(gameConfig.rows / 2)

    snakeState.snake = {}
    for i = 0, snakeState.snake_length - 1 do
        table.insert(snakeState.snake, {
            x = (centerX - i) * gameConfig.gridSize,
            y = centerY * gameConfig.gridSize + gameConfig.scoreZoneHeight
        })
    end
end

-- Moves the snake based on the current direction and handles food consumption
function player.moveSnake()
    local head = snakeState.snake[1]
    local newHead = {x = head.x, y = head.y}

    -- Update direction from the queue if available
    if #snakeState.directionQueue > 0 then
        snakeState.direction = table.remove(snakeState.directionQueue, 1)
    end

    -- Update the new head's position based on the direction
    if snakeState.direction == 'right' then
        newHead.x = head.x + gameConfig.gridSize
    elseif snakeState.direction == 'left' then
        newHead.x = head.x - gameConfig.gridSize
    elseif snakeState.direction == 'up' then
        newHead.y = head.y - gameConfig.gridSize
    elseif snakeState.direction == 'down' then
        newHead.y = head.y + gameConfig.gridSize
    end

    -- Insert the new head at the front of the snake
    table.insert(snakeState.snake, 1, newHead)

    -- If the snake hasn't eaten, remove the last segment
    if newHead.x ~= gameState.food.x or newHead.y ~= gameState.food.y then
        table.remove(snakeState.snake)
    else
        if gameState.gameState == "player_game" then
            gameState.score = gameState.score + 1
            game_high_score.xp = game_high_score.xp + 1
            if game_high_score.high_score <= gameState.score then
                game_high_score.high_score = gameState.score
            end
        elseif gameState.gameState == "bfs_game" then
            gameState.score = gameState.score + 1
            if game_high_score.bfs_high_score <= gameState.score then
                game_high_score.bfs_high_score = gameState.score
            end
        end
        food.spawnFood()
    end
end

-- Checks for collisions with the wall or with the snake itself
function player.checkCollisions()
    local head = snakeState.snake[1]

    -- Collision avec les murs (bordures blanches)
    if head.x < gameConfig.gridSize or head.x >= (gameConfig.columns + 1) * gameConfig.gridSize or
       head.y < gameConfig.scoreZoneHeight + gameConfig.gridSize or head.y >= (gameConfig.rows + 1) * gameConfig.gridSize + gameConfig.scoreZoneHeight then
        player.handleGameOver()
        return
    end

    -- Collision avec soi-même
    for i = 2, #snakeState.snake do
        if head.x == snakeState.snake[i].x and head.y == snakeState.snake[i].y then
            player.handleGameOver()
            return
        end
    end
end

function player.handleGameOver()
    gameState.gameOver = true
    gameState.newSpeed = gameState.speed
    if gameState.gameState == "player_game" then
        state.setVar("xp", game_high_score.xp)
        state.setVar("Highscore", game_high_score.high_score)
        state.save()
    elseif gameState.gameState == "bfs_game" then
        state.setVar("BFS_Highscore", game_high_score.bfs_high_score)
        state.save()
    end
end

return player