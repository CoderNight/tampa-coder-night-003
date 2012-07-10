class Degrees

  def run inputfile, outputfile
    process(IO.read(inputfile))
    IO.write(outputfile, output)
  end

  def process tweets
    initialize_mentions
    iterate_tweets(tweets)
    build_network
  end

  def initialize_mentions
    @mentions = {}
  end

  def iterate_tweets tweets
    tweets.each_line do |line|
      process_tweet_line(line)
    end
  end

  def process_tweet_line line
    if line =~ /^([^:]+):/
      user = $1.to_sym
      process_tweet_line_for(user, line)
    end
  end

  def process_tweet_line_for user, line
    initialize_mentions_for(user)
    while line =~ /^(.*)@(\w+)(.*)$/
      line = $1+$3
      process_mention_for(user, $2.to_sym)
    end
  end

  def initialize_mentions_for user
    @mentions[user] ||= []
  end

  def process_mention_for user, mention
    @mentions[user] << mention
  end

  def build_network
    initialize_network
    iterate_mentions
    @network.build
  end

  def initialize_network
    @network=Network.new
  end

  def iterate_mentions
    @mentions.keys.each do |user|
      iterate_mentions_for(user)
    end
  end

  def iterate_mentions_for user
    @mentions[user].each do |mention|
      build_connection_if_mentioned_back(user, mention)
    end
  end

  def build_connection_if_mentioned_back user, mention
    build_connection_for(user, mention) if @mentions[mention] && @mentions[mention].include?(user)
  end

  def build_connection_for user, mention
    @network.connect 1, user, mention
  end

  def for user
    @network.for(user)
  end

  def output
    @network.output
  end

end
