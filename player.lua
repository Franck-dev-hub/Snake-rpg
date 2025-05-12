local player = {}

-- Initialize the snake with a default length and position
function createSnake()
    snake = {
        {x = screenWidth / 2, y = screenHeight / 2},  -- Snake head
        {x = screenWidth / 2 - gridSize, y = screenHeight / 2},
        {x = screenWidth / 2 - 2 * gridSize, y = screenHeight / 2},
        {x = screenWidth / 2 - 3 * gridSize, y = screenHeight / 2},
        {x = screenWidth / 2 - 4 * gridSize, y = screenHeight / 2},
    }
end

-- Move the snake based on the current direction
function moveSnake()
    local head = snake[1]
    local newHead = {x = head.x, y = head.y}

    -- Update the new head's position based on the direction
    if direction == 'right' then
        newHead.x = head.x + gridSize
    elseif direction == 'left' then
        newHead.x = head.x - gridSize
    elseif direction == 'up' then
        newHead.y = head.y - gridSize
    elseif direction == 'down' then
        newHead.y = head.y + gridSize
    end

    -- Add the new head to the front of the snake
    table.insert(snake, 1, newHead)

    -- If the snake hasn't eaten, remove the last segment
    if newHead.x ~= food.x or newHead.y ~= food.y then
        table.remove(snake)
    else
        -- If food is eaten, increase score and spawn new food
        score = score + 1
        spawnFood()
    end
end

-- Check for collisions with the wall or with the snake itself
function checkCollisions()
    local head = snake[1]

    -- Check if the snake hits the screen boundaries
    if head.x < 0 or head.x >= screenWidth or head.y < 0 or head.y >= screenHeight then
        gameOver = true
        newSpeed = speed
    end

    -- Check if the snake collides with itself
    for i = 2, #snake do
        if head.x == snake[i].x and head.y == snake[i].y then
            gameOver = true
            newSpeed = speed
        end
    end
end

return player