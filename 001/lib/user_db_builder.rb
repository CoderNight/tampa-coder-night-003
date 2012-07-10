class UserDbBuilder

  def build(input)
    input.split("\n").each.inject({}) do |db, line|
      build_connections(db,line)
      db
    end
  end

  private

  def extract_name(line)
    line.scan(%r{^(\w+):})[0][0]
  end

  def extract_mentions(line)
    line.scan(%r{@(\w+)}).flatten
  end

  def build_connections(db, line)
    name = extract_name(line)
    db[name] ||= []

    extract_mentions(line).each do |mention|
      db[name] << mention unless db[name].include? mention
    end
  end
end
