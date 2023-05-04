Panel = Class{}

-- note: if you move the Grid x and y, then you need to update the message rectangle x and y
function Panel:init()
    self.x = VIRTUAL_WIDTH / 2 - GRID_WIDTH / 2 + SQUARE_SIZE * 3 + 1
    self.y = VIRTUAL_HEIGHT / 2 - GRID_HEIGHT / 2 + 50 + 1
    self.width = GRID_WIDTH - SQUARE_SIZE * 6 - 2
    self.height = GRID_HEIGHT - SQUARE_SIZE * 3 - 2
end

function Panel:update(dt)

end

function Panel:render()
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
    love.graphics.setColor(1, 1, 1, 1)
end