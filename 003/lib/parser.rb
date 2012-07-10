class Parser
	attr_reader :array_of_tweets
	def initialize(input_file)
    @input_file = input_file
    @array_of_tweets ||= reduce_input
    @reduced_tweets = []
  end

  def reduce_input
  	tweets = []
  	File.open(@input_file, "r").each do |line|
      tweets << [line.scan(/\w+:/), line.scan(/@\w+/)].flatten
  	end
  	tweets
  end

  def combine_a_tweet(tweet, compared_tweet)
    tweet += compared_tweet
    tweet.uniq
  end

  def same_user?(tweet, compared_tweet)
    tweet[0] == compared_tweet[0]
  end

  def compress_tweets
    @array_of_tweets.each do |tweet|
      @array_of_tweets.each do |compared_tweet|
       	if same_user?(tweet, compared_tweet)
      	  puts "#{tweet} #{compared_tweet}"
       	  tweet = combine_a_tweet(tweet, compared_tweet)
       	end
      end
      @reduced_tweets << tweet
    end
    @reduced_tweets
  end
  def create_person_objects
    @reduced_tweets.each do |tweet|
    	name_of_person = tweet[0]
    	name_of_person = Person.new(tweet)
    end
  end
end