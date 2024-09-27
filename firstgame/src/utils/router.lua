local Router = {}

Router.redirectTo = function(sceneName)
    if type(sceneName) ~= "string" then
        print("Error: sceneName must be a string")
        return
    end
    local sceneClass = require("app.scenes." .. sceneName)
    local scene = sceneClass.new()
    cc.Director:getInstance():replaceScene(scene)
end

-- 静态方法，必须通过 . 来调用，而不能通过 : 来调用 
Router.navigateTo = function(sceneName)
    if type(sceneName) ~= "string" then
        print("Error: sceneName must be a string")
        return
    end
    local sceneClass = require("app.scenes." .. sceneName)
    local scene = sceneClass.new()
    cc.Director:getInstance():pushScene(scene)
end

Router.goBack = function()
    cc.Director:getInstance():popScene()
end

Router.backHome = function()
    display.replaceScene(require("app.scenes.MainScene").new())
end

-- 获取当前场景栈中的场景数量
Router.getSceneCount = function()
    local director = cc.Director:getInstance()
    return director:getRunningScene() and director:getRunningScene():getChildrenCount() or 0
end

return Router