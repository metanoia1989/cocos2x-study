
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
