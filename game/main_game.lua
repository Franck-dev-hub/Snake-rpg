-- main_game.lua
local main_game = {}

-- Imports
local gameover_menu = require("menu.gameover_menu")
local food = require("game.food")
local bfs = require("ai.bfs")

-- Initializes the main game font
function main_game.load()
    main_game.font = love.graphics.newFont(fontSettings.main_game)
end

-- Updates the main game logic, including snake movement and collision detection
function main_game.update(dt)
    if not gameState.gameOver and not gameState.pause then
        gameState.moveTimer = gameState.moveTimer + dt
        lvl_ups.check_level_up(game_high_score.xp)

        -- Move snake based on speed interval
        if gameState.moveTimer >= 1 / gameState.newSpeed then
            player.moveSnake()
            player.checkCollisions()
            gameState.moveTimer = 0
        end
    end
end

-- Draws the main game, including the snake, food, score, and game boundaries
function main_game.draw()
    local size = gameConfig.gridSize
    love.graphics.clear(0.1, 0.1, 0.1) -- #1A1A1A
    love.graphics.setFont(main_game.font)

    main_game.display_score()
    main_game.draw_walls()
    main_game.draw_snake()
    main_game.gameover_state()

    if gameState.currentState == "bfs" then
        bfs.draw()
    end

    if not gameState.gameOver then
        love.graphics.setColor(1, 0, 0) -- #FF0000
        love.graphics.circle(
            'fill',
            gameState.food.x + size / 2,
            gameState.food.y + size / 2,
            size / 2 * 0.7
        )
    end
end

-- Handles keyboard input for controlling the snake and pausing the game
function main_game.keypressed(key)
    local lastDirection = #snakeState.directionQueue > 0 and snakeState.directionQueue[#snakeState.directionQueue] or snakeState.direction

    -- Update movement direction if valid
    if (key == 'right' and lastDirection ~= 'left') or
       (key == 'left' and lastDirection ~= 'right') or
       (key == 'up' and lastDirection ~= 'down') or
       (key == 'down' and lastDirection ~= 'up') then

        -- Add direction to the queue if not full
        if #snakeState.directionQueue < 2 then
            table.insert(snakeState.directionQueue, key)
        end
    end

    if gameState.currentState == "bfs" then
        if key == "d" then
            bfs.toggleDebugMode()
        end
    end

    -- Toggle pause state
    if key == "escape" then
        gameState.pause = not gameState.pause
    end
end

function main_game.game_size()
    lvl_ups.get_level(game_high_score.xp)
end

function main_game.draw_walls()
    local size = gameConfig.gridSize
    love.graphics.setColor(1, 1, 1) -- #FFFFFF

    -- Vertical walls
    for row = 0, gameConfig.rows + 1 do
        local y = row * size + gameConfig.scoreZoneHeight
        -- Left wall
        love.graphics.rectangle('fill', 0, y, size, size)
        -- Right wall
        love.graphics.rectangle('fill', (gameConfig.columns + 1) * size, y, size, size)
    end

    -- Horizontal walls
    for col = 0, gameConfig.columns + 1 do
        local x = col * size
        -- Top wall
        love.graphics.rectangle('fill', x, gameConfig.scoreZoneHeight, size, size)
        -- Bottom wall
        love.graphics.rectangle('fill', x, (gameConfig.rows + 1) * size + gameConfig.scoreZoneHeight, size, size)
    end
end
    
function main_game.draw_snake()
    -- Draw the snake segments
    local size = gameConfig.gridSize
    for i, segment in ipairs(snakeState.snake) do
        if i == 1 then
            -- Tongue parameters
            local tongueLength = size
            local tongueWidth = 2
            local startX = segment.x + size / 2
            local startY = segment.y + size / 2
            local endX, endY = startX, startY

            -- Calculate the tongue end position based on snake direction
            if snakeState.direction == 'left' then
                endX = startX - tongueLength
            elseif snakeState.direction == 'right' then
                endX = startX + tongueLength
            elseif snakeState.direction == 'up' then
                endY = startY - tongueLength
            elseif snakeState.direction == 'down' then
                endY = startY + tongueLength
            end

            -- Draw the tongue
            love.graphics.setColor(1, 0, 0) -- #FF0000
            love.graphics.setLineWidth(tongueWidth)
            love.graphics.line(startX, startY, endX, endY)

            -- Draw the snake head
            love.graphics.setColor(0, 1, 0) -- #00FF00
            love.graphics.rectangle('fill', segment.x, segment.y, size, size)

        else
            -- Draw the snake body segments
            love.graphics.setColor(0, 1, 0) -- #00FF00
            love.graphics.rectangle('fill', segment.x, segment.y, size, size)
        end
    end
end

function main_game.display_score()
    -- Display the player's score and high score
    local margin = 10
    local padding = 100
    love.graphics.setColor(1, 1, 1) -- #FFFFFF
    if gameState.gameState == "player_game" then
        love.graphics.print("Score: " .. gameState.score, margin, margin)
        love.graphics.print("High score: " .. game_high_score.high_score, margin + padding, margin)
        love.graphics.print("XP: " .. game_high_score.xp, margin + padding * 2.5, margin)
    elseif gameState.gameState == "bfs_game" then
        love.graphics.print("Score: " .. gameState.score, margin, margin)
        love.graphics.print("BFS High score: " .. game_high_score.bfs_high_score, margin + padding, margin)
    end

    -- Draw game boundaries and score zone underline
    love.graphics.setColor(1, 1, 1) -- #FFFFFF
    love.graphics.line(0, 0, gameConfig.screenWidth, 0) -- Top line
    love.graphics.line(0, 40, gameConfig.screenWidth, 40) -- Score underline
    love.graphics.line(gameConfig.screenWidth, 0, gameConfig.screenWidth, 40) -- Right line
    love.graphics.line(0, 0, 0, 40) -- Left line
end

function main_game.gameover_state()
    -- If the game is over, switch to the game over menu
    if gameState.gameOver then
        gameState.currentState = "gameover"
        gameover_menu.draw()
        return
    end
end

return main_game