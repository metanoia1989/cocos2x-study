local PlayScene = class("PlayScene", function()
    return display.newScene("PlayScene")
end)
local FruitItem = import(".FruitItem")

function PlayScene:ctor()

    --[[
    游戏场景UI分为 HighScore, Stage, Target, 当前得分 和 进度条。   
    ]]
    self.highScore = 0
    self.stage = 0
    self.target = 123
    self.currentScore = 0

    self.xCount = 8 -- 水平方向水果数
    self.yCount = 8 -- 垂直方向水果数
    self.fruitGap = 0 -- 水果间距 

    self.scoreStart = 5 -- 水果基分
    self.scoreStep = 10 -- 加成分数 
    self.activeScore = 0 -- 当前高亮水果分数 

    math.newrandomseed() -- 初始化随机数种子 
    
    -- 初始化1号水果的左下角坐标常量 
    self.matricLBX = (display.width - FruitItem.getWidth() * self.xCount - (self.yCount  - 1) * self.fruitGap) / 2
    self.matricLBY = (display.height - FruitItem.getWidth() * self.yCount - (self.xCount  - 1) * self.fruitGap) / 2 - 30

    self:initUI()

    -- 等待转场效果结束，再进行矩阵初始化
    self:addNodeEventListener(cc.NODE_EVENT, function (event) 
        if event.name == "enterTransitionFinish" then
            self:initMatrix()
        end
    end)
end


function PlayScene:initUI()
    -- align 设置锚点和坐标 
    display.newSprite("#high_score.png")
        :align(display.LEFT_CENTER, display.left + 15, display.top - 30)
        :addTo(self)

    display.newSprite("#highscore_part.png")
        :align(display.LEFT_CENTER, display.cx + 10, display.top - 26)
        :addTo(self)


    self.highScoreLabel = display.newBMFontLabel({
        text = tostring(self.highScore),
        font = "font/earth38.fnt",
    })
    :align(display.CENTER, display.cx + 105, display.top - 24)
    :addTo(self)
        
    -- 显示消除可得分数 
    self.activeScoreLabel = display.newTTFLabel({
        text = "", size = 30
    })
    :setColor(display.COLOR_WHITE)
    :pos(display.width / 2, 120)
    :addTo(self)
end

function PlayScene:initMatrix()
    -- 初始化矩阵
    self.matrix = {} -- 空矩阵 
    self.actives = {} -- 高亮水果 
    for y = 1, self.yCount do
        for x = 1, self.xCount do
            if y == 1 and x == 2 then
                -- 确保初始化的矩阵至少有两个相同的水果相邻
                self:createAndDropFruit(x, y, self.matrix[1].fruitIndex)
            else
                self:createAndDropFruit(x, y)
            end
        end
    end
end

-- 水果下落算法
function PlayScene:createAndDropFruit(x, y, fruitIndex)
    local newFruit = FruitItem.new(x, y, fruitIndex)
    local endPosition = self:positionOfFruit(x, y)
    local startPosition = cc.p(endPosition.x, endPosition.y + display.height / 2)
    newFruit:setPosition(startPosition)
    local speed = startPosition.y / ( display.height * 2)
    newFruit:runAction(cc.MoveTo:create(speed, endPosition))
    self.matrix[(y-1) * self.xCount + x] = newFruit
    self:addChild(newFruit)

    -- 绑定触摸事件 
    newFruit:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
        print('event', event.name)
        if event.name == "began" then
            return true
        end

        if event.name == "ended" then
            if newFruit.isActive then
                -- 消除高亮水果，加分，并掉落补全 
                self:removeActivedFruits()
                self:dropFruits()
            else
                self:inactive() -- 清除已高亮水果 
                self:activeNeighbor(newFruit) -- 高亮周围相同水果 
                self:showActivesScore() -- 计算高亮区域水果的分数 
            end
        end
    end)
    newFruit:setTouchEnabled(true)
end

function PlayScene:positionOfFruit(x, y)
    local px = self.matricLBX + (x - 1) * (FruitItem.getWidth() + self.fruitGap)  + FruitItem.getWidth() / 2
    local py = self.matricLBY + (y - 1) * (FruitItem.getWidth() + self.fruitGap) + FruitItem.getWidth() / 2
    return cc.p(px, py)
end


function PlayScene:inactive()
    for _, fruit in ipairs(self.actives) do
        fruit:setActive(false)
    end
    self.actives = {}
end

-- 高亮水果以及周围相同水果
function PlayScene:activeNeighbor(fruit)
    -- 高亮 fruit
    if fruit.isActive == false then
        fruit:setActive(true)
        table.insert(self.actives, fruit)
    end

    -- 检查上下左右水果是否相同
    if fruit.x - 1 >= 1 then
        local leftFruit = self.matrix[(fruit.y-1) * self.xCount + fruit.x - 1]
        if leftFruit.fruitIndex == fruit.fruitIndex and leftFruit.isActive == false then
            self:activeNeighbor(leftFruit)
        end
    end
    if fruit.x + 1 <= self.xCount then
        local rightFruit = self.matrix[(fruit.y-1) * self.xCount + fruit.x + 1]
        if rightFruit.fruitIndex == fruit.fruitIndex and rightFruit.isActive == false then
            self:activeNeighbor(rightFruit)
        end
    end
    if fruit.y - 1 >= 1 then
        local upFruit = self.matrix[(fruit.y-1) * self.xCount + fruit.x]
        if upFruit.fruitIndex == fruit.fruitIndex and upFruit.isActive == false then
            self:activeNeighbor(upFruit)
        end
    end
    if fruit.y + 1 <= self.yCount then
        local downFruit = self.matrix[(fruit.y-1) * self.xCount + fruit.x]
        if downFruit.fruitIndex == fruit.fruitIndex and downFruit.isActive == false then
            self:activeNeighbor(downFruit)
        end
    end
end

-- 分数显示算法 
function PlayScene:showActivesScore()
    -- 只有一个高亮，取消高亮并返回 
    if #self.actives == 1 then
        self:inactive()
        self.activeScoreLabel:setString("")
        self.activeScore = 0
        return
    end

    -- 水果分数依次为 5,15,25,35,..., 求和 
    self.activeScore = (self.scoreStart * 2 + self.scoreStep * (#self.actives - 1)) * #self.actives / 2
    self.activeScoreLabel:setString(string.format("%d 连消，得分 %d", #self.actives, self.activeScore))
end

-- 水果的消除 
function PlayScene:removeActivedFruits()
    local fruitScore = self.scoreStart 
    for _, fruit in ipairs(self.actives) do
        if fruit then
            -- 从矩阵中移除 
            self.matrix[(fruit.y-1) * self.xCount + fruit.x] = nil
            -- 分数特效
            self:scorePopupEffect(fruitScore, fruit:getPosition())
            fruitScore = fruitScore + self.scoreStep
            fruit:removeFromParent()
        end
    end

    -- 清空高亮数组 
    self.actives = {}

    -- 更新当前得分 
    self.currentScore = self.currentScore + self.activeScore
    self.currentScoreLabel:setString(tostring(self.currentScore))

    -- 清空高亮水果分数统计 
    self.activeScoreLabel:setString("")
    self.activeScore = 0
end

-- 水果掉落补全
function PlayScene:dropFruits()
    local emptyInfo = {}

    -- 1. 掉落已存在的水果
    -- 一列一列处理
    for x = 1, self.xCount do
        local removedFruits = 0
        local newY = 0
        -- 从下往上处理 
        for y = 1, self.yCount do
            local temp = self.matrix[(y-1) * self.xCount + x]
            if temp == nil then
                -- 水果已被移除
                removedFruits = removedFruits + 1
            else
                -- 如果水果下有空缺，向下移动空缺个位置 
                if removedFruits > 0 then
                    newY = y - removedFruits
                    self.matrix[(newY - 1) * self.xCount + x] = temp
                    temp.y = newY
                    self.matrix[(y-1) * self.xCount + x] = nil

                    local endPosition = self:positionOfFruit(x, newY)
                    local speed = (temp:getPositionY() - endPosition.y) / display.height * 2
                    temp:stopAllActions()
                    temp:runAction(cc.MoveTo:create(speed, endPosition))
                end
            end
        end
        -- 记录本列最终空缺数
        emptyInfo[x] = removedFruits
    end
    
    -- 2. 掉落新水果补齐空缺 
    for x = 1, self.xCount do
        for y = self.yCount - emptyInfo[x] + 1, self.yCount do
            self:createAndDropFruit(x, y)
        end
    end
end


-- 分数特效
function PlayScene:scorePopupEffect(score, px, py)
    local labelScore = display.newBMFontLabel({text = tostring(score), font = "font/earth32.fnt"})
        :pos(px, py)
        :addTo(self)

    local move = cc.MoveBy:create(0.8, cc.p(0, 80))
    local fadeOut = cc.FadeOut:create(0.8)
    local action = cc.Sequence:create(
        cc.Spawn:create(move, fadeOut),
        cc.CallFunc:create(function() labelScore:removeFromParent() end)
    )
    labelScore:runAction(action)
end

return PlayScene