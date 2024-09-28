local BaseScene = require("app.scenes.BaseScene")
local Scheduler2Scene = class("Scheduler2Scene", BaseScene)

function Scheduler2Scene:ctor()
    self.super.ctor(self)

    -- 添加业务代码
    display.newTTFLabel({text = "调度器场景", size = 40})
        :center() -- 居中显示   
        -- :align(display.CENTER_TOP, display.cx, display.height - 50)
        :addTo(self)

    -- 全局调度器, 每一帧执行一次  
    local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
    local schedulerID = scheduler.scheduleUpdateGlobal(function(dt)
        print("全局调度器执行", dt)
    end)
    -- 全局延迟调度器以及取消调度器的方式 
    scheduler.performWithDelayGlobal(function()
        scheduler.unscheduleGlobal(schedulerID)
        print("全局调度器执行完毕")
    end, 0.1)
    -- 全局自定义调度器，可以自定义时间，但是时间间隔必须大于两帧的间隔 
    local customSchedulerID = scheduler.scheduleGlobal(function(dt)
        print("自定义调度器执行", dt)
    end, 0.1)
    scheduler.performWithDelayGlobal(function()
        scheduler.unscheduleGlobal(customSchedulerID)
        print("自定义调度器执行完毕")
    end, 1)


    --[[
    节点调度器只能在节点中使用，当Node销毁时，调度器也会自动销毁    
    节点帧调度器，属于节点帧事件 
    节点自定义调度器，自定义时间间隔必须大于两帧之间的间隔，默认每秒60帧，所以要大于1/60秒
    local action = node:schedule(function()
        print("节点调度器执行")
    end, 0.1)
    node:stopAction(action)

    local actionDelay = node:performWithDelay(function()
        node:unschedule(action)
        print("节点调度器执行完毕")
    end, 1)
    node:stopAction(actionDelay)
    ]]
    local action = self:schedule(function()
        print("节点调度器执行")
    end, 0.1)

    self:performWithDelay(function()
        self:stopAction(action)
        print("节点调度器执行完毕")
    end, 1)
end

return Scheduler2Scene
