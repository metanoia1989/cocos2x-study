local BaseScene = require("app.scenes.BaseScene")
local ButtonScene = class("ButtonScene", BaseScene)

function ButtonScene:ctor()
    self.super.ctor(self)

    -- 创建按钮 
    --[[
    ccui.Button:create(normalImage, selectedImage, disableImage, textType)
    normalImage 正常状态下的图片
    selectedImage 选中状态下的图片
    disableImage 禁用状态下的图片
    textType 图片来源，0从文件，1从精灵帧缓存(可选)。 如果要创建文本按钮，则接口的4个参数均不传值。
    如果要创建文本按钮，则4个参数不传值。
    ]]
    local btn = ccui.Button:create()
    btn:setTitleText("文本按钮")
    btn:setTitleFontSize(24)
    btn:setTitleColor(cc.c3b(0, 255, 0))
    btn:addTo(self)
    btn:pos(display.cx, display.cy + 400)
    -- 所有组件继承自 ccui.Widget，有着共同的触摸事件监听注册函数 addTouchEventListener
    -- 接受两个参数：ref 触发事件的组件，eventType 触摸事件类型
    btn:addTouchEventListener(function(ref, eventType)
        if eventType == cc.EventCode.BEGAN then
            print("触摸开始")
        elseif eventType == cc.EventCode.MOVED then
            print("触摸移动")
        elseif eventType == cc.EventCode.ENDED then
            print("触摸结束")
        elseif eventType == cc.EventCode.CANCELLED then
            print("触摸取消")
        end
    end)

    -- 图片按钮
    local imgBtn = ccui.Button:create("button/btn_n.png", "button/btn_p.png", "button/btn_d.png", 0)
    imgBtn:addTo(self)
    imgBtn:pos(display.cx, display.cy + 300)
    imgBtn:addTouchEventListener(function(ref, eventType)
        -- ref 是触发事件的组件，就是按钮本身了     
        if eventType == cc.EventCode.BEGAN then
            -- ref:setEnabled(false)
            print("图片按钮触摸开始")
        elseif eventType == cc.EventCode.MOVED then
            print("图片按钮触摸移动")
        elseif eventType == cc.EventCode.ENDED then
            print("图片按钮触摸结束")
            -- ref:setEnabled(true)
        elseif eventType == cc.EventCode.CANCELLED then
            print("图片按钮触摸取消")
        end
    end)

    -- checkbox 
    --[[
    ccui.CheckBox:create(
        backGround, 图片状态下显示的背景图片(可选)。
        backGroundSelected, 按下状态下显示的背景图片(可选)。
        cross, 勾选图片图片状态(可选)。
        backGroundDisabled, 禁用状态下显示的背景图片(可 选)。
        frontCrossDisabled, 勾选图片禁用状态(可选)。 
        textType 图片来源，0从文件，1从精灵帧缓存(可选)    
    )
    ]]
    local checkboxBtn = ccui.CheckBox:create(
            "button/btn_n.png", 
            "button/btn_p.png", 
            "button/checkbox_on.png", 
            "button/btn_d.png", 
            "button/checkbox_off.png", 
            0)
        :addTo(self)
        :pos(display.cx, display.cy + 200)
    checkboxBtn:setSelected(true)
    -- checkboxBtn:setEnabled(false)
    checkboxBtn:addTouchEventListener(function(ref, eventType)
        if eventType == ccui.CheckBoxEventType.selected then
            print("checkbox 选中")
        elseif eventType == ccui.CheckBoxEventType.unselected then
            print("checkbox 未选中")
        end
    end)
    
end

return ButtonScene