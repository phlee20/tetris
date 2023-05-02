PlayState = Class { __includes = BaseState }

function PlayState:init()
    self.grid = Grid()
    self.currentBlock = Block(START_X, START_Y, BLOCKS_DEF[math.random(#BLOCKS_DEF)])
    self.nextBlock = Block(START_X + GRID_WIDTH_SQUARES, START_Y, BLOCKS_DEF[math.random(#BLOCKS_DEF)])

    self.blockAdded = false

    self.score = 0
end

function PlayState:update(dt)
    -- logic for rotating blocks
    if love.keyboard.wasPressed('up') then
        local valid, direction, numOfShifts = self.grid:checkRotation(self.currentBlock)
        
        if valid then
            self.currentBlock:toggleOrientation()
            for i = 1, numOfShifts do
                self.currentBlock:move(direction)
            end
        end
    end
    
    -- logic for block movement
    if love.keyboard.wasPressed('left') and self.grid:moveValid(self.currentBlock, -1) then
        self.currentBlock:move('left')
    elseif love.keyboard.wasPressed('right') and self.grid:moveValid(self.currentBlock, 1)then
        self.currentBlock:move('right')
    elseif love.keyboard.isDown('down') then
        if self.grid:moveValid(self.currentBlock, 0, 1) then
            self.currentBlock:move('down')
        else
            -- add block to grid array and instantiate a new block
            self.grid:addBlock(self.currentBlock)
            self.currentBlock = self.nextBlock
            self.currentBlock.gridX = START_X
            self.nextBlock = Block(START_X + GRID_WIDTH_SQUARES, START_Y, BLOCKS_DEF[math.random(#BLOCKS_DEF)])
            self.blockAdded = true
        end
    end

    -- check for lines
    if self.blockAdded then
        local lines = self.grid:checkLines()
        if lines ~= nil then
            self.grid:removeLines(lines)
            self.score = self.score + 100 * #lines
        end
        self.blockAdded = false
    end

end

function PlayState:render()
    self.grid:render()
    self.currentBlock:render(self.grid.x, self.grid.y)
    self.nextBlock:render(self.grid.x, self.grid.y)

    love.graphics.setFont(gFonts['medium'])
    love.graphics.print(tostring(self.score), 0, 0)
end