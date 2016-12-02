local BattleData = {}

function BattleData:init(level, difficult)
	self.level = level
	self.difficult = difficult

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

return BattleData

