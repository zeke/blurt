class GameIdea < ActiveRecord::Base
  
  validates_presence_of :word, :mode
  
  default_scope order("id ASC") # first come, first served
  
  # Fetch random nouns from the Wordnik API
  # 
  def self.autogenerate(options={})
    options.reverse_merge!(
      :include_part_of_speech => 'noun',
      :min_corpus_count => 100_000,
      :min_dictionary_count => 1,
      :limit => 20
    )    
    words = Wordnik.words.get_random_words(options).map{|w| w['word']}
    
    words.each do |word|    
      GameIdea.create!(:word => word, :mode => Mode.names.sample)
    end
  end
  
  def self.pop!
    GameIdea.autogenerate if GameIdea.count.zero?
    @idea = GameIdea.first
    @idea.destroy
    @idea
  end

end
