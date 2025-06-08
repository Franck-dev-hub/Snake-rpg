-- bfs.lua
local bfs = {}

-- Configurable AI parameters
bfs.settings = {
    debug = false,
    altPathCount = 100,      -- Number of alternative paths to test
    altPathRadius = 9,       -- Radius around the head for alternative targets
}

local snake_grid = {}
local food_grid = {}
local path = {}

-- Toggle debug mode for AI visualization
function bfs.toggleDebugMode()
    bfs.settings.debug = not bfs.settings.debug
end

-- Build a set of occupied cells by the snake for fast lookup
local function build_snake_set(snake)
    local set = {}
    for i = 1, #snake do
        set[snake[i][1] .. "," .. snake[i][2]] = true
    end
    return set
end

-- Count the number of accessible cells from a given position using BFS
local function count_accessible_cells(start, snake_grid, grid_size)
    local rows, cols = grid_size[1], grid_size[2]
    local directions = {{-1,0},{1,0},{0,-1},{0,1}}
    local visited = {}
    local queue = {start}
    local snake_set = build_snake_set(snake_grid)
    local count = 0
    while #queue > 0 do
        local pos = table.remove(queue, 1)
        local key = pos[1] .. "," .. pos[2]
        if not visited[key] and not snake_set[key]
            and pos[1] >= 0 and pos[1] < rows
            and pos[2] >= 0 and pos[2] < cols then
            visited[key] = true
            count = count + 1
            for _, d in ipairs(directions) do
                local new_pos = {pos[1] + d[1], pos[2] + d[2]}
                table.insert(queue, new_pos)
            end
        end
    end
    return count
end

-- Generate a list of target positions for the AI to consider
local function generate_targets(snake_grid, food_grid, grid_rows, grid_cols, settings)
    local targets = {}
    local head_row, head_col = snake_grid[1][1], snake_grid[1][2]
    local snake_set = build_snake_set(snake_grid)

    -- Always target the food first
    table.insert(targets, food_grid)

    -- Add the tail as an alternative target (useful for avoiding traps)
    if #snake_grid > 1 then
        table.insert(targets, snake_grid[#snake_grid])
    end

    -- Add free cells around the head as alternative targets
    local added = 0
    for dr = -settings.altPathRadius, settings.altPathRadius do
        for dc = -settings.altPathRadius, settings.altPathRadius do
            local r, c = head_row + dr, head_col + dc
            local key = r .. "," .. c
            if r >= 0 and r < grid_rows and c >= 0 and c < grid_cols
                and not snake_set[key]
                and not (r == food_grid[1] and c == food_grid[2])
                and not (r == head_row and c == head_col) then
                table.insert(targets, {r, c})
                added = added + 1
                if added >= settings.altPathCount then
                    return targets
                end
            end
        end
    end
    return targets
end

-- Breadth-First Search (BFS) pathfinding from snake head to target
function bfs.ai_path(snake, target, grid_size)
    local rows, cols = grid_size[1], grid_size[2]
    local directions = {{-1,0},{1,0},{0,-1},{0,1}}
    local queue = {{snake[1], nil}}
    local visited = {}
    local parent = {}
    local snake_set = build_snake_set(snake)
    local found = false
    local end_key = nil

    while #queue > 0 do
        local node = table.remove(queue, 1)
        local pos = node[1]
        local key = pos[1] .. "," .. pos[2]

        if pos[1] == target[1] and pos[2] == target[2] then
            found = true
            end_key = key
            break
        end

        if not visited[key] then
            visited[key] = true
            for _, d in ipairs(directions) do
                local new_pos = {pos[1] + d[1], pos[2] + d[2]}
                local new_key = new_pos[1] .. "," .. new_pos[2]
                if new_pos[1] >= 0 and new_pos[1] < rows and new_pos[2] >= 0 and new_pos[2] < cols
                    and not snake_set[new_key] and not visited[new_key] then
                    parent[new_key] = {key, d}
                    table.insert(queue, {new_pos})
                end
            end
        end
    end

    if found and end_key then
        local path = {}
        local k = end_key
        while parent[k] do
            table.insert(path, 1, parent[k][2])
            k = parent[k][1]
        end
        return path
    end
    return nil
end

-- Select the best path among all targets based on accessible space after the move
local function select_best_path(snake_grid, targets, grid_rows, grid_cols)
    local best = nil
    local best_score = -1
    local best_path = nil
    local path_to_food = nil

    for i, target in ipairs(targets) do
        local p = bfs.ai_path(snake_grid, target, {grid_rows, grid_cols})
        if p and #p > 0 then
            -- Simulate the head position after following this path
            local head = {snake_grid[1][1], snake_grid[1][2]}
            for _, d in ipairs(p) do
                head = {head[1]+d[1], head[2]+d[2]}
            end
            local accessible = count_accessible_cells(head, snake_grid, {grid_rows, grid_cols})
            if i == 1 then
                path_to_food = p
            end
            if accessible > best_score then
                best_score = accessible
                best = i
                best_path = p
            end
        end
    end
    return path_to_food, best_path
end

-- Main AI update function, called every frame
function bfs.update(dt)
    -- Convert positions to grid coordinates
    local gridSize = gameConfig.gridSize
    local grid_rows = gameConfig.rows
    local grid_cols = gameConfig.columns

    -- Convert snake segments to grid coordinates
    snake_grid = {}
    for _, segment in ipairs(snakeState.snake) do
        local col = math.floor(segment.x / gridSize) - 1
        local row = math.floor((segment.y - gameConfig.scoreZoneHeight) / gridSize) - 1
        table.insert(snake_grid, {row, col})
    end

    -- Convert food position to grid coordinates
    local food_col = math.floor(gameState.food.x / gridSize) - 1
    local food_row = math.floor((gameState.food.y - gameConfig.scoreZoneHeight) / gridSize) - 1
    food_grid = {food_row, food_col}

    -- Generate alternative targets
    local targets = generate_targets(snake_grid, food_grid, grid_rows, grid_cols, bfs.settings)

    -- Select the best path
    local path_to_food, best_path = select_best_path(snake_grid, targets, grid_rows, grid_cols)
    path = path_to_food or best_path

    -- Apply movement based on the chosen path
    local move = path and path[1]
    if move and type(move) == "table" and #move == 2 then
        local dx, dy = move[1], move[2]
        local dir
        if dx == -1 and dy == 0 then dir = "up"
        elseif dx == 1 and dy == 0 then dir = "down"
        elseif dx == 0 and dy == -1 then dir = "left"
        elseif dx == 0 and dy == 1 then dir = "right"
        end
        if dir then
            snakeState.directionQueue = {dir}
        end
    else
        -- No path found: try a safe move
        local directions = {
            {dx = -1, dy = 0, dir = "up"},
            {dx = 1, dy = 0, dir = "down"},
            {dx = 0, dy = -1, dir = "left"},
            {dx = 0, dy = 1, dir = "right"}
        }
        local head = snake_grid[1]
        for _, d in ipairs(directions) do
            local nx, ny = head[1] + d.dx, head[2] + d.dy
            local safe = true
            if nx < 0 or nx >= grid_rows or ny < 0 or ny >= grid_cols then
                safe = false
            else
                for i = 2, #snake_grid do
                    if snake_grid[i][1] == nx and snake_grid[i][2] == ny then
                        safe = false
                        break
                    end
                end
            end
            if safe then
                snakeState.directionQueue = {d.dir}
                break
            end
        end
    end

    -- Handle snake movement and collision
    if not gameState.gameOver and not gameState.pause then
        gameState.moveTimer = gameState.moveTimer + dt
        if gameState.moveTimer >= 1 / gameState.newSpeed then
            player.moveSnake()
            player.checkCollisions()
            gameState.moveTimer = 0
        end
    end
end

-- Draw debug information and AI path visualization
function bfs.draw()
    if bfs.settings.debug then
        -- Draw the path
        if path and #path > 0 and snake_grid[1] then
            love.graphics.setColor(1, 1, 0) -- #FFFF00
            local x = (snake_grid[1][2] + 1) * gameConfig.gridSize + gameConfig.gridSize / 2
            local y = (snake_grid[1][1] + 1) * gameConfig.gridSize + gameConfig.gridSize / 2 + gameConfig.scoreZoneHeight
            for _, d in ipairs(path) do
                local nx = x + d[2] * gameConfig.gridSize
                local ny = y + d[1] * gameConfig.gridSize
                love.graphics.line(x, y, nx, ny)
                x, y = nx, ny
            end
        end

        -- Draw the square showing the area of alternative path calculation
        if snake_grid[1] then
            love.graphics.setColor(0, 0.8, 1, 0.1) -- #00CCFF
            local x = (snake_grid[1][2] - bfs.settings.altPathRadius + 1) * gameConfig.gridSize
            local y = (snake_grid[1][1] - bfs.settings.altPathRadius + 1) * gameConfig.gridSize + gameConfig.scoreZoneHeight
            local size = (bfs.settings.altPathRadius * 2 + 1) * gameConfig.gridSize
            love.graphics.rectangle("fill", x, y, size, size)
        end

        -- Debug infos at the bottom left
        love.graphics.setColor(0, 0, 0) -- #000000
        local margin = 10
        local line_height = 20
        local base_y = gameConfig.screenHeight + gameConfig.gridSize + margin
        if snake_grid[1] then
            love.graphics.print("Snake head grid: " .. snake_grid[1][2] .. "," .. snake_grid[1][1], margin, base_y)
        end
        if food_grid then
            love.graphics.print("Food grid: " .. food_grid[2] .. "," .. food_grid[1], margin, base_y + line_height)
            love.graphics.print("Path length: " .. (path and #path or "nil"), margin, base_y + 2 * line_height)
        end
    end
end

return bfs