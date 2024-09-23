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

-- 三元运算符
local a, b = 10, 20
local max = (a > b) and a or b
print('三元运算符', max)

-- 因为 lua 中没有 {}，所以如果要单独建立一个代码块，使用 do ... end 
if true then
    do
        local doend = 20
        print('do end 代码块定义的: ', doend)
    end
    print('是否能够访问到上面代码块的局部变量:', doend)
end