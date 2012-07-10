require_relative '../src/rabble.rb'
require 'rubygems'
gem 'minitest'
require 'minitest/spec'
require 'minitest/autorun'

describe Rabble do
  before do
    @rabble = Rabble.new
  end
  
  it 'should hold mentions' do
    @rabble.add [:ted, nil] 
    @rabble.mentions.must_include [:ted, nil] 
  end

  it 'should hold connections when there are reflexive mentions' do
    @rabble.union [[:ted, :colleen], [:colleen, :ted]]
    @rabble.cxns.must_equal [[:colleen, :ted]].to_set
  end

  it 'should tell the n-order connections where n=1' do
    @rabble.union [[:ted, :colleen], [:colleen, :ted]]
    @rabble.n_order(:ted, 1).must_equal [:colleen].to_set
    @rabble.n_order(:colleen, 1).must_equal [:ted].to_set
  end

  it 'should tell the n-order connections where n=2' do
    @rabble.union [[:ted, :colleen], [:colleen, :ted], [:colleen, :kimberly], [:kimberly, :colleen]]
    @rabble.n_order(:ted, 2).must_equal [:kimberly].to_set
    @rabble.n_order(:kimberly, 2).must_equal [:ted].to_set
  end

  it 'should tell the n-order connections where n=3' do
    @rabble.cxns = [[:alberta, :bob],
                   [:alberta, :christie],
                   [:bob, :duncan],
                   [:christie, :bob],
                   [:duncan, :emily],
                   [:emily, :christie],
                   [:farid, :duncan],
    ]
    @rabble.n_order(:alberta, 3).must_equal [:farid].to_set
  end
end
