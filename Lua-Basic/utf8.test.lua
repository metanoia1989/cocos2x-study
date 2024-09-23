--[[
Lua 字符串实际上是字节序列，并且没有内置的对 Unicode 进行特殊处理的功能。
这意味着 Lua 的字符串处理函数（如 string.sub、string.len 等）是基于字节操作的，而不是基于字符操作的。
当处理 UTF-8 编码的字符串时，这一点尤其重要，因为 UTF-8 是一种可变长度的编码，每个字符可以由 1 到 4 个字节组成。

安装 lua-utf8 库 luarocks install luautf8
]]

local utf8 = require 'lua-utf8'

local str = 'Hello, 世界'

print("Length of str: ", utf8.len(str))

local firstChar = utf8.sub(str, 1, 1)
local lastChar = utf8.sub(str, -1, -1)
print('firstChar: ', firstChar, 'lastChar: ', lastChar)
print('bit length of firstChar: ', string.len(firstChar))
print('bit length of lastChar: ', string.len(lastChar))

