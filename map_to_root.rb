#########
# ルートを2bit表現に置き換える(string)
# 2017-03-08 (Wed) Kazuki Hiramoto
#
##########
require_relative 'map'
require 'dxruby'


module DecideRoute

	# ルートを2bit表現に置き換える(string)
	# 引数1: ダイクストラサーチによって得られた座標の繊維を表した配列
	# 戻り値: 文字列配列
	def decideRoute(r_next)
	 	item_distance = r_next.dup.pop
		tmp_next = decideNext(r_next.dup)
		tmp_current = decideCurrent(tmp_next)
		tmp_dir = decideDirection(tmp_next, tmp_current)

		route = []
		i = 0
		j = 0

		for x in tmp_next
			y = tmp_current[i]
			z = tmp_dir[i]

			if x[0] == y[0]
				if x[1] == y[1] + 1 # 現在の座標から見て右方向に行きたい
					if z == "00" # 現在上を向いている
						route.push("10")
						route.push("00")
						j += 2
					elsif z == "01" # 現在下を向いている
						route.push("11")
						route.push("00")
       				j += 2
					elsif z == "10" # 現在右を向いている
						route.push("00")
       				j += 1
					elsif z == "11" # 現在左を向いている
						route.push("10")
						route.push("10")
						route.push("00")
       				j += 3
					end
				elsif x[1] == y[1] - 1 # 現在の座標から見て左方向に行きたい
					if z == "00" # 現在上を向いている
						route.push("11")
						route.push("00")
       				j += 2
					elsif z == "01" # 現在下を向いている
						route.push("10")
						route.push("00")
       				j += 2
					elsif z == "10" # 現在右を向いている
						route.push("10")
						route.push("10")
						route.push("00")
       				j += 3
					elsif z == "11" # 現在左を向いている
						route.push("00")
       				j += 1
					end
				end
			elsif x[0] == y[0] + 1 # 現在の座標から見て下方向に行きたい
				if z == "00" # 現在上を向いている
					route.push("10")
					route.push("10")
					route.push("00")
       			j += 3
				elsif z == "01" # 現在下を向いている
					route.push("00")
       			j += 1
				elsif z == "10" # 現在右を向いている
					route.push("10")
					route.push("00")
       			j += 2
				elsif z == "11" # 現在左を向いている
					route.push("11")
					route.push("00")
       			j += 2
				end
			elsif x[0] == y[0] - 1 # 現在の座標から見て上方向に行きたい
				if z == "00" # 現在上を向いている
					route.push("00")
       			j += 2
				elsif z == "01" # 現在下を向いている
					route.push("10")
					route.push("10")
					route.push("00")
       			j += 3
				elsif z == "10" # 現在右を向いている
					route.push("11")
					route.push("00")
       			j += 2
				elsif z == "11" # 現在左を向いている
					route.push("10")
					route.push("00")
       			j += 2
				end
				
			end
				i += 1
			#	p "i = #{i}"
			#	p "j = #{j}" 
				moved_to_item = j if i == item_distance - 1
		end

		route << moved_to_item

		return route
	end
	def decideDirection(r_next, r_current)
		dir = ["00"]
		i = 0

		for x in r_next
			y = r_current[i]

			if x[0] == y[0]
				if x[1] == y[1] + 1 
					dir.push("10") # 右
				elsif x[1] == y[1] - 1 
					dir.push("11") # 左
				end
			elsif x[0] == y[0] + 1
				dir.push("01") # 下
			elsif x[0] == y[0] - 1
				dir.push("00") # 上
			end

			i += 1
		end

		return dir
	end
	def decideNext(r_next)
		return r_next
	end

	def decideCurrent(r_current)
		result = r_current.dup.unshift([0, 0]) #dup: デュプリケート(変数をコピーして別のメモリに退避させることができる)
		result.pop

		return result
	end

end

##### テストコード #####
# include DecideRoute
# test = [[0, 1], [0, 2], [0, 3], [1, 3], [2, 3], [2, 2], [-2, -2]] # ダイクストラサーチで得られるであろう値

# test_next = decideNext(test)
# test_current = decideCurrent(test_next)
# direction = decideDirection(test_next, test_current)

# route = decideRoute(test_next, test_current, direction)

# p test_next
# p test_current
# p direction
# p route





