require 'dxruby'
require_relative 'map'
require_relative 'map_to_root'
require_relative 'route_to_val'
require_relative 'communicator'
include DecideRoute
include ConvertRoute
include Communicator

#復号する(記号化の逆)
begin
  threads = []
  receiver = Communicator::Receiver.new

  threads << Thread.start do
    signals = receiver.receive
    message = receiver.get_message(signals)
    puts "receive: #{message}"
  end

  threads.each{|t| t.join }
ensure
  receiver.disconnect
end

#実行する(B)

