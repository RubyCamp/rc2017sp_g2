require 'dxruby'
require_relative 'ev3/ev3'

class Player
  LEFT_MOTOR = "B"
  RIGHT_MOTOR = "C"
  DISTANCE_SENSOR = "1"
  PORT = "COM10"  WHEEL_SPEED = 20

  attr_reader :distance

  def initialize
    @brick = EV3::Brick.new(EV3::Connections::Bluetooth.new(PORT))
    @brick.connect
    @busy = false
    @grabbing = false
#    set_array = ["10", "10", "00", "11", "00", "00", "00", "10", "00", "10", "00"]
    #@array = ["10", "10", "00", "00", "11", "00", "11", "00", "00", "10", "00", "10", "00", "00" "11", "00", "11", "00", "00"]

  end

  def set_array(ary)
    @array = ary
  end

  # 前進
  def run_forward(speed=WHEEL_SPEED)
    operate do
      @brick.step_velocity(speed, 290, 40, *wheel_motors)
      @brick.motor_ready(*wheel_motors)
    end
  end

  # 後進
  def run_backward(speed=WHEEL_SPEED)
    operate do
      @brick.reverse_polarity(*wheel_motors)
      @brick.step_velocity(speed, 260, 40, *wheel_motors)
      @brick.motor_ready(*wheel_motors)
    end
  end

  # 右
  def turn_right(speed=WHEEL_SPEED)
    operate do
      @brick.reverse_polarity(RIGHT_MOTOR)
      @brick.step_velocity(speed, 137, 60, *wheel_motors)
      @brick.motor_ready(*wheel_motors)
    end  
  end

  # 左
  def turn_left(speed=WHEEL_SPEED)
    operate do
      @brick.reverse_polarity(LEFT_MOTOR)
      @brick.step_velocity(speed, 137, 60, *wheel_motors)
      @brick.motor_ready(*wheel_motors)
    end
  end

  # ある動作中は別の動作を受け付けないようにする
  def operate
    unless @busy
      @busy = true
      yield(@brick)
      stop
      @busy = false
    end
  end

  def run
    update
    str = @array.shift
    if str
      case str
      when "00"
        run_forward
      when "01"
        run_backward
      when "10"
        turn_right
      else
        turn_left
      end
    end
  end

  # センサー情報の更新
  def update
    @distance = @brick.get_sensor(DISTANCE_SENSOR, 0)
	
  end

  # 動きを止める
  def stop
    @brick.stop(true, *all_motors)
    @brick.run_forward(*all_motors)
  end

  # 終了処理
  def close
    stop
    @brick.clear_all
    @brick.disconnect
  end

  def reset
    @brick.clear_all
    #motors = wheel_motors  if motors.empty?
    #@brick.reset(*motors)
  end

  # "～_MOTOR" という名前の定数すべての値を要素とする配列を返す
  def all_motors
    @all_motors ||= self.class.constants.grep(/_MOTOR\z/).map{|c| self.class.const_get(c) }
  end

  def wheel_motors
    [LEFT_MOTOR, RIGHT_MOTOR]
  end
end


   
=begin
array = ["10", "00", "00", "00", "10", "00", "00", "10", "00"]
player = Player.new
  print(array.size)
  print("\n")

for i in 0..(array.size-1) do
  # 信号の表示
  print("arry=",array[i],"\n")

  if array[i] == "00" then
    player.run_forward


  elsif array[i] == "01" then
    player.run_backward
      

  elsif array[i] == "10" then
    player.turn_right

  else
    player.turn_left

  end

  i = i + 1

end
=end