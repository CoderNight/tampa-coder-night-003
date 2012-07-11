require 'set'

class SixDegrees
  def initialize
    @mentions_by_name = mentions_by_name(STDIN)
    @users            = @mentions_by_name.keys
    @connections      = connections
  end

  def mentions_by_name(io)
    mentions = Hash.new { |hash, key| hash[key] = Set.new }

    io.lines.each do |line|
      mentions[line.split(":").first] |= line.scan(/@([A-Za-z0-9_]+)/).flatten
    end

    mentions
  end

  def connections
    connections = Hash.new { |hash, key| hash[key] = Set.new }

    @mentions_by_name.each do |name, mentioned_users|
      mentioned_users.each do |mentioned_user|
        connections[name] << mentioned_user if @mentions_by_name[mentioned_user].include?(name)
      end
    end

    connections
  end

  def results
    @users.sort.map { |name|
      seen = Set.new(name)
      connections = []
      level = [name]

      while level.any?
        seen |= level
        connections << level
        level = level.map { |previous_name| (@connections[previous_name] - seen).to_a }.flatten.uniq
      end

      connections.map { |level| level.sort.join(", ") }.join("\n") + "\n"
    }.join("\n")
  end
end

puts SixDegrees.new.results

