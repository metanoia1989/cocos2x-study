-- 水果类，包含图片信息，是否激活，坐标信息 
local FruitItem = class("FruitItem", function(x, y, fruitIndex)
    fruitIndex = fruitIndex or math.round(math.random() * 1000) % 8 + 1
    local sprite = display.newSprite("#fruit" .. fruitIndex .. "_1.png")
    sprite.fruitIndex = fruitIndex
    sprite.x = x
    sprite.y = y
    sprite.isActive = false
    return sprite
end)

function FruitItem:ctor()
    --[[
    因为定义 FruitItem时，class的第二个参数时函数，所以在 FruitItem:new() 时，会先将参数传递给函数
    然后再传递给 FruitItem:ctor()，所以在 FruitItem:ctor() 中，无需再做初始化的动作。   
    ]]
end

function FruitItem:setActive(active)
    self.isActive = active

    -- 完成高亮图片与正常图片之间的切换
    local frame
    if active then
        frame = display.newSpriteFrame("fruit" .. self.fruitIndex .. "_2.png")
        print("name: ".. "fruit".. self.fruitIndex .. "_2.png")
    else
        frame = display.newSpriteFrame("fruit" .. self.fruitIndex .. "_1.png")
        print("name: ".. "fruit".. self.fruitIndex .. "_1.png")
    end
    print("更新精灵的显示帧", frame, self.isActive, self.fruitIndex)
    self:setDisplayFrame(frame) -- 更新精灵的显示帧

    -- 正常图片切换为高亮图片时，播放一组动作 
    if active then
        self:stopAllActions()
        local scaleTo1 = cc.ScaleTo:create(0.1, 1.1)
        local scaleTo2 = cc.ScaleTo:create(0.05, 1.0)
        self:runAction(cc.Sequence:create(scaleTo1, scaleTo2))
    end
end

-- 类方法，获取水果的宽度 
function FruitItem.getWidth()
    g_fruitWidth = 0
    if g_fruitWidth == 0 then
        local sprite = display.newSprite("#fruit1_1.png")
        g_fruitWidth = sprite:getContentSize().width
    end
    return g_fruitWidth
end


return FruitItem
    