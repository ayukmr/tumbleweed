import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"

local gfx <const> = playdate.graphics
local image = gfx.image.new("images/bullet")

-- bullet class
class("Bullet").extends()

-- create bullet
function Bullet:init(posX, posY)
    self.speed  = 5
    self.sprite = gfx.sprite.new(image)

    self.sprite:setScale(4)
    self.sprite:moveTo(posX, posY)
    self.sprite:setCollideRect(0, 0, self.sprite:getSize())
    self.sprite:add()
end

-- move bullet
function Bullet:move()
    self.sprite:moveBy(self.speed, 0)
end

function Bullet:shouldRemove()
    local overlapping = self.sprite:overlappingSprites()

    -- remove when off screen
    if self.sprite.x > (400 + select(1, self.sprite:getSize())) then
        self.sprite:remove()
        return true
    end

    -- remove when hitting enemy
    if table.getsize(overlapping) > 0 and overlapping[1]:getTag() == 1 then
        self.sprite:remove()

        local enemy = overlapping[1]

        -- disable enemy visibility, used by enemy class
        enemy:setVisible(false)
        enemy:remove()

        return true
    end

    return false
end
