require_relative 'dijkstra_search'

class Map

  # @map_data の各要素の意味
  FLOOR = 0
  WALL = 1
  START = 2
  GOAL = 3
  POINT = 4


  def initialize
    @map_data = []
    File.open(File.join(File.dirname(__FILE__),"images","map.dat")).each do |line|
      result = line.chomp.split(/,\s*/).map(&:to_i)
      @map_data << result
      @map_x_size = result.size unless @map_x_size
    end
    @map_y_size = @map_data.size

  end

  #表示させる
  def draw
    #p @map_data
  end

  def calc_route(start, goal)
    g = Graph.new(make_data)
    start_id = "m#{start[0]}_#{start[1]}"
    goal_id = "m#{self.goal[0]}_#{self.goal[1]}"

    @map_data[self.goal[1]][self.goal[0]] = GOAL
    #p @map_data
    g.get_route(start_id, goal_id)
  end


  def calc_point_route(start, point)
    @map_data[self.goal[1]][self.goal[0]] = WALL
    g = Graph.new(make_data)
    start_id = "m#{start[0]}_#{start[1]}"
    point_id = "m#{self.point[0]}_#{self.point[1]}"
    #p @map_data
    g.get_route(start_id, point_id)
  end

  # 任意の座標x, y におけるマップチップの種類を取得
  def [](x, y)
    return @map_data[y][x].to_i
  end

  def movable?(x, y)
    return self[x,y] != WALL
  end


  # 経路探索用のグラフの元データを作成
  def make_data
    data = {}
    @map_y_size.times do |y|
      @map_x_size.times do |x|
        nid_and_costs = []
        [[x, y - 1], [x, y + 1], [x - 1, y], [x + 1, y]].each do |dest_x, dest_y|
          if dest_x < 0 || dest_x > @map_x_size - 1 ||
             dest_y < 0 || dest_y > @map_y_size - 1 ||
             !movable?(x, y)
            next
          end
          case @map_data[dest_y][dest_x]
          when FLOOR
            nid_and_costs << ["m#{dest_x}_#{dest_y}", 1]
          when WALL
            # 壁は通れないのでエッジを追加しない
            nid_and_costs
          else
            nid_and_costs << ["m#{dest_x}_#{dest_y}", 1]
          end
        end
        data["m#{x}_#{y}"] = nid_and_costs
      end
    end
    return data
  end


  # ポイント地点の座標
  def point
    return @point if @point
    point_y = @map_data.index{|map_x| map_x.include?(POINT) }
    point_x = @map_data[point_y].index(POINT)
    @point = [point_x, point_y]
    return @point 
  end


  # ゴール地点の座標
  def goal
    return @goal if @goal
    goal_y = @map_data.index{|map_x| map_x.include?(GOAL) }
    goal_x = @map_data[goal_y].index(GOAL)
    @goal = [goal_x, goal_y]
    return @goal 
  end



  def decide_route
    current=[0,0]
    route=[]
    route = self.calc_point_route(current, @point)
	 item_distance = route.size
    route += self.calc_route(@point, @goal)
    #p route
    route.size.times do |line|
      route.swap!(line, 0, line, 1 )	
    end
	 route.shift
    route << [-2, -2]
	 route << item_distance
    #p route
    return route

  end
end


# 配列のswap
class Array
  def swap!(a, b, c, d)
    raise ArgumentError unless a.between?(0, self.count-1) && b.between?(0, self.count-1)

    self[a][b], self[c][d] = self[c][d], self[a][b]

    self
  end

  def swap(a, b, c, d)
    self.dup.swap!(a, b, c, d)
  end
end