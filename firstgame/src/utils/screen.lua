local Screen = {}

local director = cc.Director:getInstance()
local size = director:getWinSize()

Screen.width = size.width
Screen.height = size.height

return Screen
