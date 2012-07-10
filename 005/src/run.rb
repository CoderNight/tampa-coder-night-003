require_relative './rabble.rb'

def parse(file_name)
  rabble = Rabble.new
  file = File.new(file_name)
  while line = file.gets
    from = parse_from(line)
    tos = parse_tos(line)
    rabble.union tos.map {|to| [from, to]}
  end
  file.close
  rabble
end

def parse_from(line)
  line.split(':', 2)[0]
end

def parse_tos(line)
  line.scan(/@\w+/).map {|item| item[1..-1]}
end

rabble = parse 'sample_input.txt'
for butterfly in rabble.users.sort
  print butterfly, "\n"
  i = 1
  cxns = rabble.n_order(butterfly, i)
  while not cxns.empty?
    print cxns.sort.join(', '), "\n"
    i += 1
    cxns = rabble.n_order(butterfly, i)
  end
  print "\n"
end
