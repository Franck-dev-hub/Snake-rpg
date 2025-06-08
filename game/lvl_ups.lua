-- lvl_ups.lua
local lvl_ups = {}

local step_lvl = {0, 50, 100, 200, 300, 400, 500}
local buff_level = 1
local after_level = 1
local level_up_timer = 0
local level_up_message = false
local sizes = {
    [1] = {cols = 5, rows = 5},
    [2] = {cols = 7, rows = 7},
    [3] = {cols = 9, rows = 9},
    [4] = {cols = 11, rows = 11},
    [5] = {cols = 13, rows = 13},
    [6] = {cols = 15, rows = 15},
}

function lvl_ups.get_level(xp)
    local level = 1
    for i = #step_lvl, 1, -1 do
        if xp >= step_lvl[i] then
            level = i
            break
        end
    end
    return level
end

function lvl_ups.apply_level(lvl)
    local s = sizes[lvl] or sizes[6]
    local gridSizeX = math.floor(gameConfig.screenWidth / s.cols)
    local gridSizeY = math.floor((gameConfig.screenHeight - gameConfig.scoreZoneHeight) / s.rows)
    gameConfig.gridSize = math.min(gridSizeX, gridSizeY)
    gameConfig.columns = s.cols
    gameConfig.rows = s.rows
    -- Update game size
    gameConfig.realWidth = gameConfig.gridSize * (gameConfig.columns + 2)
	gameConfig.realHeight = gameConfig.gridSize * (gameConfig.rows + 2)

    lvl_ups.updateGameSize()
end

function lvl_ups.check_level_up(xp)
    after_level = lvl_ups.get_level(xp)
    if buff_level ~= after_level then
        buff_level = after_level
        lvl_ups.apply_level(buff_level)
		love.window.setMode(gameConfig.realWidth, gameConfig.realHeight + gameConfig.scoreZoneHeight, {resizable = false, fullscreen = false, vsync = true})
        state.resetGame()
    end
    return buff_level
end

function lvl_ups.updateGameSize()
    gameSize.columns = gameConfig.columns
    gameSize.rows = gameConfig.rows
    gameSize.gameWidth = gameConfig.realWidth
    gameSize.gameHeight = gameConfig.realHeight
	gameSize.topleft = {x = 0, y = gameConfig.scoreZoneHeight}
	gameSize.topright = {x = gameConfig.realWidth, y = gameConfig.scoreZoneHeight}
	gameSize.bottomright = {x = gameConfig.realWidth, y = gameConfig.realHeight + gameConfig.scoreZoneHeight}
	gameSize.bottomleft = {x = 0, y = gameConfig.realHeight + gameConfig.scoreZoneHeight}

end

return lvl_ups