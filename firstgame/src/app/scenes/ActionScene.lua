local BaseScene = require("app.scenes.BaseScene")
local ActionScene = class("ActionScene", BaseScene)


function ActionScene:ctor()
    self.super.ctor(self)

    self.backgroundLayer = display.newColorLayer(cc.c4f(128,128,128,255)):addTo(self)

    self.topLayer = display.newNode():addTo(self)
    self.topLayer:setLocalZOrder(1000)

    display.newTTFLabel({text = "动作场景", size = 40, color = display.COLOR_ORANGE })
        :align(display.CENTER_TOP, display.cx, display.height - 20)
        :addTo(self.topLayer)

    -- 预加载帧到缓存 
    display.addSpriteFrames("action/grossini-aliases.plist", "action/grossini-aliases.png")

    -- 添加1-9到按钮，点击分别执行 startRunAction(1) 到 startRunAction(9)
    -- 添加1-9到按钮，横向排列，不够换行
    local startX = 80  -- 起始X坐标
    local startY = display.height - 100  -- 起始Y坐标
    local buttonWidth = 100  -- 按钮宽度
    local buttonHeight = 50  -- 按钮高度
    local padding = 20  -- 按钮之间的间距
    local rowCapacity = math.floor((display.width - startX) / (buttonWidth + padding))  -- 每行可容纳的按钮数

    for i = 1, 9 do
        local row = math.floor((i - 1) / rowCapacity)
        local col = (i - 1) % rowCapacity
        local x = startX + col * (buttonWidth + padding)
        local y = startY - row * (buttonHeight + padding)

        local label = display.newTTFLabel({
            text = "动作" .. i, 
            size = 30, 
            color = display.COLOR_ORANGE,
            dimensions = cc.size(buttonWidth, buttonHeight),
            align = cc.TEXT_ALIGNMENT_CENTER,
            valign = cc.VERTICAL_TEXT_ALIGNMENT_CENTER
        })
        :pos(x, y)
        :addTo(self.topLayer)

        label:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
            if event.name == "began" then
                self:startRunAction(i)
                return true
            end
            return false
        end)
        label:setTouchEnabled(true)
    end

    --[[
        节点运行动作的接口 
        node:runAction(action) 运行动作
        node:stopAction(action) 停止动作
        node:stopAllActions() 停止所有动作 
        node:stopActionByTag(tag) 停止某个tag的action对象 

        node:getActionByTag(tag) 根据tag获取动作 

        node:setTag(tag) 节点标记tag
        action:setTag(tag) 动作标记tag
    ]]


    
end

function ActionScene:startRunAction(actionNum)
    self:resetBackgroundLayer()
    self["action" .. actionNum](self)
end

function ActionScene:resetBackgroundLayer()
    if self.backgroundLayer then
        self.backgroundLayer:removeFromParent()
    end
    self.backgroundLayer = display.newColorLayer(cc.c4f(128,128,128,255)):addTo(self)
end

-- 跟随
function ActionScene:action1()

    -- 用在层跟随精灵中，固定摄像机到精灵身上 
    local sprite = display.newSprite("action/1.png"):center()
    local move_left = cc.MoveBy:create(1.5, cc.p(display.width / 2, 0))
    local move_right = cc.MoveBy:create(3, cc.p(-display.width, 0))
    local sequence = cc.Sequence:create(move_left, move_right, move_left)
    local repeat_action = cc.RepeatForever:create(sequence)
    sprite:runAction(repeat_action)
    sprite:addTo(self.backgroundLayer)

    self.backgroundLayer:runAction(cc.Follow:create(sprite))
end

-- 使节点从当前坐标点匀速直线运动到目标点 
function ActionScene:action2()

    local sprite = display.newSprite("action/2.png")
        :center()
        :addTo(self.backgroundLayer)

    -- true 翻转，false 重置为最初的状态
    local flipxAction = cc.FlipX:create(true)
    local moveTo = cc.MoveBy:create(1, cc.p(-300, 0))
    local sequence = cc.Sequence:create(moveTo, flipxAction, moveTo:reverse())
    sprite:runAction(sequence)
end

-- 隐藏动作 
function ActionScene:action3()
    local hideAction = cc.Hide:create()
    local moveTo = cc.MoveTo:create(1.5, cc.p(60, 60))
    local sequence = cc.Sequence:create(moveTo, hideAction)

    local sprite = display.newSprite("action/1.png")
        :center()
        :addTo(self.backgroundLayer)
        :runAction(sequence)
end

-- 判断某个符合动作总的动作是否执行结束
function ActionScene:action4()
    -- local callback = cc.CallFunc:create(function() print("In callback function") end)
    -- local moveTo = cc.MoveTo:create(2, cc.p(0, 0))
    -- local sequence = cc.Sequence:create(moveTo, callback )

    -- local sprite = display.newSprite("action/1.png")
    --     :center()
    --     :addTo(self.backgroundLayer)
    --     :runAction(sequence)

    local sprite = display.newSprite("action/1.png")
        :center()
        :addTo(self.backgroundLayer)

    local startPos = cc.p(sprite:getPosition())
    local moveBy = cc.MoveBy:create(1, cc.p(-300, -300))
    local moveBack = moveBy:reverse()
    local callback = cc.CallFunc:create(function() 
        print("Action sequence completed")
        print("Sprite position:", sprite:getPositionX(), sprite:getPositionY())
    end)

    local sequence = cc.Sequence:create(moveBy, moveBack, callback)
    sprite:runAction(sequence)
end

-- 贝赛尔曲线 
function ActionScene:action5()
    local action = cc.BezierTo:create(2, {
        cc.p(display.right, display.top), 
        cc.p(200, 200), 
        cc.p(50, 100)
    }) 
    local sprite = display.newSprite("action/1.png")
        :pos(0, 0)
        :addTo(self.backgroundLayer)
        :runAction(action)
end

-- FadeTo
function ActionScene:action6()
    local action = cc.FadeTo:create(2, 0)
    local sprite = display.newSprite("action/1.png")
        :center()
        :addTo(self.backgroundLayer)
        :runAction(action)
end

-- 帧动画
function ActionScene:action7()
    -- 使用 grossini.plist里面的内容就行，不用再添加 action 路径前缀了  
    local frames = display.newFrames("grossini_dance_%02d.png", 1, 14)
    local animation = display.newAnimation(frames, 0.2)
    local animate = cc.Animate:create(animation)

    local sprite = display.newSprite("#grossini_dance_01.png")
        :center()
        :addTo(self.backgroundLayer)
        :runAction(animate)
end

-- 延迟动作 
function ActionScene:action8()
    local move = cc.MoveBy:create(1, cc.vertex2F(150,0))
    local action = cc.Sequence:create(move, cc.DelayTime:create(2), move:reverse())

    local sprite = display.newSprite("action/1.png")
        :center()
        :addTo(self.backgroundLayer)
        :runAction(action)
end

-- 变速动作 
function ActionScene:action9()
    local action = cc.EaseSineOut:create(cc.MoveBy:create(2, cc.p(300, 0)))
    local sprite = display.newSprite("action/1.png")
        :center()
        :addTo(self.backgroundLayer)
        :runAction(action)
end

return ActionScene
