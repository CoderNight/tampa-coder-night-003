require 'rspec'
require_relative '../lib/parser.rb'

describe Parser do
	before do
		@parser = Parser.new('sample_input.txt')
	end

	it "has a Parser" do
		@parser.class.should == Parser
	end

	it "should reduce the text file to 'name: @user, @user'" do
		@parser.array_of_tweets.should == 
			[["alberta:", "@bob"], ["bob:", "@alberta"],
			["alberta:", "@christie"], ["christie:", "@alberta", "@bob"],
			["bob:", "@duncan", "@christie"], ["duncan:", "@bob"], ["alberta:", "@duncan"],
			["emily:", "@duncan"], ["duncan:", "@emily"], ["christie:", "@emily"],
			["emily:", "@christie"], ["duncan:", "@farid"], ["farid:", "@duncan"]]
  end

  it "should reduce the array and remove duplicate users" do
  	@parser.compress_tweets.should ==
	  	[["alberta:", "@bob", "@christie","@duncan"], ["bob:", "@alberta", "@duncan", "@christie"],
			["christie:", "@alberta", "@bob", "@emily"],
			["duncan:", "@bob", "@emily","@farid"],
			["emily:", "@christie","@duncan"],["farid:", "@duncan"]]
  end
end