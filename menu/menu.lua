-- menu.lua
local menu = {}

-- Load font
local titleFont
local optionFont

function menu.load(fontSettings)
    titleFont = love.graphics.newFont(fontSettings.font_path, 40)
    optionFont = love.graphics.newFont(fontSettings.font_path, 24)
end

function menu.draw(my_menu, options, selectedOption)
    -- Set parameters
    love.graphics.clear(0.1, 0.1, 0.1)
    love.graphics.setFont(optionFont)

    -- Menu dimensions
    local menuWidth = 300
    local menuHeight = #options * 45 + 20
    local menuX = (gameConfig.screenWidth - menuWidth) / 2
    local menuY = (gameConfig.screenHeight - menuHeight) / 2

    -- Draw title
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(titleFont)
    local title = "Snake RPG"
    love.graphics.printf(title, 0, menuY - 80, gameConfig.screenWidth, "center")

    -- Draw options background box (centré)
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", menuX, menuY, menuWidth, menuHeight, 10, 10)

    -- Draw options
    love.graphics.setFont(optionFont)
    local fontHeight = optionFont:getHeight()

    for i, option in ipairs(options) do
        local optionY = menuY + 10 + 45 * (i - 1)

        if i == selectedOption then
            love.graphics.setColor(1, 0.5, 0)
            love.graphics.rectangle("fill", menuX + 10, optionY, menuWidth - 20, 35, 8, 8)
            love.graphics.setColor(0, 0, 0)
        else
            love.graphics.setColor(1, 1, 1)
        end

        local textY = optionY + (35 - fontHeight) / 2
        love.graphics.printf(option, menuX, textY, menuWidth, "center")
    end
end

return menu
