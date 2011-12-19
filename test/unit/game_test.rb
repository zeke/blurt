require 'test_helper'

describe Game do
  before(:each) do
    @game = Factory.build(:game)
  end

  describe "validation" do
    
    it "is valid" do
      @game.valid?.must_equal true
    end
    
    it "validates presence of :word" do
      @game.word = ''
      @game.valid?.must_equal false
    end

    it "validates presence of :mode" do
      @game.mode = ''
      @game.valid?.must_equal false
    end

    it "validates presence of :over_at" do
      @game.over_at = nil
      @game.valid?.must_equal false
    end

  end

  describe "over?" do
    
    it "is not over when created" do
      @game.over?.must_equal false
    end
      
    it "is over if over_at is in the past" do
      @game.over_at = Time.now - 1.second
      @game.over?.must_equal true
    end
    
  end
  
  describe "current" do
    
    before do
      @game = Game.create! FactoryGirl.attributes_for(:game)
    end
    
    after do
      Game.destroy_all
    end
    
    it "gets the latest game if it's not over" do
      @game.over_at = Time.now + 3.minutes
      @game.save
      Game.current.must_equal @game
    end
    
    it "creates a new game if all existing games are over" do
      @game.over_at = Time.now - 3.minutes
      @game.save
      Game.current.wont_equal @game
    end
    
  end
    
  describe "refresh" do
    
    before do
      User.destroy_all
      @user1 = Factory.create(:user)
      @user2 = Factory.create(:user)      
      @game = Factory.create(:game)
    end
    
    it "vouches matching guesses" do
      
      @game.guesses.vouched.count.must_equal 0
      
      @user1.guesses.create(:word => 'Ringo', :game => @game)
      @user1.guesses.create(:word => 'bingo', :game => @game)
      @user2.guesses.create(:word => 'lingo', :game => @game)
      
      @game.guesses.vouched.count.must_equal 0
      
      @user2.guesses.create(:word => 'ringo', :game => @game)
      
      @game.guesses.vouched.count.must_equal 2      
    end
    
  end

end