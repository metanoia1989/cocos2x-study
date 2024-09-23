
-- 数组初始化 
local luaArray = { 'human', 'tree' } -- 等同于 let jsArray = ['human', 'tree']
local a = luaArray[1] -- 等同于 jsArray[0]
local n = #luaArray -- 等同于 jsArray.length

print("luaArray first element is ", luaArray[1])
print("the length of luaArray is ", n)

-- 在数组头部，移除和插入元素 
local first = table.remove(luaArray, 1) -- first = jsArray.shift()
table.insert(luaArray, 1, first) -- 等同于 jsArray.unshift(first)

-- 在数组尾部，移除和插入元素
table.insert(luaArray, 'grass') -- 等同于 jsArray.push('grass')
local last = table.remove(luaArray) -- last = jsArray.pop()
local last2 = table.remove(luaArray, #luaArray) -- 等同于 jsArray.pop()
print("the last element of luaArray is ", last, last2)
table.insert(luaArray, last2)

-- 遍历数组 等同于 for (let i = 0; i < jsArray.length; i++) 
for i = 1, #luaArray do
    print("the element of luaArray is ", luaArray[i])
end

-- 遍历数组 等同于 for (let value of jsArray)
for index, value in ipairs(luaArray) do
    print("the element of luaArray is ", value)
end
