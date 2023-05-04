Class = require 'lib/class'
push = require 'lib/push'

Timer = require 'lib/knife.timer'
Event = require 'lib/knife.event'

require 'src/constants'
require 'src/Block'
require 'src/blocks_def'
require 'src/Grid'
require 'src/gui/Panel'

require 'src/StateMachine'
require 'src/states/BaseState'
require 'src/states/StateStack'
require 'src/states/StartState'
require 'src/states/PlayState'
require 'src/states/MessageState'
require 'src/states/HighScoreState'
require 'src/states/CountdownState'
require 'src/states/MenuState'


gTextures = {

}

gFrames = {

}

gFonts = {
    ['small'] = love.graphics.newFont('fonts/CascadiaMono.ttf', 24),
    ['medium'] = love.graphics.newFont('fonts/CascadiaMono.ttf', 48),
    ['large'] = love.graphics.newFont('fonts/CascadiaMono.ttf', 72)
}

gSounds = {

}