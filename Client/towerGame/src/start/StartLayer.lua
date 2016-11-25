--游戏开始页面
local StartLayer = class("StartLayer", function(params)
    return display.newLayer()
end)

function StartLayer:ctor()
	-- body

	local spr = display.newSprite("HelloWorld.png", display.cx, display.cy):addTo(self)
end

return StartLayer