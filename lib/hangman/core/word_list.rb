module Core
  class WordList
    def self.get_word(word_list)
      new(word_list).get_word
    end

    def initialize(word_list)
      @word_list = word_list.reject {_1.length < 5}
    end

    def get_word
      word_list.sample
    end

    private
    attr_reader :word_list
  end
end
