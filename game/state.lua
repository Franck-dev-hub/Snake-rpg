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
    gameState.direction = 'right'
    gameState.directionQueue = {}
    gameState.gameOver = false
    gameState.newSpeed = gameState.speed
    snakeState.snake = {}
    createSnake()
    food.spawnFood()
end

-- Charger les variables depuis le fichier JSON
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
        -- Pas de fichier, rien à charger
        variables = {}
    end
end

-- Sauvegarder les variables dans le fichier JSON
function state.save()
    local file = io.open(dataFile, "w+")
    if not file then
        error("Impossible d'ouvrir le fichier pour sauvegarder")
    end
    local content = json.encode(variables)
    file:write(content)
    file:close()
end

-- Ajouter ou modifier une variable
function state.setVar(key, value)
    variables[key] = value
end

-- Récupérer une variable
function state.getVar(key)
    return variables[key]
end

-- Pour récupérer toutes les variables
function state.getAll()
    return variables
end

function state.initHighScore(key, value)
    if state.getVar(key) == nil then
        state.setVar(key, value)
    else
        value = state.getVar(key)
    end
end

return state