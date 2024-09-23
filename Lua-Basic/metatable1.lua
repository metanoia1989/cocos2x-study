print(_G)

-- 遍历 _G
for k, v in pairs(_G) do
    print(k, v)
end

print("当前 lua 版本", _VERSION)