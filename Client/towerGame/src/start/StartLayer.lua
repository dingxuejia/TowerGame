--游戏开始页面
local StartLayer = class("StartLayer", function(params)
    return display.newLayer()
end)

function StartLayer:ctor()
	-- body
	local spr = display.newSprite("HelloWorld.png", display.cx, display.cy + 100):addTo(self)

	local battleBtn = ui.newButton({
		normalImage = "HelloWorld.png",
		position = cc.p(display.cx, display.cy - 100),
		scale = 0.6,
		clickAction = function()
			local battleScene = require("battle.BattleScene").new()
			display.runScene(battleScene, "RANDOM", 1)
		end
		})
	self:addChild(battleBtn)
end

return StartLayer