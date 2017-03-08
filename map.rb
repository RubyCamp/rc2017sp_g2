class Map

  def initialize
    @map_data = []
    File.open(File.join(File.dirname(__FILE__),"images","map.dat")).each do |line|
      result = line.chomp.split(/,\s*/).map(&:to_i)
      @map_data << result
    end
  end

  #表示させる
  def draw
    p @map_data
  end
  
  def calc_route(start, goal)
    g = Graph.new(make_data)
    start_id = "m#{start[0]}_#{start[1]}"
    goal_id = "m#{goal[0]}_#{goal[1]}"
    g.get_route(start_id, goal_id)
  end


  def decide_route(goal)
    route[]

    loop do
      route = calc_route(start,goal)
      start=new_start
     　root << route
      break if route.length == 0  
  　　end
    
　　end
