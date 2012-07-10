class ConnectionDbFormatter

  def remove_zero_connection_users(connectiondb)
    connectiondb.reject! do |name, user|
      user.each_value.all? { |connections| connections.empty? }
    end
  end

  def generate_user_output(name, user, output)
      output += name + "\n"

      user.sort.each do |degree, connections|
        output += "#{connections.sort.join(', ')}\n" if connections.any?
      end

      output += "\n"
  end

  def text(connectiondb)
    remove_zero_connection_users(connectiondb)

    connectiondb.sort.each.inject('') do |output, entry|
      generate_user_output(entry[0], entry[1], output) 
    end.chomp
  end
end

