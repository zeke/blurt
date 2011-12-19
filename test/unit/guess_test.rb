require 'test_helper'


describe Guess do
  
  before(:each) do
    @user = Factory.build(:user)
    @guess = Factory.build(:guess, :user => @user)
  end
  
  after(:each) do
    Game.destroy_all
    Guess.destroy_all
    User.destroy_all
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
    
    it "doesn't allow user to guess the same word twice in a game" do
      @guess.save!
      @guess2 = @guess.dup

      @guess2.valid?  
      @guess2.errors.messages.keys.must_equal [:word]
      @guess2.errors.messages[:word].first.must_match(/already submitted/i)
    end
    
    it "doesn't allow user to guess a word that's already been vouched" do      
      User.destroy_all
      Game.destroy_all
      Guess.destroy_all
      @user1 = Factory.create(:user)
      @user2 = Factory.create(:user)
      @user3 = Factory.create(:user)      
      @game = Factory.create(:game)
      
      @user1.guesses.create!(:word => 'salamanca', :game => @game)
      @user2.guesses.create!(:word => 'salamanca', :game => @game)
      
      @game.guesses.vouched.count.must_equal 2

      @bad_guess = @user3.guesses.build(:word => 'salamanca', :game => @game)
      
      @bad_guess.valid?
      @bad_guess.errors.messages.keys.must_equal [:word]
      @bad_guess.errors.messages[:word].first.must_match(/already been vouched/i)
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
  
  describe "as_json" do
    before do
      @guess = Factory.create(:guess, :word => "bingo")
    end
    
    it "returns object with masked word if not yet vouched" do
      JSON.parse(@guess.to_json)[:word].must_equal "*****"
    end
    
    it "returns object with plaintext word if vouched" do
      @guess.vouch!
      JSON.parse(@guess.to_json)[:word].must_equal "bingo"
    end
  end
  
  it "updates user score when vouched" do
    @game = Factory.create(:game)
    @user = Factory.create(:user)
    @user.score.must_equal 0
    
    @user.guesses.create!(:word => 'bimbo', :game => @game)
    @user.guesses.first.vouch!
    @user.reload
    @user.guesses.vouched.size.must_equal 1
    @user.score.must_equal 1
  end

end