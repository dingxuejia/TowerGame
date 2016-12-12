local map_01 = {
	desc = {
		time = "出现时间",
		enemyType = "敌人类型",
		enemyNum = "敌人数量",
		enemypath = "行进路径",
	},
	path = {
		[1] = {
			x = {1, 2, 3, 4, 5, 6, 6, 7},
			y = {5, 5, 5, 5, 5, 5, 6, 6},
		},
	},
	mapPic = "map/map_01.jpg",
	enemys = {
		[1] = {
			time = 3,
			enemy = {
				[1] = {
					enemyType = 1,
					enemyNum = 10,
					enemypath = 1,
				}
			},
		},
		[2] = {
			time = 15,
			enemy = {
				[1] = {
					enemyType = 1,
					enemyNum = 10,
					enemypath = 1,
				}
			},
		},
		[3] = {
			time = 25,
			enemy = {
				[1] = {
					enemyType = 1,
					enemyNum = 10,
					enemypath = 1,
				}
			},
		},
	}
}

return map_01