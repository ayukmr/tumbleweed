import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/animation"

local gfx <const> = playdate.graphics

local heartImage = gfx.image.new("images/heart")
local loadingImageTable = gfx.imagetable.new("images/loading")

-- interface class
class("Interface").extends()

-- create interface
function Interface:init()
    self.loadingSprite = gfx.sprite.new(loadingImageTable[1])

    self.loadingSprite:setScale(4)
    self.loadingSprite:setZIndex(10)
    self.loadingSprite:moveTo(400 - (select(1, self.loadingSprite:getSize()) / 2) - 5, (select(2, self.loadingSprite:getSize()) / 2) + (5 * 1.75))
    self.loadingSprite:add()

    self:reset()
end

-- update interface
function Interface:update()
    if self.loading then
        -- set loading image
        self.loadingSprite:setImage(self.loadingAnimation:image())
    end
end

-- increment health
function Interface:incrementHealth(amount)
    for _ = 1, amount do
        -- create new heart
        local sprite = gfx.sprite.new(heartImage)

        sprite:setScale(4)
        sprite:setZIndex(10)
        sprite:moveTo((self.health + 0.75) * (select(1, sprite:getSize()) + 5), (select(2, sprite:getSize()) / 2) + (5 * 1.75))
        sprite:add()

        table.insert(self.hearts, sprite)

        -- increment health
        self.health += 1
    end
end

-- decrement health
function Interface:decrementHealth(amount)
    for _ = 1, amount do
        -- remove heart
        self.hearts[#self.hearts]:remove()
        table.remove(self.hearts, #self.hearts)

        -- decrement health
        self.health -= 1
    end
end

-- start loading animation
function Interface:startLoading()
    self.loading = true
    self.loadingAnimation = gfx.animation.loop.new(5000 / 8, loadingImageTable)

    self.loadingSprite:setVisible(true)
end

-- stop loading animation
function Interface:stopLoading()
    self.loading = false
    self.loadingAnimation = nil

    self.loadingSprite:setVisible(false)
end

-- reset interface
function Interface:reset()
    -- player health
    self.health = 0
    self.hearts = {}

    -- bullet loading
    self.loading = false
    self.loadingAnimation = nil

    -- loading sprite
    self.loadingSprite:setVisible(false)
    self.loadingSprite:setImage(loadingImageTable[1])

    -- set health
    self:incrementHealth(3)
end
