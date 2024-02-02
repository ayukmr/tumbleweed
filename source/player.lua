import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/animation"

import "bullet"

local gfx <const> = playdate.graphics

-- player class
class("Player").extends()

-- create player
function Player:init(posX, posY)
    self:reset()
    local imageTable = gfx.imagetable.new("images/player")

    -- animation and sprite
    self.animation = gfx.animation.loop.new(125, imageTable)
    self.sprite    = gfx.sprite.new(imageTable[1])

    self.sprite:setScale(4)
    self.sprite:setZIndex(1)
    self.sprite:moveTo(posX, posY)
    self.sprite:setCollideRect(0, 0, self.sprite:getSize())
    self.sprite:add()
end

-- update player
function Player:update(interface)
    -- set sprite image
    self.sprite:setImage(self.animation:image())

    self:movement()
    self:firing(interface)
    self:damage(interface)
end

-- player movement
function Player:movement()
    local delta = 0

    if playdate.buttonIsPressed(playdate.kButtonUp) then
        delta -= self.speed
    end

    if playdate.buttonIsPressed(playdate.kButtonDown) then
        delta += self.speed
    end

    -- move y position
    self:moveY(delta)
end

-- firing bullets
function Player:firing(interface)
    if not self.reloading and playdate.buttonJustPressed(playdate.kButtonA) then
        -- create new bullet
        table.insert(self.bullets, Bullet(
            self.sprite.x + (self.sprite:getSize() / 2) + 5,
            self.sprite.y + 2
        ))

        self.reloading = true
        interface:startLoading()

        -- allow firing after delay
        self.reloadTimer = playdate.timer.performAfterDelay(
            5000,
            function()
                self.reloading   = false
                self.reloadTimer = nil

                interface:stopLoading()
            end
        )
    end

    -- update bullets
    for i, bullet in ipairs(self.bullets) do
        bullet:move()

        if bullet:shouldRemove() then
            table.remove(self.bullets, i)
        end
    end
end

-- move y position
function Player:moveY(delta)
    local newPos = self.sprite.y + delta

    -- only allow moving in bounds
    if newPos > 16 and newPos < 240 - 16 then
        self.sprite:moveBy(0, delta)
    end
end

-- handle damage
function Player:damage(interface)
    local overlapping = self.sprite:overlappingSprites()

    -- damage when overlapping with enemy
    if not self.invincible and table.getsize(overlapping) > 0 and overlapping[1]:getTag() == 1 then
        self.invincible = true

        -- stop invincibility after delay
        playdate.timer.performAfterDelay(
            500,
            function()
                self.invincible = false
            end
        )

        interface:decrementHealth(1)
    end
end

-- reset player
function Player:reset()
    self.speed      = 5
    self.invincible = false

    self.bullets     = {}
    self.reloading   = false
    self.reloadTimer = nil
end
