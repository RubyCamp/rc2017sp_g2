require_relative 'ev3/ev3'

module Communicator
  MAPPING = {
    "0" => [1,1],
    "1" => [1,2],
    "2" => [2,1],
    "3" => [2,2],
    "4" => [1,1,1],
    "5" => [1,1,2],
    "6" => [1,2,1],
    "7" => [1,2,2],
    "8" => [2,1,1],
    "9" => [2,1,2],
    "a" => [2,2,1],
    "b" => [2,2,2],
    "c" => [1,1,1,1],
    "d" => [1,1,1,2],
    "e" => [1,1,2,1],
    "f" => [1,1,2,2]
=begin
    "0" => [1],
    "1" => [2],
    "2" => [1,1],
    "3" => [1,2],
    "4" => [2,1],
    "5" => [2,2],
    "6" => [1,1,1],
    "7" => [1,1,2],
    "8" => [1,2,1],
    "9" => [2,1,1],
    "a" => [2,2,2],
    "b" => [1,2,2],
    "c" => [2,1,2],
    "d" => [2,2,1],
    "e" => [1,1,1,1],
    "f" => [1,2,1,1]
=end
  }
  MAPPING_INV = MAPPING.invert
  UNIT = 1.5 # 通信の単位時間

  class Sender
    DISTANCE_SENSOR = "1"
    PORT = "COM12"

    def initialize
      @brick = EV3::Brick.new(EV3::Connections::Bluetooth.new(PORT))
      @brick.connect
    end

    def send(message)
      @brick.get_sensor(DISTANCE_SENSOR, 2)
      sleep UNIT * 2
      chars = message.chars
      signals = chars.map{|char| MAPPING[char] }
      signals.each.with_index do |signal, i|
        # デバッグ用
        puts "sending: char=#{chars[i]}, signal=#{signal.inspect}"
        signal.each do |interval|
          # デバッグ用
          puts "\tsending: #{interval}"
          @brick.get_sensor(DISTANCE_SENSOR, 0)
          sleep UNIT * interval
          @brick.get_sensor(DISTANCE_SENSOR, 2)
          sleep UNIT
        end
        sleep UNIT * 3
      end
    end

    def disconnect
      @brick.clear_all
      @brick.disconnect
    end
  end

  class Receiver
    DISTANCE_SENSOR = "1"
    PORT = "COM8"
    LIMIT = UNIT * 8

    def initialize
      @brick = EV3::Brick.new(EV3::Connections::Bluetooth.new(PORT))
      @brick.connect
    end

    def get_message(signals)
      # ノイズ除去後の正味の信号
      net_signal_pairs = []
      # ノイズ除去その1
      # 0.0, 1.0 以外の値はノイズなので除外する
      signals.select!{|_, v| [0.0, 1.0].include?(v) }
      # ノイズ除去その2
      # 先頭が1.0以外の場合はノイズなので除外する
      signals.shift until signals[0][1] == 1.0
      pair_a = nil
      # ノイズ除去その3
      signals.each do |signal|
        # 0.0 が連続している場合はノイズなので除外する
        unless pair_a
          if signal[1] == 1.0
            pair_a = signal
          end
          next
        end
        # 1.0から0.0に切り替わるまでの時間が単位時間の3割未満の場合、
        # ノイズと判断して除外する
        if signal[0] - pair_a[0] < UNIT * 0.3
          pair_a = nil
          next
        end
        net_signal_pairs << [pair_a, signal]
        pair_a = nil
      end
      signal_pairs_per_char = [] # 文字単位で振り分けた信号
      signal_pairs = []          # 文字1つ分の信号を一時的に格納する変数
      net_signal_pairs.each.with_index do |signal_pair, i|
        if signal_pairs.empty?
          signal_pairs << signal_pair
          next
        end
        # 信号のペア間の間隔が単位時間の2倍以上であれば、文字の境目とみなす
        if signal_pair[0][0] - signal_pairs.last[1][0] < UNIT * 2.0
          signal_pairs << signal_pair
          if i == net_signal_pairs.size - 1
            signal_pairs_per_char << signal_pairs
          end
        else
          signal_pairs_per_char << signal_pairs
          signal_pairs = [signal_pair]
        end
      end

      # デバッグ用
      require 'pp'
      pp signal_pairs_per_char

      # 信号を文字にデコードする
      chars = signal_pairs_per_char.map{|signal_pairs|
        signals = signal_pairs.map{|s1, s2|
          (s2[0] - s1[0] < UNIT * 1.3) ? 1 : 2
        }
        # デバッグ用
        p signals
        MAPPING_INV[signals]
      }
      # 文字を連結して単語にする
      word = chars.join
      return word
    end

    def receive
      signals = []
      prev_time = Time.now
      prev_value = @brick.get_sensor(DISTANCE_SENSOR, 2)
      loop do
        value = @brick.get_sensor(DISTANCE_SENSOR, 2)
        now = Time.now
        # 値が変化したときに、そのときの時間とセンサーの値を記録する
        if now - prev_time > LIMIT
          break
        elsif value != prev_value
          prev_time = now
          prev_value = value
          # デバッグ用
          puts "\tnow: #{now}, value:#{value}"
          signals << [now, value]
        end
        sleep 0.1
      end
      return signals
    end

    def disconnect
      @brick.clear_all
      @brick.disconnect
    end
  end
end



