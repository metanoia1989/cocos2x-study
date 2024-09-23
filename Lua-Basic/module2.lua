local M = { }

local function sayName()
    print("Adam Smith")
end

function M.sayHello()
    print("Why hello there")
    sayName()
end

return M