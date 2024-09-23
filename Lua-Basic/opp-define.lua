--[[
Lua 通过 table 来实现面向对象编程
通过 : 来定义方法
通过 . 来定义静态方法 

__index 是元表中的一个键，当你在表中访问一个不存在的键时，Lua 会使用 __index 的值来决定返回什么。
__index 可以是一个表或者是一个函数。
表：当你访问一个不存在的键时，Lua 会在这个表中查找相应的键值。
函数：当你访问一个不存在的键时，Lua 会调用这个函数。这个函数接收两个参数：要查找的表和键。

Lua 本身并没有内建的类和对象的概念，但是通过元表（metatable）和函数，可以模拟面向对象编程（OOP）的特性。
元表是一种可以改变表行为的机制，允许你定义自定义的操作，如算术运算、索引、调用等。
通过元表，你可以为表设置一些特殊的行为，比如当访问不存在的键时提供默认值，或者为表添加方法。
{} 在 Lua 中表示一个空表。表是 Lua 中唯一的复合数据类型，可以用来表示数组、字典、对象等各种数据结构。

Lua 中的8种基础类型
nil 空
boolean 布尔
number 数字
string 字符串
function 函数
thread 线程，用来实现协程（coroutine）。Lua 的线程是独立的执行体，通过协程库来管理。
userdata 用户数据，用来表示任意 C 数据在 Lua 中的存储方式。主要用于 Lua 和 C 之间的接口。
table 表，表是 Lua 中唯一的复合数据类型，可以用来表示数组、字典、对象等。

使用 : 定义表的方法，会自动传递调用的表作为self参数给方法
使用 . 定义表的方法，此方法为静态方法，如果要访问self，需要手动传入 

元表的其他魔术方法 
__newindex：定义了当我们尝试给表的一个不存在的键赋值时的行为。
__add, __sub 等：定义了表在进行算术运算时的行为。
__call：定义了当我们尝试像函数一样调用表时的行为。

]]

local Person = {
    hello = 'hello',
    greet = function(self)
        print('Person:greet ', self.hello)
    end
}
Person.__index = Person --[[
通过设置 Person.__index = Person，我们告诉 Lua：如果在对象中找不到某个键，就到 Person 表中去查找。
当我们调用 p1:printInfo() 时，Lua 首先在 p1 对象中查找 printInfo 方法。
如果没找到，它会查看 p1 的元表（也就是 Person）的 __index 字段。 
由于 __index 指向 Person 本身，Lua 就会在 Person 表中查找 printInfo 方法。
]]


function Person:new(name, age)
    print('Person:new -> self: ', self == Person) -- true
    -- 说明 调用 Person:new 方法时，self 是 Person 表本身
    local obj = setmetatable({}, self)
    -- 当我们尝试访问表中不存在的键时，Lua 会查找该表的元表中的 __index 元方法。这正是元表的一个重要作用。
    obj.name = name or "unknown"
    obj.age = age or 0
    return obj
end

function Person:printInfo()
    -- self 是当前表的引用，那个表调用这个方法，self就是那个表
    -- 通过 : 定义的方法，会自动传递调用的表作为self参数给方法
    print("Name: " .. self.name .. ", Age: " .. self.age)
end


local p1 = Person:new("John", 30)
p1:printInfo()

local p2 = Person:new("Jane", 25)
p2:printInfo()

-- 静态方法
function Person.staticMethod()
    print("This is a static method.")
end

Person.staticMethod()
p1.staticMethod()
p2.staticMethod()



-- 测试 __index 元方法
-- 还是要搞懂 setmetatable 到底做了啥，不然代码就跟魔术一样，太神奇了根本看不懂
-- local obj = setmetatable({}, Person) -- 这里到底做啥
-- 反正 __index 是元表的属性，这点有继承 
function Person:printIndex()
    print('Person:printIndex ', self.__index == Person)
    -- print('Person:printIndex ', self.__index) 
end

-- lua 允许 ; 作为语句分隔符
p1:printIndex();p1:greet();


--[[
如果元表不设置 __index，会发生什么事情呢？
]]
local Class  = {
    firstProperty = 'firstProperty',
    firstMethod = function(self)
        print('Class:firstMethod ', self.firstProperty)
    end
}
Class.__index = Class

function Class:new()
    local obj = setmetatable({}, self)
    return obj
end

local obj = Class:new()
obj.self_property = 'self_property'

-- 获取表的所有属性值
print('打印表的所有值:')
for k, v in pairs(obj) do
    print('obj: ', k, v)
end
print('end')
print('obj.__index', obj.__index)
print('obj.__metatable', obj.__metatable)
-- 不给元表设置 __index, obj 访问不到自身之外的属性方法了 
