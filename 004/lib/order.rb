class Order
  attr_reader :connections

  def initialize order, user
    @order = order
    @user = user
    @connections = []
  end

  def connect mention
    @connections << mention if ! @connections.include?(mention)
  end

  def include? user
    @connections.include?(user)
  end
end
