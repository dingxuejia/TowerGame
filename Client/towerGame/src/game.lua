--游戏开始文件
local game = class("game")

function game:ctor()

end

function game:run()
	-- body
	local startScene = require("start.StartScene").new()
	cc.Director:getInstance():runWithScene(startScene)
end

return game