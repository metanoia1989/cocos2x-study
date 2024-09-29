
local MenuScene = class("MenuScene", function()
    return display.newScene("MenuScene")
end)

function MenuScene:ctor()
    -- 加载精灵帧
    display.addSpriteFrames("fruit.plist", "fruit.png")

    -- 背景图片
    display.newSprite("mainBG.png")
        :pos(display.cx, display.cy)
        :addTo(self)

    -- 开始按钮
    local btn = ccui.Button:create("startBtn_N.png", "startBtn_S.png", "", 1)
        :align(display.CENTER, display.cx, display.cy - 80)
        :addTo(self)
    btn:addTouchEventListener(function(ref, eventType)
        if eventType == cc.EventCode.ENDED then
            print("切换到游戏场景")
            local playScene = require("app.scenes.PlayScene").new()
            display.replaceScene(playScene, "turnOffTiles", 0.5)
        end
    end)

end

function MenuScene:onEnter()
end

function MenuScene:onExit()
end

return MenuScene
