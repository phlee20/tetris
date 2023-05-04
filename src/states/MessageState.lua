MessageState = Class { __includes = BaseState }

function MessageState:init(text, canInput, onClose, delay)
    self.panel = Panel()
    self.text = text
    self.onClose = onClose or function() end

    self.delay = delay or 1
    self.canInput = canInput
    self.opened = true
end

function MessageState:update(dt)
    if self.canInput then
        if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
            gStateStack:pop()
            self.onClose()
        end
    else
        if self.opened then
            self.opened = false
            
            Timer.after(self.delay, function()
                gStateStack:pop()
                self.onClose()
            end)
        end
    end
end

function MessageState:render()
    -- draw panel
    self.panel:render()

    love.graphics.printf(self.text, 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center')
end
