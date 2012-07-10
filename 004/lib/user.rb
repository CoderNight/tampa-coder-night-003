class User
  def initialize user
    @user = user
    @orders = {}
  end

  def order order
    @orders[order] ||= Order.new(order, @user)
  end

  def order_sorted_connections degree
    order(degree).connections.sort
  end

  def output
    outputs = [@user]
    iterate_outputs do |output|
      outputs << output
    end
    outputs.join("\n")+"\n"
  end

  def iterate_outputs
    (1..6).each do |degree|
      connections = order_sorted_connections(degree)
      break if ! connections || connections.empty?
      yield connections.sort.join(", ")
    end
  end
end

