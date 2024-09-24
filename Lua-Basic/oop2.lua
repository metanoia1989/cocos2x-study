local Dog = {}

Dog.__index = Dog

function Dog:new()
    -- self.__index = self
    local instance = { sound = 'woof' }
    return setmetatable(instance, self)
end

function Dog:makeSound()
    print('I say ' .. self.sound)
end

local myDog = Dog:new()
myDog:makeSound()

-- 继承
-- 正确的继承实现需要为每个新类设置适当的元表和 __index
local LoundDog = Dog:new() 
-- 此时 Dog:new() 中的 self 为 Dog，而Dog本身设置了 __index，所以查找行为是正常的
-- 即 LoundDog 的元表为Dog，有 __index 属性

function LoundDog:makeSound()
    s = self.sound .. ' '
    print(s .. s .. s)
end

local myLoundDog = LoundDog:new()
-- 此时 new() 中的 self 为 LoundDog，而LoundDog本身没有设置了__index
-- 但是 LoundDog 有属性 makeSound啊，为啥是nil呢？
print('is myLoundDog.makeSound == nil', myLoundDog.makeSound == nil) -- true
print('is LoundDog.__index == Dog', LoundDog.__index == Dog) -- true
print('is LoundDog.__index raw is nil', rawget(LoundDog, '__index') == nil) -- true
-- myLoundDog:makeSound()
-- myLoundDog 是一个新的表，其__index为空，元表为LoundDog
-- LoundDog.__index 为Dog 
-- 当 lua 无法在 myLoundDog 上找到属性时，会在 .__index 上查找
-- LoundDog 有 makeSound，但是 myLoundDog 没有 
-- 而 myLoundDog 的 __index 为空，所以最终找不到 
-- 但是 LoundDog 的 __index 为 Dog，在 setmetatable(myLoundDog, LoundDog) 时，
-- 为啥没有把 __index 传递下来呢？？？？ 
-- 因为访问 LoundDog.__index 时，lua 会向上传递，但是设置时，只会查找表当前的属性
-- 所以本质上 LoundDog.__index 是为nil的    
print('is Dog.__index raw is nil', rawget(Dog, '__index') == nil) -- false


print('is myLoundDog.__index == LoundDog', myLoundDog.__index == LoundDog)
print('is myLoundDog.__index == Dog', myLoundDog.__index == Dog)
print('what is myLoundDog.__index', myLoundDog.__index) -- 竟然为nil
print('what is LoundDog.__index', LoundDog.__index)
print('what is LoundDog:new', LoundDog.new == Dog.new)
-- loundGod.new 是 Dog.new 的一个引用，所以是相等的
-- 但是LoundDog 调用 new时，将自己设置为新table的元表，而自己是 {} 
-- 而 lua 的元表的 __index 不会向上查找，所以导致找不到
--[[
setmetable(instance, Dog)
通过设置元表，你可以控制对象 instance 的行为，例如，当访问 instance 中不存在的键时，Lua 会参考它的元表来决定如何处理。
self.__index = self 
这个只是设置__index，影响表的查找行为 
]]

local dogAnother = Dog:new()
dogAnother:makeSound()
-- 明天起来分析这个继承的问题   


--[[
经过上处的探讨和论述，说明如下：
当我们执行 local LoundDog = Dog:new() 时，只是将 Dog 设置为 LoundDog 的元表，并没有直接将 __index 属性赋值给 LoundDog。
setmetatable 函数只设置元表，不会复制元表的属性到新表中。这个教程文章都没说这一点，太坑了。

Lua 查找表属性的顺序如下：
1. 首先在表本身查找属性
2. 在自身上没有找到，则查看表是否有 __index 元方法
 a. 如果 __index 元方法是一个表，则继续在 __index 表中查找
 b. 如果 __index 元方法是一个函数，则调用该函数
3. 如果表没有 __index 元方法，则查看其元表是否有 __index 元方法，然后重复步骤 2

=_= 卧槽，还是查元表的__index吗，而不是元表的属性吗？ 
我得试验一下看看 
]]

-- 测试当元表未设置__index时，是否直接查找元表的属性
local Cat = {}
Cat.__index = Cat 
-- 没有这一行，myCat:makeSound() 会报错
-- 说明当元表未设置__index时，不会直接查找元表的属性
-- 所以元表的关键，还是其各种元方法 
-- 表本身没有设置元方法，则会调用元表的元方法 

function Cat:new()
    local instance = { sound = 'meow' }
    return setmetatable(instance, Cat)
end

function Cat:makeSound()
    print('I say ' .. self.sound)
end

local myCat = Cat:new()
myCat:makeSound()


-- OOP 的继承标准写法如下 
print('==========')
local Animal = {}

-- function tablename:fn(...) is the same as
-- function tablename.fn(self, ...)
-- The : just adds a first arg called self.
-- Reminder: setmetatable returns its first arg.
function Animal:new(sound)
    sound = sound or 'woo'
    self.__index = self
    local instance = { sound = sound }
    return setmetatable(instance, self)
end

function Animal:makeSound()
    print('I say ' .. self.sound)
end

local Sheep = Animal:new('mou')
Sheep:makeSound()

-- 继承
local Ox = Animal:new('ang')
Ox:makeSound()

