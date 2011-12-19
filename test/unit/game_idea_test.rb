require 'test_helper'

describe GameIdea do
  before(:each) do
    @idea = Factory.build(:game_idea)
  end

  describe "validation" do
    
    it "is valid" do
      @idea.valid?.must_equal true
    end
    
    it "validates presence of :word" do
      @idea.word = ''
      @idea.valid?.must_equal false
    end

    it "validates presence of :mode" do
      @idea.mode = ''
      @idea.valid?.must_equal false
    end

  end
  
  describe "autogenerate" do
    
    before do
      GameIdea.destroy_all
    end
    
    it "creates new game ideas using the wordnik random word API" do
      GameIdea.autogenerate(:limit => 10)
      GameIdea.count.must_equal 10
    end
  
  end
  
end