########
# ルート情報を1つの数値オブジェクトに変換する
# 2017-03-08 (Wed) Kazuki Hiramoto
#
########


module ConvertRoute
	private

	# 2桁の二進数が格納された配列をつなげて一つの値とする
	def margeBIN(strRoute)
		bin = 0

		for x in convTo2(strRoute)
			bin += x
			p sprintf("%08b", bin)
			bin *= 4
		end
		bin /= 4

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

# str = ["10", "01", "00", "11", "10", "11"]

# p sprintf("%04x", margeBIN(str))
