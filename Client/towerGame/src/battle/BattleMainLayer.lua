--[[
	文件名：BattleMainLayer.lua
	描述：游戏主页面
	创建人：dingxuejia
	创建时间：2016.12.7
--]]
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

	self.totalTime = 0 --游戏时间

	--私有的战斗数据处理类
	self.BattleDataClass = BattleData.new(self.level, self.difficult)
	--cc.Director:getInstance():getScheduler():setTimeScale(14)

	self.enemyData = self.BattleDataClass:getMapEnemy()  --全部敌人
	self.enemyPath = self.BattleDataClass:getMapPath()	--路径信息

	self:initUis()
end

function BattleMainLayer:initUis()
	--添加背景
	self.backSpr = ui.newSprite({
		image = self.BattleDataClass:getMapPic(),
		position = cc.p(display.cx, display.cy)
		})
	self:addChild(self.backSpr)

	self:createPath()
	self:scheduleStart()
end

--绘制敌人行走路线
function BattleMainLayer:createPath()
	for _,path in pairs(self.enemyPath) do
		for i,x in pairs(path.x) do
			print(i,x)
			local y = path.y[i]
			local pos = getPosbyBlock(x, y)

			--创建小方格
			local pathSpr =  ui.newSprite({
				image = "map/block01.png",
				position = pos
				})
			self.backSpr:addChild(pathSpr)
		end
	end
end

--开始计时
function BattleMainLayer:scheduleStart()
	--主要计时器，用于计算出怪时间,关卡整体时间等
	self.mainScheID = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()
		self.totalTime = self.totalTime + 1

		--检测是否出怪
		if self.BattleDataClass:haveNewEnemy(self.totalTime) then
			self:addNewEnemy()
		end
    end, 1, false)
end

--添加新的敌人
function BattleMainLayer:addNewEnemy()
	--向数据中添加
	local addEnemy = self.BattleDataClass:addNewEnemy()

	print(string.format("\n第%d波敌人",self.BattleDataClass:getNowBath()))

	--表现中添加
	--用计时器每隔一段时间添加一个
	local haveAddNum = 0  --已经添加的个数
	local addEnemySche
	addEnemySche = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()
		haveAddNum = haveAddNum + 1

		local enemyNode = require("common.EnemyNode").new({enemyType = addEnemy[haveAddNum].etype})
		local nodepos = getPosbyBlock(addEnemy[haveAddNum].pos.x, addEnemy[haveAddNum].pos.y)
		print(haveAddNum)
		enemyNode:setPosition(nodepos)
		self.backSpr:addChild(enemyNode)

		enemyNode:setPath(self.enemyPath[addEnemy[haveAddNum].epath])

		--数据和表现绑定
		addEnemy[haveAddNum].cnode = enemyNode

		dump(self.BattleDataClass.nowLiveEnemy[haveAddNum])

		--添加完成
		if #addEnemy == haveAddNum then
			cc.Director:getInstance():getScheduler():unscheduleScriptEntry(addEnemySche)
			addEnemySche = nil
		end
    end, 1, false)
end

return BattleMainLayer


