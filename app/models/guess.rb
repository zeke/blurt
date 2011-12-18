class GuessValidator < ActiveModel::Validator
  def validate(record)    
    if record.game && record.game.guesses.any? {|guess| guess.user_id == record.user_id && guess.word.downcase == record.word.downcase }
      record.errors[:word] << "You've already submitted that word."
    end
  end
end

class Guess < ActiveRecord::Base
  belongs_to :game
  belongs_to :user
  
  after_create :refresh_game
  
  validates_presence_of :game, :user, :word
  validates_with GuessValidator
  
  def refresh_game
    self.game.refresh
  end
  
  def vouched?
    self.vouched_at.present?
  end
  
  def vouch!
    self.update_attribute(:vouched_at, Time.now) unless vouched?
  end
  
end
