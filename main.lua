local player = require("player")
local game = require("game")

-- Set screen dimensions
screenWidth = 800
screenHeight = 600

-- Set grid size (used for snake and food)
gridSize = 20

-- Snake variables
snake = {}  -- Table to store snake body segments
snakeLength = 5 -- Initial length of the snake
direction = 'right' -- Initial movement direction
food = {} -- Food position
score = 0 -- Player's score
gameOver = false -- Game over flag
speed = 4.5 -- Base speed of the snake (units per second)
newSpeed = 4.5 -- Current speed (increased over time)
speedStep = 0.5 -- Speed increase per food eaten
moveTimer = 0 -- Timer to control snake movement

-- Initialize game
function love.load()
    love.window.setMode(screenWidth, screenHeight)
    createSnake() -- Initialize snake
    spawnFood() -- Generate first food item
    score = 0
    gameOver = false
end

-- Main game update function
function love.update(dt)
    if not gameOver then
        moveTimer = moveTimer + dt

        -- Move snake based on speed interval
        if moveTimer >= 1 / newSpeed then
            moveSnake()
            checkCollisions()
            moveTimer = 0
        end
    end
end

-- Render the game elements
function love.draw()
    if gameOver then
        -- Display Game Over screen
        love.graphics.setColor(1, 0, 0)
        love.graphics.print("GAME OVER! Score: " .. score, screenWidth / 2 - 100, screenHeight / 2)
        love.graphics.print("Press 'R' to Restart", screenWidth / 2 - 150, screenHeight / 2 + 30)
        return
    end

    -- Draw the snake
    for i, segment in ipairs(snake) do
        love.graphics.setColor(0, 1, 0)
        love.graphics.rectangle('fill', segment.x, segment.y, gridSize, gridSize)
    end
    
    -- Draw the food
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle('fill', food.x, food.y, gridSize, gridSize)
    
    -- Display the player's score
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Score: " .. score, 10, 10)
end

-- Handle keyboard input
function love.keypressed(key)
    -- Update movement direction
    if key == 'right' and direction ~= 'left' then direction = 'right'
    elseif key == 'left' and direction ~= 'right' then direction = 'left'
    elseif key == 'up' and direction ~= 'down' then direction = 'up'
    elseif key == 'down' and direction ~= 'up' then direction = 'down'
    end

    -- Restart the game after Game Over
    if key == 'r' and gameOver then
        love.load()
    end
end
