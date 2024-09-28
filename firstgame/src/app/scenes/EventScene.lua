local BaseScene = require("app.scenes.BaseScene")
local EventScene = class("EventScene", BaseScene)

function EventScene:ctor()
    self.super.ctor(self)

    print("调用了？？？")

    -- 添加业务代码
    display.newTTFLabel({text = "事件分发机制", size = 40})
        :center() -- 居中显示   
        :align(display.CENTER_TOP, display.cx, display.height - 50)
        :addTo(self)

    ccui.Button:create()
        :setTitleText("返回首页")
        :setTitleFontSize(30)
        :setTitleColor(cc.c3b(255, 0, 0))
        :setPosition(display.cx, display.height - 120)
        :addTo(self)
        :addTouchEventListener(function(ref, eventType)
            if eventType == cc.EventCode.ENDED then
                if (self.router.getSceneCount() > 1) then
                    self.router.goBack()
                else 
                    self.router.backHome()
                end
            end
        end)

    --[[
    事件分类：节点事件、帧事件、键盘事件、加速计事件、触摸事件 

    节点事件：节点事件在一个Node对象进入和退出场景时触发。
    例如，加入一个层或者其他的Node的子类的时候，想在子类进入
    或者退出时添加一些数据清除的工作，可以通过这个事件来操作。
    就事件含义本事来讲，叫场景事件更贴切。但是它能被场景及其所有子节点监听。
    node:addEventListener(cc.NODE_EVENT, function(event)
        print('节点事件', event.name)
    end)
    node:setNodeEventEnabled(true) -- 启用节点事件 
    通过 display.newScene() 创建的场景，默认是启用节点事件的。
    event.name 事件名称：
        enter 加载场景
        exit 退出场景
        enterTransitionFinish 转场特效结束 
        exitTransitionStart 转场特效开始
        cleanup 场景被完全清理并从内存中删除    

    
    帧事件：每帧刷新时触发的事件。
    local node = display.newNode()
    self:addChild(node)
    node:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function(dt)
        print('帧事件', dt)
    end)
    node:scheduleUpdate() -- 启用帧事件 
    node:performWithDelay(function()
        node:unscheduleUpdate() -- 停止帧事件 
    end, 2)
    node:scheduleUpdate() -- 重新启用帧事件 
    帧事件用于更新游戏中高速物体的数据，例如射击的子弹  

    键盘事件：键盘事件在用户按下和释放键盘上的键时触发。
    self:setKeypadEnabled(true)
    self:addNodeEventListener(cc.KEYPAD_EVENT, function(event)
        print('键盘事件 KeypadEvent = ' .. event.key)
    end)
    iOS设备没有键盘事件，以下仅在Android设备上有效
    @param event.code 数值，按键对应的编码 
    @param event.key 字符串，按键对应的字符串 
        menu 菜单键 
        back 返回键 
    @param event.type 字符串，按键事件类型 
        Pressed 按下
        Released 释放


    加速计事件: 手机自带加速计，用于测量设备静止或匀速运动时所受到的重力方向。
    力感应来自移动设备的加速计，通常支持X、Y和Z3个方向的加速度感应，所以又称为三向加速计。
    在实际应用中，可以根据3个方向 的力度大小来计算手机倾斜的角度或方向。
    self:addNodeEventListener(cc.ACCELEROMETER_EVENT, function(event)
        print('加速计事件 AccelerateData: x = ' .. event.x 
            .. ' y = ' .. event.y 
            .. ' z = ' .. event.z 
            .. ' timestamp = ' .. event.timestamp)
    end)
    self:setAccelerometerEnabled(true)
    ]]
    

    ccui.Button:create()
        :setTitleText("测试节点事件")
        :setTitleFontSize(30)
        :setPosition(display.cx, display.height - 160)
        :addTo(self)
        :addTouchEventListener(function(ref, eventType)
            if eventType == cc.EventCode.ENDED then
                local scene = createTestScene("scene1")
                display.replaceScene(scene)

                -- 等待1s创建第一个测试场景
                scene:performWithDelay(function()
                    print("------------")
                    local scene = createTestScene("scene2")
                    display.replaceScene(scene)

                    scene:performWithDelay(function()
                        print("------------")
                        display.replaceScene(EventScene.new())
                    end, 2)
                end, 1)
            end
        end)

    ccui.Button:create()
        :setTitleText("测试帧事件")
        :setTitleFontSize(30)
        :setPosition(display.cx, display.height - 200)
        :addTo(self)
        :addTouchEventListener(function(ref, eventType)
            if eventType == cc.EventCode.ENDED then
                local node = display.newNode()
                self:addChild(node)
                node:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function(dt)
                    print('帧事件', dt)
                end)
                node:scheduleUpdate() -- 启用帧事件 
                node:performWithDelay(function()
                    node:unscheduleUpdate() -- 停止帧事件 
                    print("停止帧事件")
                end, 2)
            end
        end)

    ccui.Button:create()
        :setTitleText("测试键盘事件")
        :setTitleFontSize(30)
        :setPosition(display.cx, display.height - 240)
        :addTo(self)
        :addTouchEventListener(function(ref, eventType)
            if eventType == cc.EventCode.ENDED then
                self:setKeypadEnabled(true)
                self:addNodeEventListener(cc.KEYPAD_EVENT, function(event)
                    print('键盘事件 KeypadEvent = ' .. event.key .. 
                        ' type = ' .. event.type .. 
                        ' code = ' .. event.code)
                end)
            end
        end)

    ccui.Button:create()
        :setTitleText("测试加速计事件")
        :setTitleFontSize(30)
        :setPosition(display.cx, display.height - 280)
        :addTo(self)
        :addTouchEventListener(function(ref, eventType)
            if eventType == cc.EventCode.ENDED then
                self:addNodeEventListener(cc.ACCELEROMETER_EVENT, function(event)  
                    print('加速计事件 AccelerateData: x = ' .. event.x 
                        .. ' y = ' .. event.y 
                        .. ' z = ' .. event.z 
                        .. ' timestamp = ' .. event.timestamp)
                end)
                self:setAccelerometerEnabled(true)
            end
        end)

    --[[
    触摸事件：触摸事件在用户触摸节点时触发。
    单点触摸事件：一个时刻只响应一个触摸点 
    node:setTouchMode(cc.TOUCH_MODE_ONE_BY_ONE) -- 默认为单点触摸模式 
    node:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        string.format("sprite: %s x, y: %0.2f, %0.2f", event.name, event.x, event.y)
        if event.name == "began" then
            print("触摸开始")
            return true
        elseif event.name == "moved" then
            print("触摸移动")
        elseif event.name == "ended" then
            print("触摸结束")
        elseif event.name == "cancelled" then
            print("触摸取消")
        end
        return true
    end)
    node:setTouchEnabled(true) -- 启用触摸事件 
    node:setTouchSwallowEnabled(false) -- 启用触摸事件吞噬 
    -- Node在响应触摸后（began状态返回true），则会阻止事件传递给父节点
    -- setTouchSwallowEnabled(false) 表示不吞噬触摸事件，允许事件继续传递给父节点

    多点触摸事件：一个时刻可以响应多个触摸点 
    node:setTouchMode(cc.TOUCH_MODE_ALL_AT_ONCE) -- 设置多点触摸模式 
    node:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        -- event.name 触摸事件状态 began、moved、ended、cancelled
        -- event.points 触摸点数组，每个触摸点包含 id, point{x, y}
        for id, point in ipairs(event.points) do
            print(string.format("触摸点 %d: x = %0.2f, y = %0.2f", id, point.x, point.y))
        end

        if event.name == "began" then
            print("触摸开始")
            return true
        elseif event.name == "moved" then
            print("触摸移动")
        elseif event.name == "ended" then
            print("触摸结束")
        elseif event.name == "cancelled" then
            print("触摸取消")
        end
        return true
    end)
    node:setTouchEnabled(true) -- 启用触摸事件 
    node:setTouchSwallowEnabled(false) -- 启用触摸事件吞噬 
    -- Node在响应触摸后（began状态返回true），则会阻止事件传递给父节点
    ]]

    -- 测试 Label 的触摸事件
    local label = display.newTTFLabel({
        text = "点击我",
        size = 40,
        color = cc.c3b(255, 0, 0),
        align = cc.TEXT_ALIGNMENT_CENTER,
        valign = cc.VERTICAL_TEXT_ALIGNMENT_CENTER,
    })  
    label:setPosition(display.cx, display.height - 320)
    label:addTo(self)
    label:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        print(string.format("sprite: %s x, y: %0.2f, %0.2f", event.name, event.x, event.y))
        if event.name == "began" then
            print("触摸开始")
            return true
        end
    end)
    label:setTouchEnabled(true)
    label:setTouchSwallowEnabled(false)
end

function createTestScene(name)
    local scene = display.newScene(name)
    scene:addNodeEventListener(cc.NODE_EVENT, function(event)
        print(string.format("node in scene [%s] NODE_EVENT: %s", name, event.name))
    end)
    return scene
end

return EventScene
