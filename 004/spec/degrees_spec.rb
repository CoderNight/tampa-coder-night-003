require 'bacon'

describe "14-six-degrees-of-separation" do

  describe "given the example tweets" do
    before(:all) do
      @tweets = <<EOM
alberta: @bob "It is remarkable, the character of the pleasure we derive from the best books."
bob: "They impress us ever with the conviction that one nature wrote and the same reads." /cc @alberta
alberta: hey @christie. what will we be reading at the book club meeting tonight?
christie: "Every day, men and women, conversing, beholding and beholden..." /cc @alberta, @bob
bob: @duncan, @christie so I see it is Emerson tonight
duncan: We'll also discuss Emerson's friendship with Walt Whitman /cc @bob
alberta: @duncan, hope you're bringing those peanut butter chocolate cookies again :D
emily: Unfortunately, I won't be able to make it this time /cc @duncan
duncan: @emily, oh what a pity. I'll fill you in next week.
christie: @emily, "Books are the best of things, well used; abused, among the worst." -- Emerson
emily: Ain't that the truth /cc @christie
duncan: hey @farid, can you pick up some of those cookies on your way home?
farid: @duncan, might have to work late tonight, but I'll try
EOM
    end

    # Seeing that the output list has to be alphabetical,
    # let's begin with alberta's connections.
    describe "alphabetical output list" do
      before(:all) do
        @degrees = Degrees.new
        @degrees.process(@tweets)
        @degrees
      end

      describe "alberta's connections" do

	# Alberta has had direct conversations with bob and christie.
        it "has had direct conversations with bob and christie." do
	  @degrees.for(:alberta).order(1).should include(:bob)
	  @degrees.for(:alberta).order(1).should include(:christie)
        end

	# Note that even though alberta has mentioned duncan once,
	# duncan has never mentioned alberta,
	# so there is no direct connection between them.
        it "has no direct connection with duncan" do
	  @degrees.for(:alberta).order(1).should_not include(:duncan)
        end

	# Besides having had conversations with alberta,
	# bob has talked to duncan and christie.
	# Christie has had conversations with alberta, bob and emily.
	# As a result, duncan and emily are alberta's second order connections.
        it "has second order connections with duncan and emily" do
	  @degrees.for(:alberta).order(2).should include(:duncan)
	  @degrees.for(:alberta).order(2).should include(:emily)
        end

	# Note that even though bob and christie have had a two-way
	# conversation of their own, they should not be added as second
	# order connections, since they have already been included as
	# first order ones. In other words, a connection should only be
	# listed once and the nearest connection takes precedence.
        it "does not have second order connections with bob and christie" do
	  @degrees.for(:alberta).order(2).should_not include(:bob)
	  @degrees.for(:alberta).order(2).should_not include(:christie)
        end

	# Moving on. Since emily has only ever talked to duncan and christie,
	# there are no new connections added through her.
	# Duncan, however, brings in farid as a 3rd order connection.
        it "has a third order connections with farid" do
	  @degrees.for(:alberta).order(3).should include(:farid)
        end

	# The output for alberta should then look as follows:
	#
	# alberta
	# bob, christie
	# duncan, emily
	# farid
        it "outputs correctly" do
          output=<<EOM
            alberta
            bob, christie
            duncan, emily
            farid
EOM
          output.gsub!(/^ +/m,'')
	  @degrees.for(:alberta).output.should eq(output)
        end

      end

      describe "everyone's connections" do

	# Continuing in alphabetical order, we would then need to plot the
	# connections for bob, then for christie, and so on. The final
	# output file then would look like this:

        it "outputs correctly" do
          output=<<EOM
            alberta
            bob, christie
            duncan, emily
            farid
            
            bob
            alberta, christie, duncan
            emily, farid
            
            christie
            alberta, bob, emily
            duncan
            farid
            
            duncan
            bob, emily, farid
            alberta, christie
            
            emily
            christie, duncan
            alberta, bob, farid
            
            farid
            duncan
            bob, emily
            alberta, christie
EOM
          output.gsub!(/^ +/m,'')
	  @degrees.output.should eq(output)
        end

      end
    end

  end
end
