local BaseScene = require("app.scenes.BaseScene")
local SchedulerScene = class("SchedulerScene", BaseScene)

function SchedulerScene:ctor()
    self.super.ctor(self)

    self.count = 0
    self.schedulerID = nil

    display.newTTFLabel({text = "定时器示例", size = 40})
        :align(display.CENTER_TOP, display.cx, display.height - 50)
        :addTo(self)

    self.countLabel = display.newTTFLabel({text = "计数: 0", size = 30})
        :align(display.CENTER, display.cx, display.cy)
        :addTo(self)


    -- 开始按钮
    ccui.Button:create()
        :setTitleText("开始")
        :setTitleFontSize(30)
        :setPosition(display.cx - 100, display.cy - 100)
        :addTo(self)
        :addTouchEventListener(function(ref, eventType)
            if eventType == cc.EventCode.ENDED then
                self:startScheduler()
            end
        end)

    -- 停止按钮
    ccui.Button:create()
        :setTitleText("停止")
        :setTitleFontSize(30)
        :setPosition(display.cx + 100, display.cy - 100)
        :addTo(self)
        :addTouchEventListener(function(ref, eventType)
            if eventType == cc.EventCode.ENDED then
                self:stopScheduler()
            end
        end)

    -- performWithDelay
    self:performWithDelay(function()
        print("after 5 seconds, performWithDelay")
    end, 5.0)


    -- 一次性定时器的写法，执行之后立即取消
    local scheduler = cc.Director:getInstance():getScheduler()
    local schedulerID -- 必须先定义，不然下面的内部匿名函数访问不到      
    schedulerID = scheduler:scheduleScriptFunc(function(dt)
        scheduler:unscheduleScriptEntry(schedulerID)
        print("一次性定时器", dt, schedulerID)
    end, 1.0, false)

    -- scene:schedule 这个lua绑定没提供取消的，不建议使用   
    -- self:schedule(function()
    --     print("after 2 seconds, scene:schedule")
    -- end, 2)
end

function SchedulerScene:startScheduler()
    if self.schedulerID == nil then
        local scheduler = cc.Director:getInstance():getScheduler()
        self.schedulerID = scheduler:scheduleScriptFunc(function(dt)
            -- dt 代表了两次调用之间的时间间隔（delta time）
            self.count = self.count + 1
            self.countLabel:setString("计数: " .. self.count)
            -- print("计数: " .. self.count)
        end, 0.2, false)
    end
end

function SchedulerScene:stopScheduler()
    if self.schedulerID ~= nil then
        local scheduler = cc.Director:getInstance():getScheduler()
        scheduler:unscheduleScriptEntry(self.schedulerID)
        self.schedulerID = nil
    end
end

function SchedulerScene:onExit()
    self:stopScheduler()
    SchedulerScene.super.onExit(self)
end

function SchedulerScene:printHello(dt)
    print("hello # ", dt)
end

return SchedulerScene
