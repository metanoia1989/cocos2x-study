-- nil 表示没有元表 
print(getmetatable(nil))

-- 使用 setmetable() 来给类定义元方法
Set = {}
function Set.new(t)
    local set = {}
    for i, v in ipairs(t) do
        set[v] = true
    end
    return set 
end

function Set.union(a, b)
    local res = Set.new{}
    for k in pairs(a) do     
        res[k] = true
    end
    for k in pairs(b) do     
        res[k] = true
    end
    return res
end

function Set.intersection(s1, s2)
    local res = Set.new{}
    for k in pairs(s1) do
        if s2[k] then
            res[k] = true
        end
    end
    return res
end

function Set.tostring(set)
    local s = "{" 
    local sep = ""
    for e in pairs(set) do
        s = s .. sep .. e
        sep = ", "
    end
    return s .. "}"
end

function Set.print(s)
    print(Set.tostring(s))
end

