require 'set'

class Rabble
  attr_accessor :users, :mentions, :cxns

  def initialize
    @users = [].to_set
    @cxns = [].to_set
    @mentions = [].to_set
  end

  def check_reflexive_mentions
    @cxns += @mentions.map {|mention| @mentions.include?(mention.reverse) ? mention.sort : nil}.compact
  end

  def add(item)
    @mentions << item
    @users += item
    check_reflexive_mentions
  end

  def union(other_set)
    @mentions += other_set
    for item in other_set
      @users += item
    end
    check_reflexive_mentions
  end

  def n_order(name, n)
    if n == 1
      @cxns.reduce([].to_set) {|memo, cxn| memo + (cxn.include?(name) ? cxn.to_set - [name] : [])}
    else
      n_order(name, n - 1).reduce([].to_set) {|memo, item| memo + n_order(item, 1)} - (1...n).reduce([].to_set) {|memo, item| memo + n_order(name, item)} - [name]
    end
  end
end
