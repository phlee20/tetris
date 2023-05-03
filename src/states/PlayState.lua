PlayState = Class { __includes = BaseState }

function PlayState:init()
    self.grid = Grid()
    self.currentBlock = Block(START_X, START_Y, BLOCKS_DEF[math.random(#BLOCKS_DEF)])
    self.nextBlock = Block(START_X + GRID_WIDTH_SQUARES, START_Y, BLOCKS_DEF[math.random(#BLOCKS_DEF)])

    self.blockAdded = false
    self.gameOver = false
    self.score = 0
    self.scoreIncrease = 100
    self.level = 1
    self.goalIncrease = 300
    self.goal = self.level * self.goalIncrease

    self.timer = 0
    self.speedIncrease = 2
    self.blockSpeed = 10 + (self.level - 1) * self.speedIncrease
    self.drop = false

    self.r = math.random(255) / 255
    self.g = math.random(255) / 255
    self.b = math.random(255) / 255

    self.grid:showPreview(self.currentBlock)
end

function PlayState:update(dt)
    if not self.gameOver then

        -- block fall timer
        self.timer = self.timer + self.blockSpeed * dt
        if self.timer > 10 then
            self.drop = true
        end

        -- TODO: Future - optimize by calling only when button pressed?
        self.grid:showPreview(self.currentBlock)

        -- logic for rotating blocks
        if love.keyboard.wasPressed('up') then
            local valid, direction, numOfShifts = self.grid:checkRotation(self.currentBlock)

            if valid then
                self.currentBlock:toggleOrientation()
                for i = 1, numOfShifts do
                    self.currentBlock:move(direction)
                end
            end

        -- logic for block movement
        elseif love.keyboard.wasPressed('left') and self.grid:moveValid(self.currentBlock, -1) then
            self.currentBlock:move('left')
        elseif love.keyboard.wasPressed('right') and self.grid:moveValid(self.currentBlock, 1) then
            self.currentBlock:move('right')
        elseif love.keyboard.wasPressed('down') or self.drop then
            if self.grid:moveValid(self.currentBlock, 0, 1) then
                self.currentBlock:move('down')
            else
                self:processBlock()
            end

            self.timer = 0
            self.drop = false

        elseif love.keyboard.wasPressed('space') then
            self.currentBlock.gridY = self.grid.previewBlock.gridY
            self:processBlock()

            self.timer = 0
            self.drop = false
        end
    end
end

function PlayState:render()
    love.graphics.setColor(self.r, self.g, self.b, 1)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
    love.graphics.setColor(1, 1, 1, 1)

    self.grid:render()
    self.currentBlock:render(self.grid.x, self.grid.y)
    self.nextBlock:render(self.grid.x, self.grid.y)

    love.graphics.setFont(gFonts['medium'])
    love.graphics.print(tostring('Level: ' .. self.level), 10, 10)
    love.graphics.print(tostring('Score: ' .. self.score), 10, 60)
    love.graphics.print(tostring('Speed: ' .. self.blockSpeed), 10, 110)
end

function PlayState:processBlock()
    -- add block to grid array and instantiate a new block
    self.grid:addBlock(self.currentBlock)

    -- process lines
    local lines = self.grid:checkLines()
    if lines ~= nil then
        self.grid:removeLines(lines)
        self.score = self.score + self.scoreIncrease * #lines
        if self.score >= self.goal then
            self:newLevel()
        end
    end

    -- reset blocks
    self.currentBlock = self.nextBlock
    self.currentBlock.gridX = START_X

    -- check for game over
    if self.grid:moveValid(self.currentBlock, 0, 0) then
        self.nextBlock = Block(START_X + GRID_WIDTH_SQUARES, START_Y, BLOCKS_DEF[math.random(#BLOCKS_DEF)])
    else
        self.gameOver = true
    end
end

function PlayState:newLevel()
    self.level = self.level + 1
    self.blockSpeed = self.blockSpeed + self.speedIncrease
    self.goal = self.goal + self.goalIncrease
    
    self.r = math.random(255) / 255
    self.g = math.random(255) / 255
    self.b = math.random(255) / 255
end