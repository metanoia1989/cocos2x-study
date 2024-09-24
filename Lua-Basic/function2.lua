print('===========================================')
print('函数调用的几种方式')
function f_print(str)
    print('f_print', str)
end

f_print('标准形式') -- 标准形式 
f_print "省略括号"
f_print '单引号字符串'
f_print [[多行字符串]]
f_print {x = 10, y = 20} -- 表作为参数
print('===========================================')

print('===========================================')
print('函数的可变参数')
-- ... 不是任何类型，而是参数值的列表 
--[[
select 有两种主要用法：
1. 如果第一个参数是一个数字 n，那么 select 返回从第 n 个参数开始至所有剩余的参数。
   select(n, ...) 返回从第 n 个参数开始至所有剩余的参数。

2. 如果第一个参数是字符串 "#"，那么 select 返回所有参数的数量。 
   select('#', ...) 返回所有参数的数量。

]]
function sum(...)
    local ret = 0
    for i = 1, select('#', ...) do
        ret = ret + select(i, ...)
    end
    return ret
end

-- 也可以通过 {...} 来访问所有参数
function sum2(...)
    local ret = 0
    for _, v in ipairs({...}) do
        ret = ret + v
    end
    return ret
end
print('sum(1, 2, 3, 4, 5) = ')
print(sum(1, 2, 3, 4, 5))
print(sum2(1, 2, 3, 4, 5))
print('===========================================')


local t = {}
function t:func(x, y)
    self.x = x
    self.y = y
    print('self.x', self.x)
    print('self.y', self.y)
end

t:func(10, 20) -- 等价于 t.func(t, 10, 20)，算是一种语法糖 

