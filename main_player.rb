require 'dxruby'
require_relative 'map'
require_relative 'map_to_root'
require_relative 'route_to_val'
require_relative 'communicator'
require_relative 'player_signal'

include DecideRoute
include ConvertRoute
include Communicator

#復号する(記号化の逆)
#message = ""
begin
  threads = []
  receiver = Communicator::Receiver.new

  threads << Thread.start do
    signals = receiver.receive
    @message = receiver.get_message(signals)
    puts "receive: #{@message}"
  end

  threads.each{|t| t.join }
ensure
  receiver.disconnect
end

sleep 5.0
#message = ["10", "10", "00", "11", "00", "00", "00", "10", "00", "10", "00"]
#p message
bin = separateBIN(@message.to_i(16))


#実行する(B)
begin
  puts "starting..."
  font = Font.new(32)
  player = Player.new
  puts "connected"

  Window.loop do
    break if Input.keyDown?(K_SPACE)
    player.set_array(bin[0])
    player.run
    Window.draw_font(100, 200, "#{player.distance.to_i}cm", font)
  end
rescue Exception => e
  p e
  e.backtrace.each{|trace| puts trace}
# 終了処理は必ず実行する
ensure
  puts "closing..."
  player.close
  puts "finished"
end
