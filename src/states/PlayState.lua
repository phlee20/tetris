PlayState = Class { __includes = BaseState }

function PlayState:init()
    self.grid = Grid()
    self.currentBlock = Block(START_X, 1, BLOCKS_DEF[math.random(3)])
    self.nextBlock = Block(START_X + GRID_WIDTH_SQUARES, 1, BLOCKS_DEF[math.random(3)])
end

function PlayState:update(dt)
    if love.keyboard.wasPressed('space') then
        local valid, shift = self.grid:checkRotation(self.currentBlock)
        
        if valid then
            self.currentBlock:toggleOrientation()
        end

        if shift == 'left' then
            self.currentBlock:move('left')
        elseif shift == 'up' then
            self.currentBlock:move('up')
        end
    end
    
    if love.keyboard.wasPressed('left') and self.grid:moveValid(self.currentBlock, -1) then
        self.currentBlock:move('left')
    elseif love.keyboard.wasPressed('right') and self.grid:moveValid(self.currentBlock, 1)then
        self.currentBlock:move('right')
    elseif love.keyboard.wasPressed('down') then
        if self.grid:moveValid(self.currentBlock, 0, 1) then
            self.currentBlock:move('down')
        else
            -- add block to grid array and instantiate a new block
            self.grid:addBlock(self.currentBlock)
            self.currentBlock = self.nextBlock
            self.currentBlock.gridX = START_X
            self.nextBlock = Block(START_X + GRID_WIDTH_SQUARES, 1, BLOCKS_DEF[math.random(3)])
        end
    end
end

function PlayState:render()
    self.grid:render()
    self.currentBlock:render(self.grid.x, self.grid.y)
    self.nextBlock:render(self.grid.x, self.grid.y)
end