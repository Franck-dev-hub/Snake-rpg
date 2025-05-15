-- main.lua
io.stdout:setvbuf("no")

-- Modules
local modules = {
    player = "game.player",
    main_game = "game.main_game",
    menu_generic = "menu.menu_generic",
    state = "game.state",
    main_menu = "menu.main_menu",
    demo_menu = "menu.demo_menu",
    gameover_menu = "menu.gameover_menu",
    bfs = "ai.bfs",
    lvl_ups = "game.lvl_ups",
    json = "libs.json"
}
 
-- Import modules 
for name, path in pairs(modules) do
    _G[name] = require(path)
end

-- Game configuration
gameConfig = {
    screenWidth = 800,
    screenHeight = 600,
    scoreZoneHeight = 40,
    gameDatas = {},
}

-- Font settings
fontSettings = {
    font_path = "assets/font/menu.ttf",
    main_menu = 25,
    main_game = 16,
    gameover_menu = 25,
}

-- Game area coordinates
gameSize = {
    gameWidth = gameConfig.screenWidth,
    gameHeight = gameConfig.screenHeight - gameConfig.scoreZoneHeight,
    columns = 5,
    rows = 5,
    topleft = {x = 0, y = gameConfig.scoreZoneHeight},
    topright = {x = gameConfig.screenWidth, y = gameConfig.scoreZoneHeight},
    bottomright = {x = gameConfig.screenWidth, y = gameConfig.screenHeight + gameConfig.scoreZoneHeight},
    bottomleft = {x = 0, y = gameConfig.screenHeight + gameConfig.scoreZoneHeight},
}

-- Snake state
snakeState = {
    snake = {},                 -- Snake body segments
    snake_length = 2,           -- Initial snake length
    direction = 'right',        -- Initial movement direction
    directionQueue = {},        -- Direction queue for buffered input
}

-- Ai Settingslua
aiSettings = {
    aiSpeed = 10,               -- Ai speed 
    altPath = 10,               -- Number of calculated path
    algo = "bfs",               -- Select ai algorithm
}

-- Game state
gameState = {
    food = {},                  -- Food position
    score = 0,                  -- Current score
    gameOver = false,           -- Game over flag
    speed = 4.8,                -- Base snake speed (units/sec)
    newSpeed = 4.8,             -- Current snake speed
    speedStep = 0.2,            -- Speed increment per food
    moveTimer = 0,              -- Snake movement timer
    pause = false,              -- Pause flag
    currentState = "menu",      -- Current game state
    gameState = "player_game",  -- Selected game state
}

-- Game Score
game_high_score = {
    high_score = 0,             -- Best score
    bfs_high_score = 0,         -- Best BFS score
    xp = 0,                     -- Player experience
}

-- Game initialization
function love.load()
    math.randomseed(os.time())
    love.graphics.setDefaultFilter("nearest", "nearest")

    menu_generic.load(fontSettings)
    main_menu.load()
    main_game.load()
    demo_menu.load()
    gameover_menu.load()

    -- Load / init player statistics
    state.load()
    if state.getVar("Highscore") == nil then
        state.setVar("Highscore", game_high_score.high_score)
    else
        game_high_score.high_score = state.getVar("Highscore")
    end

    if state.getVar("BFS_Highscore") == nil then
        state.setVar("BFS_Highscore", game_high_score.bfs_high_score)
    else
        game_high_score.bfs_high_score = state.getVar("BFS_Highscore")
    end

    if state.getVar("xp") == nil then
        state.setVar("xp", game_high_score.xp)
    else
        game_high_score.xp = state.getVar("xp")
    end

    -- Applique le niveau initial pour définir gridSize, columns, rows, etc.
    lvl_ups.apply_level(lvl_ups.get_level(game_high_score.xp))

    main_game.game_size()
    love.window.setMode(gameConfig.realWidth, gameConfig.realHeight + gameConfig.scoreZoneHeight, {resizable = false, fullscreen = false, vsync = true})
    state.resetGame()
end

-- Main update loop
function love.update(dt)
    local stateHandlers = {
        menu = main_menu.update,
        demo_menu = demo_menu.update,
        bfs = bfs.update,
        gameover = gameover_menu.update,
    }
    local handler = stateHandlers[gameState.currentState] or main_game.update
    handler(dt)
    main_game.game_size()
end


function love.draw()
    local stateHandlers = {
        menu = main_menu.draw,
        demo_menu = demo_menu.draw,
    }
    local handler = stateHandlers[gameState.currentState] or main_game.draw
    handler()
end

function love.keypressed(key)
    if gameState.currentState == "menu" then
        main_menu.keypressed(key, function(action)
            if action == "play" then
                state.resetGame()
                gameState.currentState = "game"
                gameState.gameState = "player_game"
            elseif action == "demo" then
                state.resetGame()
                gameState.currentState = "demo_menu"
            elseif action == "quit" then
                love.event.quit()
            end
        end)
    elseif gameState.currentState == "demo_menu" then
        demo_menu.keypressed(key, function(action)
            if action == "bfs" then
                aiSettings.algo = "bfs"
                state.resetGame()
                gameState.currentState = "bfs"
                gameState.gameState = "bfs_game"
            elseif action == "quit" then
                gameState.currentState = "menu"
            end
        end)
    elseif gameState.currentState == "gameover" then
        gameover_menu.keypressed(key, function(action)
            if action == "menu" then
                gameState.currentState = "menu"
            elseif action == "play" then
                state.resetGame()
                gameState.currentState = "game"
                gameState.gameState = "player_game"
            elseif action == "demo" then
                state.resetGame()
                gameState.currentState = "demo_menu"
            elseif action == "quit" then
                love.event.quit()
            end
        end)
    elseif gameState.currentState == "demo" then
        ai.keypressed(key)
    else
        main_game.keypressed(key)
    end
end