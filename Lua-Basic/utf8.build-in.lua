--[[
lua5.3 内置了 utf8 库，可以直接使用
-- utf8.char 将码点转换为字符串
-- utf8.charpattern 用于匹配 UTF-8 编码的字符
-- utf8.codes 返回字符串中每个字符的码点和长度
-- utf8.codepoint 返回字符串中指定位置的字符的码点
-- utf8.len 返回字符串的长度
-- utf8.offset 返回字符串中指定位置的字符的码点偏移量
]]



-- 测试用例
print("UTF-8 标准库测试")

-- 测试 utf8.char
print("\n1. utf8.char 测试:")
local char1 = utf8.char(0x4F60) -- 汉字 "你"
local char2 = utf8.char(0x597D) -- 汉字 "好"
print("utf8.char(0x4F60, 0x597D) =", char1 .. char2)

-- 测试 utf8.charpattern
print("\n2. utf8.charpattern 测试:")
print("utf8.charpattern =", utf8.charpattern)
print("'你好' 匹配结果:", string.match("你好", utf8.charpattern))

-- 测试 utf8.codes
print("\n3. utf8.codes 测试:")
for p, c in utf8.codes("你好世界") do
    print("位置:", p, "码点:", c)
end

-- 测试 utf8.codepoint
print("\n4. utf8.codepoint 测试:")
local str = "你好世界"
print("'你' 的码点:", utf8.codepoint(str, 1))
print("'世' 的码点:", utf8.codepoint(str, 7))

-- 测试 utf8.len
print("\n5. utf8.len 测试:")
print("'你好世界' 的长度:", utf8.len("你好世界"))

-- 测试 utf8.offset
print("\n6. utf8.offset 测试:")
local str = "你好世界"
print("第2个字符的偏移量:", utf8.offset(str, 2))
print("第4个字符的偏移量:", utf8.offset(str, 4))

print("\n测试完成")
