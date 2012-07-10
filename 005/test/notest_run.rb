require_relative '../src/run.rb'
require_relative '../src/rabble.rb'
require 'rubygems'
gem 'minitest'
require 'minitest/spec'
require 'minitest/autorun'

describe run do
  before do
    @result = parse('sample_input.txt')
  end

  it 'should parse the file into a Rabble' do
    @result.must_be_instance_of Rabble
  end
end
