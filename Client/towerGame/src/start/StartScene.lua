--游戏开始场景
local StartScene = class("StartScene", function()
    return display.newScene()
end)

function StartScene:ctor()
	-- body
	local startLayer = require("start.StartLayer").new()
	self:add(startLayer)
end

return StartScene