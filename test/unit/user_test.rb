require 'test_helper'


describe User do
  
  
  describe "active" do
    
    before do
      @user1 = Factory.create(:user)
      @user2 = Factory.create(:user)
      @user3 = Factory.create(:user)
    end
    
    after do
      User.destroy_all
      Game.destroy_all
      Guess.destroy_all
    end
    
    it "returns all the users who guessed in the current game or the last complete game" do
      
      # Go gack five minutes and create a three-minute game,
      # with guesses from users 1 and 2
      Delorean.time_travel_to(Time.now - 5.minutes) do
        @game = Factory.create(:game, :over_at => Time.now + 3.minutes)          
        @user1.guesses.create(:word => 'surf', :game => @game)
        @user2.guesses.create(:word => 'turf', :game => @game)
      end
      
      Game.over.size.must_equal 1
      User.active.size.must_equal 2
      
      # Create fresh game, with guesses from users 2 and 3
      @game = Game.current
      @user2.guesses.create(:word => 'drift', :game => @game)
      @user3.guesses.create(:word => 'thrift', :game => @game)
      
      User.active.size.must_equal 3
      User.active.first.class.to_s.must_equal 'User' 
    end
    
  end
end