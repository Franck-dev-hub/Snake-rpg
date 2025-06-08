-- state.lua
local state = {}

-- Imports
local food = require("game.food")

-- Variables
local dataFile = "save.json"
local variables = {}

-- Resets the game state to initial values
function state.resetGame()
    gameState.score = 0
    snakeState.direction = 'right'
    snakeState.directionQueue = {}
    gameState.gameOver = false
    gameState.newSpeed = gameState.speed
    snakeState.snake = {}
    gameState.food = {}
    player.createSnake()
    food.spawnFood()
end

-- Load from JSON
function state.load()
    local file = io.open(dataFile, "r")
    if file then
        local content = file:read("*a")
        file:close()
        if content and #content > 0 then
            local ok, decoded = pcall(json.decode, content)
            if ok and type(decoded) == "table" then
                variables = decoded
            else
            print("Erreur de décodage JSON ou fichier vide")
            end
        end
    else
        variables = {}
    end
end

-- Save JSON
function state.save()
    local file = io.open(dataFile, "w+")
    if not file then
        error("Impossible d'ouvrir le fichier pour sauvegarder")
    end
    local content = json.encode(variables)
    file:write(content)
    file:close()
end

-- Add or modify variable
function state.setVar(key, value)
    variables[key] = value
end

-- Fecth variable
function state.getVar(key)
    return variables[key]
end

-- Fetch all
function state.getAll()
    return variables
end

return state