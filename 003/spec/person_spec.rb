require 'rspec'
require_relative '../lib/person.rb'

describe Person do
	before do
		@person = Person.new(["bob:", "@alberta","@duncan"])
	end

	it "has a person class" do
		@person.class.should == Person
	end

	it "has a user" do
		@person.user.should == "bob:"
	end

	it "has people he mentions" do
		@person.mentions.should == ["@alberta","@duncan"]
	end
end