-- ia.lua
local ia = {}

local unpack = unpack or table.unpack

function ia.load()

end

function ia.update(dt)
    -- Convert positions to the grid
    local gridSize = gameConfig.gridSize
    local grid_rows = math.floor(gameConfig.screenHeight / gridSize)
    local grid_cols = math.floor(gameConfig.screenWidth / gridSize)

    -- Convert snake to the grid
    local snake_grid = {}
    for i, segment in ipairs(snakeState.snake) do
        table.insert(snake_grid, {
            math.floor(segment.y / gridSize),
            math.floor(segment.x / gridSize)
        })
    end

    -- Convert food to the grid
    local food_grid = {
        math.floor(gameState.food.y / gridSize),
        math.floor(gameState.food.x / gridSize)
    }

    -- Path finder
    local path = ia.bfs_path(snake_grid, food_grid, {grid_rows, grid_cols})
    print("Snake grid head:", snake_grid[1][1], snake_grid[1][2])
    print("Food grid:", food_grid[1], food_grid[2])
    print("Path IA:", path and #path or "nil")

    -- Apply movement
    if path and #path > 0 then
        local move = path[1]
        if type(move) == "table" and #move == 2 then
            local dx, dy = move[1], move[2]
            local dir
            if dx == -1 and dy == 0 then dir = "up"
            elseif dx == 1 and dy == 0 then dir = "down"
            elseif dx == 0 and dy == -1 then dir = "left"
            elseif dx == 0 and dy == 1 then dir = "right"
            end
            print("Premier move IA :", dx, dy)
            print("Direction IA choisie :", dir)
            if dir then
                gameState.directionQueue = {dir}
            end
        else
            print("Aucun move trouvé par l'IA")
        end
    else
        print("Aucun chemin trouvé par l'IA")
    end


    -- Snake movement
    if not gameState.gameOver and not gameState.pause then
        gameState.moveTimer = gameState.moveTimer + dt

        -- Move snake based on speed interval
        if gameState.moveTimer >= 1 / gameState.newSpeed then
            moveSnake()
            checkCollisions()
            gameState.moveTimer = 0
        end
    end
end

function ia.draw()

end

function ia.keypressed(key)

end

-- BFS function (Breadth-First Search)
function ia.bfs_path(snake, food, grid_size)
    -- Fetch grid size
    local rows, cols = grid_size[1], grid_size[2]

    -- Posible directions
    local directions = {{-1,0},{1,0},{0,-1},{0,1}}

    -- Init data structures
    local visited = {} -- Already explored tiles
    local queue = {} -- Research queue

    -- Enqueue snake head position
    table.insert(queue, {snake[1], {}})
    visited[snake[1][1] .. "," .. snake[1][2]] = true

    -- Create an assembly for body position
    local snake_set = {}
    for i = 2, #snake do
        snake_set[snake[i][1] .. "," .. snake[i][2]] = true
    end

    -- Main BFS loop
    while #queue > 0 do
        local node = table.remove(queue, 1)
        local pos, path = node[1], node[2]

        -- Check if actual position is food
        if pos[1] == food[1] and pos[2] == food[2] then
            if #path == 0 then
                return nil -- No path find
            end
            return path -- Return path
        end

        -- Explore directions
        for _, d in ipairs(directions) do
            local new_pos = {pos[1] + d[1], pos[2] + d[2]}
            local key = new_pos[1] .. "," .. new_pos[2]

            -- Check movement direction
            if new_pos[1] >= 0 and new_pos[1] < rows and
               new_pos[2] >= 0 and new_pos[2] < cols and
               not visited[key] and
               not snake_set[key] then

                -- Create new path
                local new_path = {unpack(path)}
                table.insert(new_path, d)
                table.insert(queue, {new_pos, new_path})
                visited[key] = true
            end
        end
    end

    -- Return nil if no path found
    return nil
end

return ia