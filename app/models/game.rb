class Game < ActiveRecord::Base
  has_many :guesses, :dependent => :destroy
  has_many :users, :through => :guesses

  validates_presence_of :word, :mode, :over_at
    
  # default_scope where(:rating => 'G')
  default_scope order("id DESC")
  scope :over, lambda { where("over_at < ?", Time.now) }
  scope :not_yet_over, lambda { where("over_at > ?", Time.now) }
  
  cattr_accessor :duration
  @@duration = 300.seconds

  def over?
    Time.now > self.over_at
  end

  def refresh
    unvouched_guesses = self.guesses.unvouched
    # Store any unvouched matching guesses in an array  
    vouchables = unvouched_guesses.map(&:word).map(&:downcase).dups
    if vouchables.present?
      unvouched_guesses.each do |guess|
        guess.vouch! if vouchables.include?(guess.word.downcase)
      end
    end
  end

  def self.current
    Game.not_yet_over.first || Game.create_from_ideas
  end
  
  def self.create_from_ideas
    idea = GameIdea.pop!
    game = Game.create!(
      :word => idea.word,
      :mode => idea.mode,
      :over_at => Time.now + Game.duration
    )
    game
  end
  
  def unique_guesses
    words_so_far = []
    self.guesses.map do |guess|
      next if words_so_far.include? guess.word.downcase
      words_so_far << guess.word.downcase
      guess
    end.compact
  end

  def as_json(options={})
    {
      id: self.id,
      word: self.word,
      mode: self.mode,
      query_phrase: Mode.query_phrases[self.mode.to_sym],
      ends_in: (self.over_at - Time.now),
      guesses: self.unique_guesses,
      users: User.active
    }
  end
  
end