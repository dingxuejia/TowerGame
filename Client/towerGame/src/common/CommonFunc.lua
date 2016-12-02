
--通过格子位子计算屏幕位置
function getPosbyBlock(x, y)
	local posy = StartPosBottomY + y * BlockWidth
	local posx = StartPosLeftX + x * BlockWidth

	return posx, posy
end