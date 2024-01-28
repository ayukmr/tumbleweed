import 'CoreLibs/graphics'
import 'CoreLibs/timer'

import 'game'

local gfx <const> = playdate.graphics
local game = Game()

game:setup()

function playdate.update()
    game:update()

    gfx.sprite.update()
    playdate.timer.updateTimers()
end
