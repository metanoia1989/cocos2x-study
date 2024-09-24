
-- 两种函数的定义方式   
function abc() print('hello') end
abc2 = function() print('bbb') end
abc()
abc2()

-- 接收函数的多个返回值 
function foo()
    return 30, 50
end
local x, y = foo()
print("函数多个返回值赋值", x, y)
-- 以下情况，函数的多返回值会被省略 
local a, b  = foo(), 20
print("函数多个返回值赋值", a, b)

function singe()
    return (foo()) -- 括号内会强制一个返回值 
end
print("测试单个返回值", singe())

-- unpack 接收一个数组参数，从下标1开始返回数组的所有元素
-- print('unpack', unpack({10, 20, 30, 40, 50}))
-- 将数组（表）中的元素解包成可变数量的返回值 使用 table.unpack
function foo2()
    return table.unpack({10, 20, 30})
end
print('测试 table.unpack() 解包数组为多个返回值', foo2())

-- 可变参数 ... 可以接收多个参数
-- 使用 {...} 来访问变长参数 
function add(...)
    print(...)
    local s = 0
    for i, v in ipairs{...} do
        s = s + v
    end
    return s
end

add(1, 2, 3, 4, 5)
print(add(4, 5))


-- 闭包函数，函数作为返回值 
-- 此时i为外部的局部变量 upvalue 
function newCounter()
    local i = 0 
    return function ()
       i = i + 1 
       return i
    end
end

local c1 = newCounter()
print('计时器一次', c1())
print('计时器二次', c1())


local g = function (x) return math.sin(x) end

-- 调用函数的几种方式
local f = function (s) 
    if type(s) == 'string' then
        print(s) 
    elseif type(s) == 'table' then
        local result = ''
        for k, v in pairs(s) do
            result = result .. k .. ' = ' .. v .. ', '
        end
        -- 去掉最后一个逗号
        result = result:sub(1, -3)
        print(result)
    else
        print('s is not a string or table')
    end
end
f('hello f')
f "hello f"
f 'hello f'
f [[hello f]]
f {x = 10, y = 20}

local x = {
    name = 'table_x',
}
x.move = function (x, a, b)
    print('move', x.name, a, b)
end
x:move(10, 20)  -- 等同于 x.move(x, 10, 20)
-- 调用静态方法的快捷方式，尤其定义.move，并且第一个参数为自身  


print('===========================================')
print('函数默认参数')
-- 函数默认参数
-- lua 不支持默认参数，如果参数没有传递，则值为nil
function func(x, y, z)
    if not y then y = 0 end
    if not z then z = 0 end
    print("x, y, z", x, y, z)
end
func(1, 2, 3)
func(1, 2)
func(1)
func()

-- 也可以使用 or 来设置默认参数
function func2(x, y, z)
    y = y or 0
    z = z or 0
    print("x, y, z", x, y, z)
end
func2(1, 2, 3)
func2(1, 2)
func2(1)
func2()
print('===========================================')