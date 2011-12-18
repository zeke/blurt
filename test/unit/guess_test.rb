require 'test_helper'


describe Guess do
  
  before(:each) do
    @user = Factory.build(:user)
    @guess = Factory.build(:guess, :user => @user)
  end

  describe "validation" do
    
    it "is valid" do
      @guess.valid?.must_equal true
    end
    
    it "validates presence of :word" do
      @guess.word = ''
      @guess.valid?.must_equal false
      @guess.word = nil
      @guess.valid?.must_equal false
    end
    
    it "validates presence of user" do
      @guess.user = nil
      @guess.valid?.must_equal false
    end

    it "validates presence of game" do
      @guess.game = nil
      @guess.valid?.must_equal false
    end
    
    it "doesn't allow user to make the same case-insensitive guess twice in a game" do
      @guess.save!
      @guess2 = @guess.dup

      @guess2.valid?  
      @guess2.errors.messages.keys.must_equal [:word]
      @guess2.errors.messages[:word].first.must_match(/already submitted/i)
    end
    
  end
    
  describe "vouching" do
    it "defaults to an unvouched state" do
      @guess.vouched?.must_equal false
    end
    
    it "can be vouched" do
      @guess.vouch!
      @guess.vouched?.must_equal true      
    end
    
  end

end