MenuState = Class { __includes = BaseState }

function MenuState:init(def)
    self.panel = Panel()
    self.title = def.title

    self.items = def.items

    self.currentSelection = 1
end

function MenuState:update(dt)
    if love.keyboard.wasPressed('up') then
        if self.currentSelection == 1 then
            self.currentSelection = #self.items
        else
            self.currentSelection = self.currentSelection - 1
        end
    elseif love.keyboard.wasPressed('down') then
        if self.currentSelection == #self.items then
            self.currentSelection = 1
        else
            self.currentSelection = self.currentSelection + 1
        end
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        self.items[self.currentSelection].onSelect()
    end
end

function MenuState:render()
    self.panel:render()

    love.graphics.printf(self.title, 0, self.panel.y + 50, VIRTUAL_WIDTH, 'center')
    
    for i = 1, #self.items do
        if i == self.currentSelection then
            love.graphics.setColor(1, 1, 1, 1)
        else
            love.graphics.setColor(150 / 255, 150 / 255, 150 / 255, 1)
        end

        love.graphics.printf(self.items[i].text, 0, self.panel.y + 150 + i * 75, VIRTUAL_WIDTH, 'center')
        love.graphics.setColor(1, 1, 1, 1)
    end
end