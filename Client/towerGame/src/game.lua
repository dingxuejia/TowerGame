--游戏开始文件
local game = class("game")

function game:ctor()
	-- 加载必全局变量
	require("config.BaseConfig")

	require("common.commonFunc")
	require("common.Ui")
	require("common.Notification")
end

function game:run()
	-- body
	local startScene = require("start.StartScene").new()
	cc.Director:getInstance():runWithScene(startScene)
end

return game