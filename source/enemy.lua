import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/animation"

local gfx <const> = playdate.graphics
local imageTable = gfx.imagetable.new("images/tumbleweed")

-- enemy class
class("Enemy").extends()

-- create enemy
function Enemy:init(posX, posY)
    self.speed = 3

    -- animation and sprite
    self.animation = gfx.animation.loop.new(250, imageTable)
    self.sprite    = gfx.sprite.new(imageTable[1])

    self.sprite:setScale(4)
    self.sprite:setTag(1)
    self.sprite:moveTo(posX, posY)
    self.sprite:setCollideRect(0, 0, self.sprite:getSize())
    self.sprite:add()
end

-- update enemy
function Enemy:update()
    self.sprite:setImage(self.animation:image())
    self:move()
end

-- move enemy
function Enemy:move()
    self.sprite:moveBy(-self.speed, 0)
end

-- check if enemy should be removed
function Enemy:shouldRemove()
    -- remove if not visible due to being hit with bullet
    if not self.sprite:isVisible() or self.sprite.x < (0 - select(1, self.sprite:getSize())) then
        self.sprite:remove()
        return true
    end

    return false
end
