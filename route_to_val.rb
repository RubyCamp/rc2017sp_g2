########
# ルート情報を1つの数値オブジェクトに変換する
# 2017-03-08 (Wed) Kazuki Hiramoto
#
########

module ConvertRoute
	private

	# 数値から2桁の2進数の配列へと変換
	# 戻り値: Stringオブジェクトの配列
	def separateBIN(bin)
		item_distance = bin % 16
		bin /= 16
		str = []
		i = 0

		while bin != 0
			str[i] = bin % 4
			bin /= 4
			i += 1
		end
p str
p item_distance
		rstr = str.reverse

		binstr = []
		i = 0
		for x in rstr
			binstr[i] = x.to_s(2)
			binstr[i] = "00" if binstr[i] == "0"
			binstr[i] = "01" if binstr[i] == "1"
			i += 1
		end

		return [binstr, item_distance]
	end

	# 2桁の二進数が格納された配列をつなげて一つの値とする
	# 戻り値: 整数型の値
	def margeBIN(strRoute)
		item_distance = strRoute.pop
		bin = 0

		for x in convTo2(strRoute)
			bin += x
		#	p sprintf("%08b", bin)
			bin *= 4
		end
		bin *= 4
		bin += item_distance
p bin.to_s(16)

		return bin
	end

	# 文字列の配列で渡されたルート情報を数値に変換する
	def convTo2(strNum)
		binary = []
		for obj in strNum
			binary.push(obj.to_i(2))
			# p obj.to_i(2)
		end

		return binary
	end
end


#### 以下テスト用コード ####
# include ConvertRoute

# bin = 202

# p separateBIN(bin)
# for x in separateBIN(bin)
# 	p sprintf("%04b", x)
# end
