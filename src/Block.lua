Block = Class {}

function Block:init(x, y, type)
    self.gridX = x
    self.gridY = y

    self.type = type
    self.shape = self.type.shape
    self.color = self.type.color

    self.orientation = 1

    self.preview = false
end

function Block:blockWidth()
    return #self.shape[self.orientation][1]
end

function Block:blockHeight()
    return #self.shape[self.orientation]
end

function Block:isSquare(x, y)
    return self.shape[self.orientation][x][y]
end

function Block:toggleOrientation()
    -- cycles through shape orientation
    self.orientation = self.orientation + 1
    if self.orientation > #self.shape then
        self.orientation = 1
    end
end

function Block:move(direction)
    if direction == 'left' then
        self.gridX = self.gridX - 1
    elseif direction == 'right' then
        self.gridX = self.gridX + 1
    elseif direction == 'down' then
        self.gridY = self.gridY + 1
    elseif direction == 'up' then
        self.gridY = self.gridY - 1
    end
end

function Block:render(offsetX, offsetY)
    local shape = self.shape[self.orientation]
    for y = 1, #shape do
        for x = 1, #shape[y] do
            if shape[y][x] == 1 then
                if self.preview then
                    love.graphics.setColor(self.color.r, self.color.g, self.color.b, 0.2)
                    love.graphics.setLineWidth(1)
                else
                    love.graphics.setColor(self.color.r, self.color.g, self.color.b, 1)
                    love.graphics.setLineWidth(3)
                end
                love.graphics.rectangle('fill', offsetX + (self.gridX + x - 2) * SQUARE_SIZE,
                    offsetY + (self.gridY + y - 2) * SQUARE_SIZE, SQUARE_SIZE, SQUARE_SIZE)
                love.graphics.setColor(1, 1, 1, 1)
                love.graphics.rectangle('line', offsetX + (self.gridX + x - 2) * SQUARE_SIZE,
                    offsetY + (self.gridY + y - 2) * SQUARE_SIZE, SQUARE_SIZE, SQUARE_SIZE)
                love.graphics.setLineWidth(1)
            end
        end
    end
end