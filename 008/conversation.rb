#!/usr/bin/env ruby

require 'rgl/adjacency'
require 'rgl/dot'
require 'set'

class TwitterStream

  def initialize
    @graph = RGL::DirectedAdjacencyGraph[]
    @users = Set.new
  end

  def parse_tweets(file_name)
    File.open(file_name, 'r').each do |line|
      user, mentions = parse_line(line)
      @users << user
      next unless mentions.any?

      mentions.each do |mention|
        @graph.add_edge(user, mention.gsub(/@/,''))
      end
    end
  end

  def write_conversations(file_name)
    File.open(file_name, 'w') do |file|
      file.puts(find_conversations)
    end
  end

  def find_conversations
    conversations = {}
    @graph.each_vertex do |user|
      next unless @users.include?(user.to_s)

      convo = Conversation.new(@graph, user)
      convo.process
      conversations[user] = convo
    end

    conversations.sort.map { |_, convo| convo.to_s }.join("\n")
  end

  def parse_line(line)
    user     = line[0...line.index(':')]
    mentions = line.scan(/@[a-zA-Z_0-9]+/)
    [user, mentions]
  end

  def to_s
    @graph.to_s
  end

  def write_image
    file_name = File.join(File.dirname(__FILE__), 'conv_all')
    @graph.write_to_graphic_file('png', file_name)
    `open #{file_name}.png`
  end
end

class Conversation

  attr_reader :user_vertex, :ordered_network

  def initialize(graph, user_vertex)
    @user_vertex     = user_vertex
    @graph           = graph
    @visited         = []
    @ordered_network = []
  end

  def process
    to_visit                  = [@user_vertex]
    connections               = { @user_vertex => 0 }
    max_level                 = 0

    while(cur_vertex = to_visit.shift)
      level = connections[cur_vertex] + 1
      max_level = level if level > max_level

      first_order_connections(cur_vertex).each do |other_vertex|
        unless connections[other_vertex] && connections[other_vertex] < level
          connections[other_vertex] = level

          unless @visited.include?(other_vertex) || to_visit.include?(other_vertex)
            to_visit << other_vertex
          end
        end
      end
    end

    # Return array of arrays in form
    # [[bob, christie], [farid]]
    @ordered_network = Array.new(max_level + 1) { [] }

    connections.each do |user, level|
      @ordered_network[level] << user
    end

    @ordered_network
  end

  def first_order_connections(vertex_1)
    @visited << vertex_1
    level_connections = []

    @graph.each_adjacent(vertex_1) do |vertex_2|
      next unless @graph.has_edge?(vertex_2, vertex_1) # must be bi
      next if vertex_2 == @user_vertex
      level_connections << vertex_2
    end

    level_connections
  end

  def to_s
    @ordered_network.map { |members| members.sort.join(', ') }.join("\n")
  end
end

in_file  = 'complex_input.txt'
out_file = 'my_complex_output.txt'
ref_file = 'my_complex_output_verified.txt'

twits = TwitterStream.new
twits.parse_tweets(in_file)
#twits.write_image
twits.write_conversations(out_file)

diff = `diff #{out_file} #{ref_file}`
raise "Failed. Diff = #{diff}" unless diff.empty?
