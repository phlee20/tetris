StartState = Class { __includes = BaseState }

function StartState:init()
    self.currentMenuItem = 1

    self.colors = {
        [1] = { 217 / 255, 87 / 255, 99 / 255, 1 },
        [2] = { 95 / 255, 205 / 255, 228 / 255, 1 },
        [3] = { 251 / 255, 242 / 255, 54 / 255, 1 },
        [4] = { 118 / 255, 66 / 255, 138 / 255, 1 },
        [5] = { 153 / 255, 229 / 255, 80 / 255, 1 },
        [6] = { 223 / 255, 113 / 255, 38 / 255, 1 }
    }

    -- letters of TETRIS and their spacing relative to the center
    self.letterTable = {
        { 'B', -106 },
        { 'L', -63 },
        { 'O', -21 },
        { 'C', 21 },
        { 'K', 63 },
        { 'S', 105 }
    }
end

function StartState:update(dt)
    if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('down') then
        self.currentMenuItem = 1
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        if self.currentMenuItem == 1 then
            gStateStack:pop()
            gStateStack:push(PlayState())
            gStateStack:push(MessageState('3', false, function()
                gStateStack:push(MessageState('2', false, function()
                    gStateStack:push(MessageState('1', false))
                end))
            end))
            -- gStateMachine:change('play')
        end
    end
end

function StartState:render()
    love.graphics.setColor(100 / 255, 0, 100 / 255, 1)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
    love.graphics.setColor(1, 1, 1, 1)

    self:drawTitleText()

    self:drawOptions()
end

function StartState:drawTitleText()
    love.graphics.setFont(gFonts['large'])

    -- draw rectangle
    love.graphics.setColor(1, 1, 1, 128 / 255)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 200, VIRTUAL_HEIGHT / 3 - 50, 400, 200, 6)
        
    -- draw shadow
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf('BLOCKS', 3, VIRTUAL_HEIGHT / 3 + 3, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(1, 1, 1, 1)

    for i = 1, 6 do
        love.graphics.setColor(self.colors[i])
        love.graphics.printf(self.letterTable[i][1], self.letterTable[i][2], VIRTUAL_HEIGHT / 3, VIRTUAL_WIDTH, 'center')
    end
end

function StartState:drawOptions()
    love.graphics.setFont(gFonts['medium'])

    -- draw Start option
    love.graphics.setColor(34 / 255, 32 / 255, 52 / 255, 1)
    love.graphics.printf('Start', 3, VIRTUAL_HEIGHT / 3 * 2 - 50 + 3, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(1, 1, 1, 1)

    if self.currentMenuItem == 1 then
        love.graphics.setColor(99 / 255, 155 / 255, 1, 1)
    else
        love.graphics.setColor(48 / 255, 96 / 255, 130 / 255, 1)
    end

    love.graphics.printf('Start', 0, VIRTUAL_HEIGHT / 3 * 2 - 50, VIRTUAL_WIDTH, 'center')

    -- draw High Scores option
    -- love.graphics.setColor(34 / 255, 32 / 255, 52 / 255, 1)
    -- love.graphics.printf('High Scores', 3, VIRTUAL_HEIGHT / 3 * 2 + 50 + 3, VIRTUAL_WIDTH, 'center')
    -- love.graphics.setColor(1, 1, 1, 1)

    -- if self.currentMenuItem == 2 then
    --     love.graphics.setColor(99 / 255, 155 / 255, 1, 1)
    -- else
    --     love.graphics.setColor(48 / 255, 96 / 255, 130 / 255, 1)
    -- end

    -- love.graphics.printf('High Scores', 0, VIRTUAL_HEIGHT / 3 * 2 + 50, VIRTUAL_WIDTH, 'center')
end