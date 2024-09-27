local BaseScene = require("app.scenes.BaseScene")
local TransitionScene = class("TransitionScene", BaseScene)

function TransitionScene:ctor()
    self.super.ctor(self)

    display.newTTFLabel({text = "场景切换示例", size = 40, color = display.COLOR_YELLOW})
        :align(display.CENTER_TOP, display.cx, display.height - 50)
        :addTo(self)

    --[[
    display.replaceScene(scene, transitionType, time, more)
    -- 切换到新场景
    -- @function [parent=#display] replaceScene
    -- @param Scene newScene 场景对象
    -- @param string transitionType 过渡效果名
    -- @param number time 过渡时间
    -- @param mixed more 过渡效果附加参数
    ]]
    ccui.Button:create()
        :setTitleText("默认场景切换")
        :setTitleFontSize(30)
        :setPosition(display.cx, display.height - 120)
        :addTo(self)
        :addTouchEventListener(function(ref, eventType)
            if eventType == cc.EventCode.ENDED then
                local scene = require("app.scenes.TemplateScene")
                display.replaceScene(scene.new())
            end
        end)

    ccui.Button:create()
        :setTitleText("淡入淡出场景切换")
        :setTitleFontSize(30)
        :setPosition(display.cx, display.height - 160)
        :addTo(self)
        :addTouchEventListener(function(ref, eventType)
            if eventType == cc.EventCode.ENDED then
                local scene = require("app.scenes.TransitionScene")
                -- 红色渐变作为转场切换效果     
                display.replaceScene(scene.new(), "fade", 1, cc.c3b(255, 0, 0))
            end
        end)
    
    ccui.Button:create()
        :setTitleText("跳跃放大切换场景")
        :setTitleFontSize(30)
        :setPosition(display.cx, display.height - 200)
        :addTo(self)
        :addTouchEventListener(function(ref, eventType)
            if eventType == cc.EventCode.ENDED then
                local scene = require("app.scenes.TransitionScene")
                display.replaceScene(scene.new(), "jumpZoom", 1, { duration = 1 })
            end
        end)

    ccui.Button:create()
        :setTitleText("翻转关闭瓷砖")
        :setTitleFontSize(30)
        :setPosition(display.cx, display.height - 240)
        :addTo(self)
        :addTouchEventListener(function(ref, eventType)
            if eventType == cc.EventCode.ENDED then
                local scene = require("app.scenes.TransitionScene")
                display.replaceScene(scene.new(), "slideInL", 1, { duration = 1 })
            end
        end)
end

return TransitionScene
