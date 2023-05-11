Grid = Class {}

function Grid:init()
    self.x = VIRTUAL_WIDTH / 2 - GRID_WIDTH / 2
    self.y = VIRTUAL_HEIGHT / 2 - GRID_HEIGHT / 2 + 60

    self.grid = self:initializeGrid()

    self.showGridlines = false

    self.previewBlock = nil
end

function Grid:initializeGrid()
    local grid = {}

    -- create a border of filled blocks for a wall and ground
    for y = 1, GRID_HEIGHT_SQUARES do
        table.insert(grid, self:insertBlankLine(y))
    end

    return grid
end

function Grid:insertBlankLine(y)
    local row = y or 1
    local line = {}

    for x = 1, GRID_WIDTH_SQUARES do
        local square = 0

        if row >= GRID_HEIGHT_SQUARES - 2 or x <= 3 or x >= GRID_WIDTH_SQUARES - 2 then
            square = 1
        end

        table.insert(line, {
            isBlock = square,
            color = { r = 0, g = 0, b = 0, a = 0 }
        })
    end
    return line
end

function Grid:update(dt)

end

function Grid:render()
    for y = 1, GRID_HEIGHT_SQUARES - 3 do
        for x = 4, GRID_WIDTH_SQUARES - 3 do
            if self.grid[y][x]['isBlock'] then
                local color = self.grid[y][x]['color']
                love.graphics.setColor(color.r, color.g, color.b, 1)
                love.graphics.rectangle('fill', self.x + (x - 1) * SQUARE_SIZE, self.y + (y - 1) * SQUARE_SIZE,
                    SQUARE_SIZE, SQUARE_SIZE)

                love.graphics.setColor(1, 1, 1, color.a)
                love.graphics.rectangle('line', self.x + (x - 1) * SQUARE_SIZE, self.y + (y - 1) * SQUARE_SIZE,
                    SQUARE_SIZE, SQUARE_SIZE)
                love.graphics.setColor(1, 1, 1, 1)
                
                if self.showGridlines then
                    love.graphics.setLineWidth(0.5)
                    love.graphics.rectangle('line', self.x + (x - 1) * SQUARE_SIZE, self.y + (y - 1) * SQUARE_SIZE,
                        SQUARE_SIZE, SQUARE_SIZE)
                end
            end
        end
    end

    self.previewBlock:render(self.x, self.y)

    -- render the play area inside the walls and ground
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setLineWidth(3)
    love.graphics.rectangle('line', self.x + SQUARE_SIZE * 3, self.y, GRID_WIDTH - SQUARE_SIZE * 6, GRID_HEIGHT - SQUARE_SIZE * 3)
    love.graphics.setLineWidth(1)
end

function Grid:checkRotation(block)
    -- create a temporary block for testing rotation collisions
    local tempBlock = Block(block.gridX, block.gridY, block.type)

    tempBlock.orientation = block.orientation + 1
    if tempBlock.orientation > #tempBlock.shape then
        tempBlock.orientation = 1
    end

    -- check if the new orientation causes a collision
    if not self:moveValid(tempBlock) then

        -- check for collisions if shifting left
        tempBlock:move('left')
        if self:moveValid(tempBlock) then
            return true, 'left', 1
        else
            -- second shift left
            tempBlock:move('left')
            if self:moveValid(tempBlock) then
                return true, 'left', 2
            end
            -- reset
            tempBlock:move('right')
            tempBlock:move('right')
        end

        -- check for collisions if shifting right
        tempBlock:move('right')
        if self:moveValid(tempBlock) then
            return true, 'right', 1
        else
            -- second shift right
            tempBlock:move('right')
            if self:moveValid(tempBlock) then
                return true, 'right', 2
            end
            -- reset
            tempBlock:move('left')
            tempBlock:move('left')
        end

        -- if collides again, reset, move up and check for collision
        tempBlock:move('up')
        if self:moveValid(tempBlock) then
            return true, 'up', 1
        else
            return false, nil, nil
        end

    end

    -- if no collisions, no shift required
    return true, nil, 1
end

-- check for block collisions 
function Grid:moveValid(block, xOff, yOff)
    local xOffset = xOff or 0
    local yOffset = yOff or 0

    for y = 1, block:blockHeight() do
        for x = 1, block:blockWidth() do
            if self.grid[block.gridY + (y - 1) + yOffset][block.gridX + (x - 1) + xOffset]['isBlock'] == 1 and
                block:isSquare(y, x) == 1 then
                return false
            end
        end
    end

    return true
end

function Grid:addBlock(newBlock)
    local block = newBlock.shape[newBlock.orientation]

    for y = 1, #block do
        for x = 1, #block[y] do
            if block[y][x] == 1 then
                local newX = newBlock.gridX + (x - 1)
                local newY = newBlock.gridY + (y - 1)
                self.grid[newY][newX]['isBlock'] = block[y][x]
                self.grid[newY][newX]['color'] = {
                    r = newBlock.color.r,
                    g = newBlock.color.g,
                    b = newBlock.color.b,
                    a = 1
                }
            end
        end
    end
end

function Grid:checkLines()
    local lines = {}

    for y = GRID_HEIGHT_SQUARES - 3, 1, -1 do
        for x = 4, GRID_WIDTH_SQUARES - 3 do
            if self.grid[y][x]['isBlock'] == 0 then
                goto continue
            end
        end

        -- add line reference to completed lines
        table.insert(lines, y)

        ::continue::
    end

    return lines
end

function Grid:removeLines(lines)
    -- remove lines and insert new blank line at the top
    for i = #lines, 1, -1 do
        table.remove(self.grid, lines[i])
        table.insert(self.grid, 1, self:insertBlankLine())
    end
end

function Grid:showPreview(block)
    self.previewBlock = Block(block.gridX, block.gridY, block.type)
    self.previewBlock.orientation = block.orientation
    self.previewBlock.preview = true

    -- move block down until it collides
    while self:moveValid(self.previewBlock, 0, 0) do
        self.previewBlock:move('down')
    end

    -- shift the block up one to its final resting spot
    self.previewBlock:move('up')
end