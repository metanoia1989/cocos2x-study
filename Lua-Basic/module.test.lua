-- 加载lua文件作为模块
local m = require('module')
m.print()

local m2 = require('module2')
m2.sayHello()

-- 直接执行lua文件
dofile('module3.lua')
module3_print()


g = load('print(343)') -- 5.2 之后用 load 替代 loadstring 
g()

-- 加载，然后再运行 
local m4 = loadfile('module4.lua')
m4()
module4.print()