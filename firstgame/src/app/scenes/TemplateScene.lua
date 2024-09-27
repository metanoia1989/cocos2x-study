local BaseScene = require("app.scenes.BaseScene")
local TemplateScene = class("TemplateScene", BaseScene)

function TemplateScene:ctor()
    self.super.ctor(self)

    -- 添加业务代码
    display.newTTFLabel({text = "模板场景", size = 40})
        :center() -- 居中显示   
        -- :align(display.CENTER_TOP, display.cx, display.height - 50)
        :addTo(self)

    
end

return TemplateScene
