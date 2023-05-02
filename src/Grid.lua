Grid = Class {}

function Grid:init()
    self.x = VIRTUAL_WIDTH / 2 - GRID_WIDTH / 2
    self.y = VIRTUAL_HEIGHT / 2 - GRID_HEIGHT / 2

    self.grid = self:initializeGrid()
end

function Grid:initializeGrid()
    local grid = {}
    
    -- create a border of filled blocks for a wall and ground
    for x = 1, GRID_WIDTH_SQUARES do
        table.insert(grid, {})
        for y = 1, GRID_HEIGHT_SQUARES do
            local square = 0
            
            if y == GRID_HEIGHT_SQUARES or x == 1 or x == GRID_WIDTH_SQUARES then
                square = 1
            end

            grid[x][y] = {
                isBlock = square,
                color = { r = 1, g = 0, b = 0 }
            }
        end
    end

    return grid
end

function Grid:update(dt)

end

function Grid:render()
    -- render the play area inside the walls and ground
    love.graphics.setLineWidth(3)
    love.graphics.rectangle('line', self.x + SQUARE_SIZE, self.y, GRID_WIDTH - SQUARE_SIZE * 2, GRID_HEIGHT - SQUARE_SIZE)
    love.graphics.setLineWidth(1)

    for x = 1, GRID_WIDTH_SQUARES do
        for y = 1, GRID_HEIGHT_SQUARES do
            if self.grid[x][y]['isBlock'] == 1 then
                local color = self.grid[x][y]['color']
                love.graphics.setColor(color.r, color.g, color.b, 1)
                love.graphics.rectangle('fill', self.x + (x - 1) * SQUARE_SIZE, self.y + (y - 1) * SQUARE_SIZE,
                    SQUARE_SIZE, SQUARE_SIZE)

                love.graphics.setColor(1, 1, 1, 1)
                love.graphics.rectangle('line', self.x + (x - 1) * SQUARE_SIZE, self.y + (y - 1) * SQUARE_SIZE,
                    SQUARE_SIZE, SQUARE_SIZE)
            end
        end
    end
end

function Grid:checkRotation(block)
    -- create a temporary block for testing rotation collisions
    tempBlock = Block(block.gridX, block.gridY, block.type)

    tempBlock.orientation = block.orientation + 1
    if tempBlock.orientation > #tempBlock.shape then
        tempBlock.orientation = 1
    end

    -- check if the new orientation causes a collision
    if not self:moveValid(tempBlock) then

        -- if collides, move left and check for collision
        tempBlock:move('left')
        if self:moveValid(tempBlock) then
            return true, 'left'
        else
            
            -- if collides again, reset, move up and check for collision
            tempBlock:move('right')
            tempBlock:move('up')
            if self:moveValid(tempBlock) then
                return true, 'up'
            else
                return false, nil
            end
        end
    end

    -- if no collisions, no shift required
    return true, nil
end

-- check for block collisions 
function Grid:moveValid(block, xOff, yOff)
    local xOffset = xOff or 0
    local yOffset = yOff or 0

    for y = 1, block:blockHeight() do
        for x = 1, block:blockWidth() do
            if self.grid[block.gridX + (x - 1) + xOffset][block.gridY + (y - 1) + yOffset]['isBlock'] == 1 and
                block:isSquare(y, x) == 1 then
                return false
            end
        end
    end

    return true
end

-- function Grid:checkSides(block, direction)
--     -- check left or right block
--     local adjacentBlock = direction == 'left' and -1 or 1

--     -- check the adjacent square to each block
--     for y = 1, block:blockHeight() do
--         for x = 1, block:blockWidth() do
--             if self.grid[block.gridX + (x - 1) + adjacentBlock][block.gridY + (y - 1)]['isBlock'] == 1 and
--                 block:isSquare(y, x) == 1 then
--                 return false
--             end
--         end
--     end

--     return true
-- end

-- function Grid:checkBelow(block)
--     -- check the adjacent square to each block
--     for y = 1, block:blockHeight() do
--         for x = 1, block:blockWidth() do
--             if self.grid[block.gridX + (x - 1)][block.gridY + (y - 1) + 1]['isBlock'] == 1 and
--                 block:isSquare(y, x) == 1 then
--                 return false
--             end
--         end
--     end

--     return true
-- end

function Grid:addBlock(newBlock)
    local block = newBlock.shape[newBlock.orientation]

    for y = 1, #block do
        for x = 1, #block[y] do
            if block[y][x] == 1 then
                local newX = newBlock.gridX + (x - 1)
                local newY = newBlock.gridY + (y - 1)
                self.grid[newX][newY]['isBlock'] = block[y][x]
                self.grid[newX][newY]['color'] = {
                    r = newBlock.color.r,
                    g = newBlock.color.g,
                    b = newBlock.color.b
                }
            end
        end
    end
end