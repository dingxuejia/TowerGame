
TowerTypeConfig = {
	desc = {
		name = "名称",
		pic = "图片",
		landType = "landType 参照Enmus.TowerLandType",
		attack = "攻击力",
		attackBuff = "攻击特效",
		attackDistence = "攻击距离",
		attackSpeed = "攻击速度",
		lvTo = "升级后变为, nil代表不能升级"
	},
	items = {
		[1] = {
			name = "箭塔",
			pic = "tower_01.png",
			landType = 1,
			attack = 50,
			attackBuff = nil,
			attackDistence = 3,
			attackSpeed = 1,
			lvTo = 2,
		},
		[2] = {
			name = "中级箭塔",
			pic = "tower_02.png",
			landType = 1,
			attack = 70,
			attackBuff = nil,
			attackDistence = 4,
			attackSpeed = 1.5,
			lvTo = nil,
		}
	}
}