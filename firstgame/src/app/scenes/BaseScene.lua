local BaseScene = class("BaseScene", function()
    return display.newScene("BaseScene")
end)

-- 在一个文件中使用 local 关键字声明一个变量或引入一个模块时，这个变量或模块的作用域仅限于当前文件。
local Router = require("utils.router")

function BaseScene:ctor()
    self.router = Router

    -- 最上层UI
    self.topUILayer = display.newNode()
    self.topUILayer:setLocalZOrder(3000)
    self:addChild(self.topUILayer)

    print("BaseScene:ctor", self.router.getSceneCount())
    if (self.router.getSceneCount() > 1) then
        self:addBackButton()
    end
end

function BaseScene:addBackButton()

    local backButton = ccui.Button:create("button/btn_back.png")
    backButton:setPosition(30, display.height - 30)  -- 左上角位置
        :setScale(0.4)
        :addTo(self.topUILayer)
        :addTouchEventListener(function(ref, eventType)

        if eventType == cc.EventCode.ENDED then
            Router.goBack()
            end
        end)
end

function BaseScene:onEnter()
end

function BaseScene:onExit()
end


return BaseScene
