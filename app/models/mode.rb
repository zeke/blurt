class Mode
  
  cattr_accessor :query_phrases

  @@query_phrases = {
    synonym: "What's another word for {word}?",
    # antonym: "What's the opposite of {word}?",
    rhyme: 'What rhymes with {word}?',
    # slang: "What's a good slang term for {word}?",
    # acronym: "What is {word } an acronym for?",
    # abbreviation: "What is {word} short for?",
  }
  
  def self.names
    Mode.query_phrases.keys
  end
  
end