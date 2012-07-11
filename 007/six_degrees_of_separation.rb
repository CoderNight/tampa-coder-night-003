#!/usr/bin/env ruby

# http://puzzlenode.com/puzzles/14-six-degrees-of-separation

require 'set'


# Build hash that will hold all the first order refs.  The keys are the unique tweeters,
# the values are Sets of unique @refs found in that tweeter's tweets.  Reads file specified
# by 'path' into the hash by parsing the key out of each line and then scanning each line
# for an array of @ref matches which are then unioned into that hash element's Set.  Then
# any un-reciprocated @refs AND any @refs to people who haven't tweeted are deleted.
#
# @param path [String] path to input file to parse the tweets from
# @return [Hash<String=>Set>] hash of first order refs
def read_first_order_refs(path)
  people = Hash.new {|hash, key| hash[key] = Set.new}  # values default to new Set instances
  File.foreach(path) { |line| people[line[/^\w+/]] |= line.scan(/(?<=@)\w+/) }
  people.each { |person, refs| refs.delete_if { |ref| !people.include?(ref) || !people[ref].include?(person) } }
end


# Iteratively builds the degrees of separation data structure 'levels'.  
# Initially, 'levels' should be passed in containing only level 0 which holds
# the name of the person whose associations are to be built.  These 4 lines
# actually do ALL the work of finding the degrees of separation.  It does this
# by iterating through the degrees of separation building a full level of 
# separation one at a time before moving on to the next higher level of 
# separation in the next recursion.
#
# @param degree [integer] degree of separation to look at within 'levels' to 
#   build the next level from
# @param levels [SortedSetHash] hash key'd by int degree of separation and whose
#   values are a SortedSet of names of people at that level
def build_levels(degree, levels)
  levels[degree].each do |person|
    levels[degree + 1] |= @people[person].reject{|friend| levels.any?{|level, people| people.include?(friend)}}
  end
  build_levels(degree + 1, levels) unless levels[degree + 1].empty?
end


# Get the people associated to 'person' broken down in lists grouped by degree 
# of separation.  This is just a convenience method for wrapping access to 
# the #build_levels method.
# 
# @param person [String] name of tweeter who's associations are to be returned
# @return [Array<Array<String>>] nested array where the first dimension is the degree of separation
#   and the second dimension is the list of names in that degree of separation
def degrees(person)
  (levels = Hash.new {|hash, key| hash[key] = SortedSet.new})[0] << person
  build_levels(0, levels)
  levels.values[1...-1].map(&:to_a)
end


# Read all first order refs from file identified by path passed in ARGV[0]
@people = read_first_order_refs(ARGV[0])


# Generate output file by iterating through the sorted list of tweeters and 
# printing their name followed by the sorted names of their @refs where each 
# new degree of separation is on a new line
File.open(ARGV[0].sub(/\.txt$/,'')+'.out.txt', "w") do |file|
  @people.keys.sort.each do |person|
    file.write("\n#{person}\n")
    degrees(person).each {|level| file.write(level.join(', ')+"\n") }
  end
end
