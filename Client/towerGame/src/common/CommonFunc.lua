--[[
	文件名：CommonFunc.lua
	描述：公共方法
	创建人：dingxuejia
	创建时间：2016.12.7
--]]
GameFunc = {}

--通过格子位子计算屏幕位置
function getPosbyBlock(x, y)
	local posy = StartPosBottomY + y * BlockWidth
	local posx = StartPosLeftX + x * BlockWidth

	return cc.p(posx, posy)
end

function dump(value, desciption)
	--print(desciption or "开始打印")
	for k,v in pairs(value) do
		if type(v) == "table" then
			dump(v)
		else
			print(k,v)
		end
	end
end

--[[
	table params
	enemyType: 敌人类型
]]
function GameFunc.newEnemy(params)
	local enemyType = params.enemyType
	local pic = EnemyTypeConfig.items[enemyType].pic

	local node = cc.Node:create()
	node:setAnchorPoint(cc.p(0.5, 0.5))

	--精灵
	local enemySpr = ui.newSprite({
		iamge = "enemy/" .. pic,
		})
	enemySpr:setAnchorPoint(cc.p(0,0))

	node:setContentSize(enemySpr:getContentSize())
	node:addChild(enemySpr)

	return node
end