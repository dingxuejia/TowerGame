--[[
	文件名：EnemyNode.lua
	描述：敌人对象，单独成类便于管理
	创建人：dingxuejia
	创建时间：2016.12.7s
--]]
local EnemyNode = class("EnemyNode", function (  )
	return cc.Node:create()
end)

local EnemyTypeConfig = EnemyTypeConfig

--[[
	table params:
	enemyType:  敌人类型
]]
function EnemyNode:ctor(params)
	self.enemyType = params.enemyType

	self:init()
end

--初始化
function EnemyNode:init()
	self:setContentSize(cc.size(100, 100))
	self:setAnchorPoint(cc.p(0.5, 0.5))

	--添加怪物形象
	local pic = EnemyTypeConfig.items[self.enemyType].pic
	self.enemySpr = ui.newSprite({
		image = "enemy/enemy_01.png", --.. pic,
		anchorPoint = cc.p(0.5, 0),
		})
	self.enemySpr:setPosition(cc.p(50, 0))
	self:addChild(self.enemySpr)

	--添加血条
end

--移动
function EnemyNode:startMove()
	self:onUpdate(function()
		if not self.path then
			self:unscheduleUpdate()
			return
		end


	end)
end

--死亡
function EnemyNode:dead()

end

--被攻击
function EnemyNode:beAttacked()

end

--设置自己的行进路径
function EnemyNode:setPath(path)
	self.path = path
end

return EnemyNode