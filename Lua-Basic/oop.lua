-- 定义 Animal 类
Animal = {}
Animal.__index = Animal

function Animal:new(name)
    local self = setmetatable({}, Animal)
    self.name = name
    return self
end

function Animal:speak()
    print(self.name .. " makes a sound")
end

-- 定义 Dog 类，继承自 Animal
Dog = {}
Dog.__index = Dog
setmetatable(Dog, {__index = Animal})

function Dog:new(name, breed)
    local self = setmetatable(Animal:new(name), Dog)
    self.breed = breed
    return self
end

function Dog:speak()
    print(self.name .. " barks")
end

function Dog:fetch()
    print(self.name .. " fetches the ball")
end

-- 使用示例
local animal = Animal:new("Generic Animal")
animal:speak()  -- 输出: Generic Animal makes a sound

local dog = Dog:new("Buddy", "Golden Retriever")
dog:speak()  -- 输出: Buddy barks
dog:fetch()  -- 输出: Buddy fetches the ball
print(dog.breed)  -- 输出: Golden Retriever
print("Hello")