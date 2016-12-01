map_01 = {
	desc = {
		time = "出现时间",
		enemyType = "敌人类型",
		enemyNum = "敌人数量",
		path = "行进路径",
	},
	path = {
		[1] = {
			x = {5, 6, 7, 8, 9, 10},
			y = {5, 5, 5, 5, 5, 5},
		},
	},
	mapPic = "map_01.png",
	items = {
		[1] = {
			time = 10,
			enemy = {
				[1] = {
					enemyType = 1,
					enemyNum = 10,
				}
			},
			path = 1,
		},
		[2] = {
			time = 30,
			enemy = {
				[1] = {
					enemyType = 1,
					enemyNum = 10,
				}
			},
			path = 1,
		},
		[3] = {
			time = 60,
			enemy = {
				[1] = {
					enemyType = 1,
					enemyNum = 10,
				}
			},
			path = 1,
		},
	}
}