--游戏开始页面
local BattleMainLayer = class("BattleMainLayer", function(params)
    return display.newLayer()
end)

local BattleData = require("data.BattleData")

--[[
	table params:
	level:选择的关卡
	difficult: 难度
]]
function BattleMainLayer:ctor(params)
	self.level = params.level
	self.difficult = params.difficult

	--初始化数据
	BattleData:init(self.level, self.difficult)
	self.enemyData = BattleData:getMapEnemy()  --全部敌人
	self.enemyPath = BattleData:getMapPath()	--路径信息

	self:initUis()
end

function BattleMainLayer:initUis()
	--添加背景
	self.backSpr = ui.newSprite({
		image = BattleData:getMapPic(),
		position = cc.p(display.cx, display.cy)
		})
	self:addChild(self.backSpr)

	self:createPath()
end

--绘制敌人行走路线
function BattleMainLayer:createPath()
	for _,path in pairs(self.enemyPath) do
		for i,x in pairs(path.x) do
			print(i,x)
			local y = path.y[i]
			local pos = cc.p(getPosbyBlock(x, y))

			--创建小方格
			local pathSpr =  ui.newSprite({
				image = "map/block01.png",
				position = pos
				})
			self.backSpr:addChild(pathSpr)
		end
	end
end

return BattleMainLayer


