class ConnectionDbBuilder

  def build(userdb, degrees=6)
    @userdb = userdb
    @connectiondb = autohash
    (1..degrees).each {|degree| process_users(degree) }
    @connectiondb
  end

  private

  def autohash
    auto = proc {|hash,key| hash[key] = Hash.new &auto }
    Hash.new &auto
  end

  def already_connected?(user, candidate)
    @connectiondb[user].each_value.any? do |connections|
      connections.include? candidate
    end
  end

  def connection?(user, candidate, degree)
    return directly_connected?(user, candidate) if degree == 1

    @connectiondb[user][degree - 1].any? do |connection|
      directly_connected? connection, candidate
    end
  end 

  def directly_connected?(user, candidate)
    @userdb[user].include?(candidate) and @userdb[candidate].include?(user)
  end

  def valid_candidates(user, degree)
    @userdb.each_key.inject([]) do |connections, candidate_name|
      connections << candidate_name if valid_connection?(user, candidate_name, degree)
      connections
    end
  end

  def process_users(degree)
    @userdb.each_key {|user| @connectiondb[user][degree] = valid_candidates(user,degree)} 
  end

  def valid_connection?(user, candidate, degree)
    user != candidate and not already_connected?(user, candidate) and connection?(user, candidate, degree)
  end
end
