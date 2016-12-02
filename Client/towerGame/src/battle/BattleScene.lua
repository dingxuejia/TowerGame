--战斗场景
local BattleScene = class("BattleScene", function()
    return display.newScene()
end)

function BattleScene:ctor()
	-- body
	local battleLayer = require("battle.BattleMainLayer").new({level = 1, difficult = 1})
	self:add(battleLayer)
end

return BattleScene