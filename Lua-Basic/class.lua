-- 定义一个类 Person
Person = {}
Person.__index = Person

-- 构造函数
function Person:new(name, age)
    local obj = setmetatable({}, Person)
    obj.name = name or "unknown"
    obj.age = age or 0
    return obj
end

-- 方法：打印信息
function Person:printInfo()
    print("Name: " .. self.name .. ", Age: " .. self.age)
end

-- 静态方法
function Person.staticMethod()
    print("This is a static method.")
end


-- 调用静态方法
Person.staticMethod()

-- 创建实例
local person = Person:new("Alice", 30)

-- 调用实例方法
person:printInfo()

