print("Hello World")

-- hello 
--[[
Lua 中的8种基础类型
nil 空
boolean 布尔
number 数字
string 字符串
function 函数
thread 线程
userdata 用户数据
table 表
]]

-- 使用 type() 函数检测变量类型
print(type(var))
var = 20
print(type(var))

var = "hello world"
print(type(var))

var = print
print(type(var))

var = {}
print(type(var)) -- 类型 table


-- boolean 类型的值特别之处，仅 false 和 nil 为假，其余皆为真 包括 0 和 ""
local var = nil
if var then
    print("var is true")
else 
    print("var is false")
end
var = 0
if var then
    print("0 is true")
else 
    print("0 is false")
end

-- local 表示局部变量，不加则为全局变量 
x = 10

function foo()
    y = 20
    local z = 30
    print('x, y, z', x, y, z)
end
foo()
print('x', x)
print('y', y)
print('z', z)

-- **全局变量和局部变量的优先级问题**
-- 使用 _G 表访问全局变量
-- 在 Lua 中，如果一个变量已经作为全局变量声明，
-- 后续在相同作用域或嵌套作用域中再次使用 local 声明同名变量，
-- 那么在 local 声明的变量作用域内，访问该变量时将引用新的局部变量，而不是全局变量。
-- 局部变量在其作用域结束后将消失，全局变量仍然存在。
local l = 'this is local'
_G.l = 'this is global'
print('what is l', l)
print('what is _G.l', _G.l)


-- 使用 .. 连接字符串 
print("Adam " .. "Smith")

-- 使用 # 获取字符串的长度 
print("hello world长度为：", #"hello world")

-- 使用 [[  ]] 来包含多行字符串 
-- 使用 [=[  ]=] 来包含有[[]]的多行字符串 
-- 使用 string.format 来进行 printf 的变量格式化 支持 %d, %s 等 
local multiLineString = [[
这是一个多行字符串
但是不包括\[\[和\]\]
]]
print('多行字符串:\n', multiLineString)

multiLineString = [=[
这是一个多行字符串
包括[[和]]
]=]
print('多行字符串:\n', multiLineString)

-- 多个变量同时声明
local varA, varB, varC  = "A", 44, true
print("多个变量同时声明", varA, varB, varC)


-- table 表示 数组，不给key的时候，key默认从1开始  
local t = { 1, 2, 3, 4}
print(t, t[1]) -- 索引默认从1开始 

t = {
    name = "Adam",
    money = 0
}
print(t.name, t.money)

if not false then
    print("It's not false")
end

-- ~= 是用来表示“不等于”的运算符
if t.money ~= 1 then
    print("t.money ~= 1")
end

local x = 0 or 44
local y = nil or 55
print('x=0 or 44, y=nil or 55', x, y)

-- 交换两个变量的值
x, y = y, x
print('x=0 or 44, y=nil or 55', x, y)

-- 多个返回值
function multiReturn()
    local a, b = 10, 20
    return a, b 
end

print('多个返回值', multiReturn())

-- 因为 lua 中没有 {}，所以如果要单独建立一个代码块，使用 do ... end 
if true then
    do
        local doend = 20
        print('do end 代码块定义的: ', doend)
    end
    print('是否能够访问到上面代码块的局部变量:', doend)
end

-- if then else end 条件语句的 
local a, b, c = 10, 20, 30

if a < b then 
    print('a < b', a, b)
elseif a > c then
    print('a > c', a , c)
else
    print('no above')
end

-- while 循环 
while a < 15 do
    print('a', a)
    a = a + 1
end


-- repeat ... until 循环, 先执行repeat，当until条件为true时结束
-- 类似 C 的 do ... while，先执行一次，然后再判断是否满足   
local i = 0
repeat
    i = i + 1 
    print('i', i)
until i >= 3

-- for 循环
-- 数字型 for var = from, to, step do ... end
-- step 默认为 1，可以省略  
-- 迭代型 for k, v in pairs(table) do ... end 
for j = 0, 10 do
    print('j', j)
end
print('for 内部定义的j是否还能访问？', j)

local days = {"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"}
for k, v in pairs(days) do
    print('for迭代型', v)
end
