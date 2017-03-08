require 'dxruby'
require_relative 'map'
require_relative 'map_to_root'
require_relative 'route_to_val'
include DecideRoute
include ConvertRoute

#必要な変数の定義


#マップ解析、ルート決定(A)
#マップを受け取って配列に格納する
map = Map.new
#map.draw

#ルートを決定する
route = map.decide_route

#記号化する
a = margeBIN(decideRoute(route))
p sprintf("%08x", a)
#送信する(sample3を流用)


#3/8までにここまで


#復号する(記号化の逆)


#実行する(B)


