
class Paper
 
 def initialize(sp=1.0,c=0,xp = 0,rfs = 30)
  @speed = sp
  @color = c
  @x = xp
  @y = 0
  @rotationFrameSpeed = rfs
  @frameCount = 0
  @num = 0
 end
 
 def getX()
  @x
 end
 
 def getY()
  @y
 end
 
 def getColor()
  @color
 end
 def getNum()
  @num
 end

 def update()
  if (@frameCount / @rotationFrameSpeed) % 2 == 0
   @num = 0
  else
   @num = 1
  end
  
  @y += @speed
  @frameCount += 1
 end

end