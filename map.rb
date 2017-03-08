
class Map

  def initialize
    @map_data = []
    File.open('./map.dat').each do |line|
      result = line.chomp.split(/,\s*/).map(&:to_i)
      @map_data << result
    end
  end

  #表示させる
  def draw
    p @map_data
  end
  
  def search
  end
  
end
