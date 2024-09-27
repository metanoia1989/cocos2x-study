
local BaseScene = require("app.scenes.BaseScene")
local MainScene = class("MainScene", BaseScene)

function MainScene:ctor()
    MainScene.super.ctor(self)

    display.newTTFLabel({text ="首页导航", size = 64, color = display.COLOR_RED})
        :align(display.CENTER_TOP, display.width / 2, display.height - 40)
        :addTo(self)

    ccui.Button:create()
        :setTitleText("Label 标签示例")
        :setTitleFontSize(30)
        :setPosition(display.cx, display.height - 150)
        :addTo(self)
        :addTouchEventListener(function(ref, eventType)
            if eventType == cc.EventCode.ENDED then
                self.router.navigateTo("LabelScene")
            end
        end)


    ccui.Button:create()
        :setTitleText("ccui.Button 按钮示例")
        :setTitleFontSize(30)
        :setPosition(display.cx, display.height - 190)
        :addTo(self)
        :addTouchEventListener(function(ref, eventType)
            if eventType == cc.EventCode.ENDED then
                self.router.navigateTo("ButtonScene")
            end
        end)


end

function MainScene:onEnter()
end

function MainScene:onExit()
end


return MainScene
