--[[
	文件名：BattleData.lua
	描述：战斗数据处理类
	创建人：dingxuejia
	创建时间：2016.12.7
--]]
local BattleData = class("BattleData")

local EnemyTypeConfig = EnemyTypeConfig

function BattleData:ctor(level, difficult)
	self.level = level
	self.difficult = difficult

	self.nowLiveEnemy = {}  --当前存活敌人
	self.nowTower = {}		--当前修建的防御塔
	self.nowEnemyBath = 0   --当前第几波敌人

	local mapLuaName = string.format("map_%.2d", self.level)
	local mapData = require(string.format("config/%s", mapLuaName))
	self.mapData = clone(mapData)
end

-- 获得所有敌人信息
function BattleData:getMapEnemy()
	return self.mapData.enemys
end

-- 获得地图路径信息
function BattleData:getMapPath()
	return self.mapData.path
end

-- 获得地图图片
function BattleData:getMapPic()
	return self.mapData.mapPic
end

-- 返回当前是第几波敌人
function BattleData:getNowBath()
	return self.nowEnemyBath
end

--添加新的敌人
function BattleData:addNewEnemy()
	self.nowEnemyBath = self.nowEnemyBath + 1
	local returnData = {}  --返回给表现层用
	local nowBathData = self.mapData.enemys[self.nowEnemyBath]

	for _,v in ipairs(nowBathData.enemy) do
		for i=1,v.enemyNum do
			--初始位置
			local initX = self.mapData.path[v.enemypath].x[1]
			local initY = self.mapData.path[v.enemypath].y[1]
			local tempData = {
				etype = v.enemyType,
				epath = v.enemypath,
				pos = {x = initX, y = initY},
				HP = EnemyTypeConfig.items[v.enemyType].HP
			}

			table.insert(self.nowLiveEnemy, tempData)
			table.insert(returnData, tempData)
		end
	end

	return returnData
end

--添加新的防御塔
function BattleData:addNewTower(params)
	-- body
end

--检测是否有新的一波敌人
function BattleData:haveNewEnemy(time)
	for i = self.nowEnemyBath + 1, #self.mapData.enemys do
		if self.mapData.enemys[i].time == time then
			return true
		end
	end

	return false
end

return BattleData

