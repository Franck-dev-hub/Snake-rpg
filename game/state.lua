-- state.lua
local state = {}

-- Imports
local food = require("game.food")

function state.resetGame()
    gameState.score = 0
    gameState.direction = 'right'
    gameState.directionQueue = {}
    gameState.gameOver = false
    gameState.newSpeed = gameState.speed
    snakeState.snake = {}
    createSnake()
    food.spawnFood()
end

function state.saveDatas()
    local datas = {{Highscore = gameState.highScore}}
    love.filesystem.write("player_stats.json", json.encode(datas))
end

function state.loadDatas()
    if not love.filesystem.getInfo("player_stats.json") then
        gameState.highScore = 0
        return
    end

    local contenu = love.filesystem.read("player_stats.json")
    if not contenu then
        gameState.highScore = 0
        return
    end

    local datas = json.decode(contenu)
    if type(datas) == "table" and datas[1] and datas[1].Highscore then
        gameState.highScore = datas[1].Highscore
    else
        gameState.highScore = 0
    end
end

return state