class GuessValidator < ActiveModel::Validator
  def validate(record)
    if record.game && record.game.guesses.all.any? {|guess| guess.user_id == record.user_id && guess.word.downcase == record.word.downcase }
      record.errors[:word] << "You've already submitted that word."
    elsif record.game && record.game.guesses.vouched.any? {|guess| guess.word.downcase == record.word.downcase }
      record.errors[:word] << "That word has already been vouched by two players."      
    end
  end
end

class Guess < ActiveRecord::Base
  belongs_to :game
  belongs_to :user
  
  after_create :refresh_game
  
  validates_presence_of :game, :user, :word
  validates_with GuessValidator
  
  scope :vouched, lambda { where('vouched_at IS NOT NULL') }
  scope :unvouched, lambda { where('vouched_at IS NULL') }
  
  def refresh_game
    self.game.refresh
  end
    
  def vouched?
    self.vouched_at.present?
  end
  
  def vouch!
    self.update_attribute(:vouched_at, Time.now) unless vouched?
    self.user.increment!(:score)
  end
  
  def as_json(options={})
    {
      id: self.id,
      word: self.vouched? ? self.word : ("*" * self.word.size),
      user_id: self.user_id
    }
  end

  
end
