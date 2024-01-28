import 'CoreLibs/object'
import 'CoreLibs/timer'

import 'interface'
import 'player'
import 'enemy'

-- game class
class('Game').extends()

-- create game
function Game:init()
    self.player    = Player(50, 120)
    self.interface = Interface()

    self.enemies     = {}
    self.enemyRandom = nil

    self.gameEnded   = false
end

-- setup game
function Game:setup()
    -- seed random
    math.randomseed(playdate.getSecondsSinceEpoch())

    -- spawn enemies
    playdate.timer.keyRepeatTimerWithDelay(
        500,
        500,
        function()
            if not self.gameEnded then
                local randomPos = math.random(1, 6)

                -- don't spawn at same position twice
                while randomPos == enemyRandom do
                    randomPos = math.random(1, 6)
                end

                self.enemyRandom = randomPos

                -- spawn at random position
                local position = ({ 32.5, 69.5, 101.5, 138.5, 175.5, 212.5 })[randomPos]
                table.insert(self.enemies, Enemy(400 + 32, position))
            end
        end
    )
end

-- update game
function Game:update()
    if not self.gameEnded then
        self.interface:update()
        self.player:update(self.interface)

        -- update enemies
        for i, enemy in ipairs(self.enemies) do
            enemy:update()

            if enemy:shouldRemove() then
                table.remove(self.enemies, i)
            end
        end
    else
        if playdate.buttonJustPressed(playdate.kButtonB) then
            -- reset game
            if self.gameEnded then
                -- remove enemies
                for _, enemy in ipairs(self.enemies) do
                    enemy.sprite:remove()
                end

                -- remove bullets
                for _, bullet in ipairs(self.player.bullets) do
                    bullet.sprite:remove()
                end

                self.enemies = {}
                self.interface:reset()

                if self.player.reloadTimer then
                    self.player.reloadTimer:remove()
                end
                self.player:reset()

                self.player.sprite:moveTo(50, 120)

                -- restart game
                self.gameEnded = false
            end
        end
    end

    -- end game at zero health
    if self.interface.health <= 0 then
        self.gameEnded = true
    end
end
