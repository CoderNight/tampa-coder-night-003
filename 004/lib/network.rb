class Network
  attr_reader :users

  def initialize
    @users = {}
  end

  def connect order, user, mention
    @users[user] ||= User.new(user)
    @users[user].order(order).connect(mention)
  end

  def for user
    @users[user]
  end

  def build
    @users.keys.each do |user|
      results = []
      build_recurse(1, user, user, [user]) do |result|
        results << result
      end
      connect_ordered_mentions(order_results_by_mentions(results), user)
    end
  end

  def order_results_by_mentions results
    order_by_name = {}
    results.each do |result|
      process_result(result, order_by_name) do |mention, order|
        order_by_name[mention] = order
      end
    end
    order_by_name
  end

  def process_result result, order_by_name
    (user, order, mention) = result
    if ! order_by_name[mention] || order_by_name[mention] > order
      yield mention, order
    end
  end

  def connect_ordered_mentions order_by_name, user
    order_by_name.each_pair do |mention,order|
      @users[user].order(order).connect(mention)
    end
  end

  def build_recurse order, user, person, visited, &block
    direct_connections = @users[person].order(1).connections
    connections = direct_connections - visited
    iterate_connections(connections, user, order, visited, &block)
  end

  def iterate_connections connections, user, order, visited, &block
    connections.each do |mention|
      yield [ user, order, mention ]
      visited << mention
      build_recurse(order+1, user, mention, visited.clone, &block)
    end
  end

  def output
    outputs = []
    @users.keys.sort.each do |user|
      outputs << @users[user].output
    end
    outputs.join("\n")
  end
end
