local M = {
    _VERSION = '1.0',
    _DESCRIPTION = 'legacy module',
    _URL = 'https://github.com/yourusername/legacy',
    _LICENSE = 'MIT',
    _COPYRIGHT = 'Copyright (c) 2023 yourusername',
}
function M.print()
    print('module ' .. M._VERSION)
end

function M.new()
    return M
end

return M