-- menu.lua
local menu_generic = {}

-- Fonts used for menu rendering
local titleFont
local optionFont

-- Loads menu fonts based on provided font settings
function menu_generic.load(fontSettings)
    titleFont = love.graphics.newFont(fontSettings.font_path, 40)
    optionFont = love.graphics.newFont(fontSettings.font_path, 24)
end

function menu_generic.new(title, options)
    return {
        title = title,
        options = options,
        selected = 1
    }
end

function menu_generic.draw(menu)
    love.graphics.clear(0.1, 0.1, 0.1)
    love.graphics.setFont(love.graphics.newFont(fontSettings.font_path, 40))
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(menu.title, 0, 100, gameConfig.screenWidth, "center")

    love.graphics.setFont(love.graphics.newFont(fontSettings.font_path, 24))
    for i, opt in ipairs(menu.options) do
        local y = 200 + (i-1)*50
        if i == menu.selected then
            local color = menu.color or {0.2, 0.7, 0.2}
            love.graphics.setColor(color)
            love.graphics.rectangle("fill", gameConfig.screenWidth/2-150, y-5, 300, 40, 8, 8)
            love.graphics.setColor(0, 0, 0)
        else
            love.graphics.setColor(1, 1, 1)
        end
        love.graphics.printf(opt.label, 0, y, gameConfig.screenWidth, "center")
    end
end

function menu_generic.keypressed(menu, key)
    if key == "up" then
        menu.selected = math.max(1, menu.selected - 1)
    elseif key == "down" then
        menu.selected = math.min(#menu.options, menu.selected + 1)
    elseif key == "return" then
        local action = menu.options[menu.selected].action
        if action then action() end
    end
end

return menu_generic