--[[
js 的 symbol 可以作为对象的唯一键，lua 的 table 也可以

-- javascript 的 symbol 作为键的演示 
-- file1.js
export const obj = {}
export const symbol1 = Symbol()
obj[symbol1] = 'symbol value from file1'

-- file2.js
export const obj = {}
const symbol2 = Symbol()
obj[symbol2]  = 'symbol value from file2'

-- main.js
const { obj: obj1, symbol1 } = require('./file1')
const { obj: obj2, symbol2 } = require('./file2')
console.log(obj1[symbol1])
console.log(obj2[symbol2])
]]

-- lua 的 table 作为键的演示

local aTable = {}
local key1 = {}
aTable[key1] = 100

local key2 = {}
aTable[key2] = 200

print(aTable[key1], aTable[key2])