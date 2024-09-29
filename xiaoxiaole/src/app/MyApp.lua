
require("config")
require("cocos.init")
require("framework.init")

local AppBase = require("framework.AppBase")
local MyApp = class("MyApp", AppBase)

function MyApp:ctor()
    MyApp.super.ctor(self)
end

function MyApp:run()
    -- 添加资源搜索路径 
    cc.FileUtils:getInstance():addSearchPath("res/")
    -- 设置内容缩放因子 
    cc.Director:getInstance():setContentScaleFactor(640 / CONFIG_SCREEN_WIDTH)
    self:enterScene("MenuScene")
end

return MyApp
