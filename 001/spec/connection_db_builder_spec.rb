describe ConnectionDbBuilder do
  before :each do
    @userdb = {
     'alpha'   => ['beta'],
     'beta'    => ['alpha', 'charlie'],
     'charlie' => ['beta', 'delta'],
     'delta'   => ['charlie']
    }
  end

  describe "#build" do
    it "1st degree" do
      ConnectionDbBuilder.new.build(@userdb, 1).should eql(
        { 
          'alpha'   => { 1 => ['beta'] },
          'beta'    => { 1 => ['alpha', 'charlie'] },
          'charlie' => { 1 => ['beta', 'delta'] },
          'delta'   => { 1 => ['charlie'] }
        } 
      )
    end

    it "1st and 2nd degree" do
      ConnectionDbBuilder.new.build(@userdb, 2).should eql(
        { 
          'alpha'   => { 1 => ['beta'], 
                         2 => ['charlie'] 
                       },
          'beta'    => { 1 => ['alpha', 'charlie'], 
                         2 => ['delta']
                       },
          'charlie' => { 1 => ['beta', 'delta'],
                         2 => ['alpha']
                       },
          'delta'   => { 1 => ['charlie'],
                         2 => ['beta'] }
        } 
      )
    end

    it "1st, 2nd, and 3rd degree" do
      ConnectionDbBuilder.new.build(@userdb, 3).should eql(
        { 
          'alpha'   => { 1 => ['beta'], 
                         2 => ['charlie'],
                         3 => ['delta']
                       },
          'beta'    => { 1 => ['alpha', 'charlie'], 
                         2 => ['delta'],
                         3 => []
                       },
          'charlie' => { 1 => ['beta', 'delta'],
                         2 => ['alpha'],
                         3 => []
                       },
          'delta'   => { 1 => ['charlie'],
                         2 => ['beta'],
                         3 => ['alpha']
                       }
        } 
      )
    end
  end
end
