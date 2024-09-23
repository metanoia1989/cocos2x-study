
local LabelScene = class("LabelScene", function()
    return display.newScene("LabelScene")
end)

function LabelScene:ctor()
    -- quick.display 的 ttf 接口 
    local label = display.newTTFLabel({
        text = "标签文字内容", 
        size = 22, 
        color = display.COLOR_BLUE,
        -- font = "fonts/Marker Felt.ttf" -- 设置字体 
        dimensions = cc.size(600, 50),
        align = cc.TEXT_ALIGNMENT_LEFT, -- 水平对齐方式 LEFT, CENTER, RIGHT 
        valign = cc.VERTICAL_TEXT_ALIGNMENT_BOTTOM -- 垂直对齐方式 TOP, CENTER, BOTTOM
    })
        :align(display.CENTER, display.cx, display.cy)
        :addTo(self)
    -- 重新设置文本标签内容     
    label:setString("display.newTTFLabel 系统默认字体") 

    -- 外置TTF文本标签 
    local ttfLabelSrc = display.newTTFLabel({
        text = "display.newTTFLabel external font",
        font = "CreteRound-Italic.ttf",
        size = 30,
        align = cc.TEXT_ALIGNMENT_LEFT,
        color = display.COLOR_ORANGE,
        dimensions = cc.size(600, 50),
        x = display.cx,
        y = display.cy - 50
    })
    self:addChild(ttfLabelSrc)

    -- cc.Label 引擎底层文本标签接口 
    cc.Label:createWithSystemFont(
        "cc.Label 引擎底层文本标签接口", "Arial", 
        30, -- 字体大小 
        cc.size(600, 250), -- 文本显示区域 
        cc.TEXT_ALIGNMENT_LEFT
        -- cc.VERTICAL_TEXT_ALIGNMENT_CENTER -- 垂直对齐方式
    )
        :setTextColor(cc.c4b(255, 0, 0, 255))
        :addTo(self)
        :pos(display.cx, display.cy + 200)

    cc.Label:createWithTTF("cc.Label external font", "CreteRound-Italic.ttf", 30)
        :addTo(self)
        :pos(display.cx, display.cy + 250)

    -- ccui.Text 系统字体 
    ccui.Text:create("ccui.Text 系统字体", "", 30)
        :addTo(self)
        :pos(display.cx, display.cy - 150)
    ccui.Text:create("ccui.Text TTF font", "CreteRound-Italic.ttf", 30)
        :addTo(self)
        :pos(display.cx, display.cy - 180)

    -- display.TextBMFont 纹理字体 
    display.newBMFontLabel({
        text = "display.newBMFontLabel",
        font = "helvetica-32.fnt",
        x = display.cx,
        y = display.cy - 220
    })
        :addTo(self)

    cc.Label:createWithBMFont("helvetica-32.fnt", "cc.Label.BMFont", 
        cc.TEXT_ALIGNMENT_LEFT, -- halign 水平对齐方式 
        0, -- maxLineWidth 最大行宽 
        cc.p(0, 0) -- imageOffset 位图偏移
    )
        :addTo(self)
        :pos(display.cx, display.cy - 250)

    -- ccui.TextBMFont 与 BitmapLabel 控件对应  
    ccui.TextBMFont:create("ccui.TextBMFont", "helvetica-32.fnt")
        :addTo(self)
        :pos(display.cx, display.cy - 280)

    -- 图集文本标签🏷️ 
    -- 图集文本标签是由一连串等宽图片拼接成的一张整图，这些图片中符号的ASCII码是连续的
    -- 图集文本标签通常是0～9这几个数字，在游戏中用来显示资源数量等。 
    -- charMapFile 图集图片路径; itemWidth 字符图片宽; itemHeight 字符图片高; startCharMap 图集第一个字符的ASCII码   
    cc.Label:createWithCharMap("number.png", 19, 35, string.byte(0))
        :addTo(self)
        :pos(display.cx, display.cy - 320)
        :setString("9823423423")
    ccui.TextAtlas:create("9823423423", "number.png", 19, 35, "0")
        :addTo(self)
        :pos(display.cx, display.cy - 350)
end

function LabelScene:onEnter()
end

function LabelScene:onExit()
end

return LabelScene
