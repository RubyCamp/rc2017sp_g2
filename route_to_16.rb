########
# ルート情報を16進数の数値に変換する
# 2017-03-08 (Wed) Kazuki Hiramoto
#
########


module ConvertRoute
	private

	# 2桁の二進数が格納された配列をつなげて一つの値とする
	def margeBIN(strRoute)
		hex = 0
		bin = 0

		for x in convTo2(strRoute)
			bin += x
			p sprintf("%08b", bin)
			bin << 2
		end

		return hex
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
include ConvertRoute

str = ["00", "01", "10", "11"]

p margeBin(str)
