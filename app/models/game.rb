class Game < ActiveRecord::Base
  has_many :guesses
  has_many :users, :through => :guesses

  validates_presence_of :word, :mode, :over_at
  
  def over?
    Time.now > self.over_at
  end
  
  def refresh
    # check guesses.
    # vouch dupes.
    # disregard case
    # don't allow user-game-word repeats (cheating)
  end

  def self.current
    Game.where("over_at > ?", Time.now).first ||
    Game.create!(
      :word => "bozo", 
      :mode => 'rhyme',
      :over_at => Time.now + 30.seconds
    )
  end
  
end
