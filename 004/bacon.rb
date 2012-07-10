#!/usr/bin/env ruby

$: << 'lib'

require 'order'
require 'user'
require 'network'
require 'degrees'

class Runner
  def self.run
    ARGV.size == 2 ? carousel : raise(usage)
  end

  def self.usage
    "Invalid Arguments\n\nUsage:\n  bacon.rb {input file} {output file}\n\n"
  end

  def self.carousel
    degrees = Degrees.new
    degrees.run(ARGV[0], ARGV[1])
  end
end

Runner.run if __FILE__ == $0
