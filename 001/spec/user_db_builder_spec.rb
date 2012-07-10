describe UserDbBuilder do
  before :each do
    @input = <<-EOF.gsub(/^\s*/, '')
      alberta: @bob "It is remarkable, the character of the pleasure we derive from the best books."
      bob: "They impress us that one nature wrote and the same reads." /cc @alberta, @joe
      bob: "This line tests duplicate mentions." /cc @alberta, @joe
    EOF
  end

  describe "#build" do
    it "should return a hash of users with their connections" do
      UserDbBuilder.new.build(@input).should eql(
        { 
          'alberta' => ['bob'],
          'bob'     => ['alberta', 'joe']
        }
      )
    end
  end
end
