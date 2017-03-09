
require_relative 'paper'

class Visualizer

 def initialize()
  @frameCount = 0

  @MAP_X = 400
  @MAP_Y = 100
  
  #紙吹雪のデータ配列
  @papers = Array.new(100)
  
  #Playerの位置、角度
  @pXPos = 0
  @pYPos = 0
  @pAngle = 1

  @additionalXPos = nil
  @additionalYPos = nil
  
  @goalEffectSize = 0
  @goalEffectTime = 50
  
  #マップデータ
  @mapDatas = [[0,0,0,0],[0,0,0,0],[0,0,0,0]]
  
  for i in 0..100 do
   @papers[i] = Paper.new(rand(5..10) * 0.5,rand(0..3),rand(0..800),rand(20..60))
  end

  #ビジュアライザ背景
  @bg = Image.load("./images/visualizer.png")
  
  #通路画像
  @roadImg = Image.load("./images/road.png")
  #通路画像
  @startImg = Image.load("./images/start.png")
  #通路画像
  @goalImg = Image.load("./images/goal.png")
  #通路画像
  @additionImg = Image.load("./images/additional.png")
  
  #ゴール文字画像
  @goalEffectImg = Image.load("./images/goaleffect.png")

  #マップ画像
  @wallImg = Image.load("./images/wall.png")

  #現在地を示す矢印画像
  @arrowImg = Image.load("./images/arrow.png")

  #コルクボード画像
  @boardImg = Image.load("./images/board.png")
  
  #紙吹雪のスプライト
  @paperimages = Image.load_to_array("./images/papers.png",4,2)

  #移動音
  @sound0 = Sound.new("./sounds/sound0.wav")
 end
 
 def update(binVal=0,currentStep=0,goalStep=0,additionStep=0)
  
  if currentStep == additionStep
   @additionalXPos = @pXPos
   @additionalYPos = @pYPos
  end
  if(@pXPos == 0 && @pYPos == 0)
   @mapDatas[@pYPos][@pXPos] = 2
  elsif(currentStep == goalStep)
   @mapDatas[@pYPos][@pXPos] = 3
  else
   @mapDatas[@pYPos][@pXPos] = 1
  end

  #背景の描画
  Window.draw(0,0,@bg)
 
  #ボードの描画
  Window.draw(@MAP_X - 22,@MAP_Y - 22,@boardImg)
 
  #マップの描画
  for i in 0..3 do
   for j in 0..2 do
    #Window.draw(@MAP_X + (i * 64),@MAP_Y + (j * 64),@wallImg)
    case @mapDatas[j][i]
     when 0 then
      Window.draw(@MAP_X + (i * 64),@MAP_Y + (j * 64),@wallImg)
     when 1 then
      Window.draw(@MAP_X + (i * 64),@MAP_Y + (j * 64),@roadImg)
     when 2 then
      Window.draw(@MAP_X + (i * 64),@MAP_Y + (j * 64),@startImg)
     when 3 then
      Window.draw(@MAP_X + (i * 64),@MAP_Y + (j * 64),@goalImg)
     when 4 then
      Window.draw(@MAP_X + (i * 64),@MAP_Y + (j * 64),@additionImg)
     end
     
     if(i == @additionalXPos && j == @additionalYPos)
      Window.draw(@MAP_X + (i * 64),@MAP_Y + (j * 64),@additionImg)
     end
   end
  end
  
  #紙吹雪の描画
  if binVal == nil
	  for i in 0..100 do
	 
	   case @papers[i].getColor()
	   when 0 then
	    Window.draw(@papers[i].getX(),@papers[i].getY(),@paperimages[0 + (@papers[i].getNum() * 4)])
	   when 1 then
	    Window.draw(@papers[i].getX(),@papers[i].getY(),@paperimages[1 + (@papers[i].getNum() * 4)])
	   when 2 then
	    Window.draw(@papers[i].getX(),@papers[i].getY(),@paperimages[2 + (@papers[i].getNum() * 4)])
	   else
	    Window.draw(@papers[i].getX(),@papers[i].getY(),@paperimages[3 + (@papers[i].getNum() * 4)])
	   end
	 
	   @papers[i].update()

	  end
     
     @goalEffectSize += 0.05
     if(@goalEffectSize > 1)
      @goalEffectSize = 1
      @goalEffectTime -= 1
     end
  end
  
  #矢印の更新、描画
=begin
  case binVal
   when "00"
    puts "when:00"
   when "01"
    puts "when:01"
   when "10"
    @pAngle += 1
    puts "when:right"
   when "11"
    @pAngle -= 1
    puts "when:left"
   else
  end
=end
  
  if binVal == "00" #前 
		if @pAngle == 0 #上
			@pYPos -= 1
		elsif @pAngle == 1 #右
			@pXPos += 1
		elsif @pAngle == 2 #下
			@pYPos += 1
		elsif @pAngle == 3 #左
			@pXPos -= 1
		end
  elsif binVal == "01" # 後
	
  elsif binVal == "10" # 右
   puts "bin:10"
   @pAngle += 1
  elsif binVal == "11" # 左
   puts "bin:11"
   @pAngle -= 1
  end

  if(@pAngle > 3)
   @pAngle = 0
   puts "over"
  end
  
  if(@pAngle < 0)
   @pAngle = 3
   puts "under"
  end
  
  puts @pAngle if(binVal != nil)
  
  Window.draw_rot((@pXPos * 64) + @MAP_X,(@pYPos * 64) + @MAP_Y,@arrowImg,@pAngle * 90)
  

  #ゴール画像の描画
  Window.drawScale(0,0,@goalEffectImg, @goalEffectSize, @goalEffectSize, 400, 300,0) if @goalEffectTime > 0

  #if Input.keyPush?(K_SPACE)
  #sound0.play 
  #end
 end
end