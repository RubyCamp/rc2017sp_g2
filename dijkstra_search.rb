class Node
  attr_accessor :id, :edges, :cost, :done, :from
  def initialize(id, edges=[])
    @id = id
    @edges = edges
    @cost = nil
    @done = false
  end
end

class Edge
  attr_reader :node_id, :cost
  def initialize(node_id, cost)
    @node_id = node_id
    @cost = cost
  end
end

class Graph
  # 引数の data は、下記の形式のハッシュを想定
  #
  # {
  #   <ノード1のID> => <ノード1に繋がっているエッジの配列>,
  #   <ノード2のID> => <ノード2に繋がっているエッジの配列>,
  #   ...
  # }
  #
  # <ノードのID> は 一意の文字列
  #
  # <エッジ> は [<ノードのID>, <エッジのコスト>] の形式の配列
  # <エッジのコスト> は 1以上の整数値
  def initialize(data)
    @nodes =
      data.map do |id, edges|
        edges.map! { |edge| Edge.new(*edge) }
        Node.new(id, edges)
      end
  end

  def get_route(start_id, goal_id)
    route(start_id, goal_id)
    @res.reverse.map { |node|
      node.id =~ /\Am(\d+)_(\d+)\z/
      [$1.to_i, $2.to_i]
    }
  end

  private
  def cost(node_id, start_id)
    dijkstra(start_id)
    @nodes.find { |node| node.id == node_id }.cost
  end

  def dijkstra(sid)
    @nodes.each do |node|
      node.cost = node.id == sid ? 0 : nil
      node.done = false
      node.from = nil
    end
    loop do
      done_node = nil
      @nodes.each do |node|
        next if node.done || node.cost.nil?
        done_node = node if done_node.nil? || node.cost < done_node.cost
      end
      break unless done_node
      done_node.edges.each do |edge|
        to = @nodes.find{|node| node.id == edge.node_id }
        cost = done_node.cost + edge.cost
        from = done_node.id
        if to.cost.nil? || cost < to.cost
          to.cost = cost
          to.from = from
        end
      end
      done_node.done = true
    end
  end

  def route(sid, gid)
    dijkstra(sid)
    base = @nodes.find { |node| node.id == gid }
    @res = [base]
    while base = @nodes.find { |node| node.id == base.from }
      @res << base
    end
    @res
  end
end
