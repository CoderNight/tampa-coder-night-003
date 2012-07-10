describe "Application" do
  let(:sample_input) { File.read("spec/data/sample_input.txt") }
  let(:expected) { File.read("spec/data/sample_output.txt") }

  it "should output formatted list of connections" do
    userdb       = UserDbBuilder.new.build(sample_input)
    connectiondb = ConnectionDbBuilder.new.build(userdb)
    ConnectionDbFormatter.new.text(connectiondb).should eql(expected)
  end
end
