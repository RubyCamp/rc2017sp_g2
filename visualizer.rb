
require_relative 'paper'

class Visualizer

 def initialize()
  @frameCount = 0

  @MAP_X = 400
  @MAP_Y = 100

  #������̃f�[�^�z��
  @papers = Array.new(60)

  for i in 0..60 do
   @papers[i] = Paper.new(rand(5..10) * 0.5,rand(0..3),rand(0..800),rand(20..60))
  end

  #�r�W���A���C�U�w�i
   @bg = Image.load("./images/visualizer.png")

  #�}�b�v�摜
   @wallImg = Image.load("./imgaes/wall.png")

  #�R���N�{�[�h�摜
   @boardImg = Image.load("./images/board.png")
  
  #������̃X�v���C�g
   @paperimages = Image.load_to_array("./images/papers.png",4,2)

  #�ړ���
   @sound0 = Sound.new("./sounds/sound0.wav")
 end
 
 def update()
   
  #�w�i�̕`��
  Window.draw(0,0,@bg)
 
  #�{�[�h�̕`��
  Window.draw(@MAP_X - 22,@MAP_Y - 22,@boardImg)
 
  #�}�b�v�̕`��
  for i in 0..3 do
   for j in 0..2 do
    Window.draw(@MAP_X + (i * 64),@MAP_Y + (j * 64),@wallImg)
   end
  end
 
  for i in 0..60 do
 
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
 
  #if Input.keyPush?(K_SPACE)
  #sound0.play 
  #end
 end
end