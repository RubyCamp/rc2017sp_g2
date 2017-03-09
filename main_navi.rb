require 'dxruby'
require_relative 'map'
require_relative 'map_to_root'
require_relative 'route_to_val'
require_relative 'communicator'
include DecideRoute
include ConvertRoute
include Communicator

#必要な変数の定義


#マップ解析、ルート決定(A)
#マップを受け取って配列に格納する
map = Map.new
#map.draw

#ルートを決定する
route = map.decide_route
#p route
#記号化する
ary = decideRoute(route)
#p ary
val = margeBIN(ary)
#p val.to_s(16)
#送信する(sample3を流用)
=begin
  threads = []
  sender = Communicator::Sender.new

  threads << Thread.start do
    message = val.to_s(16)
    puts "send: #{message}"
    sender.send(message)
  end

  threads.each{|t| t.join }
ensure
  sender.disconnect
=end
