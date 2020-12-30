module Core
  class WordList
    class SystemWordList
      WORDS_PATH = "#{File.expand_path(__dir__)}/../../../assets/words.txt"
      def self.call
        File.readlines(WORDS_PATH)
      end
    end

    def self.get_word
      new.get_word
    end

    def initialize(dict=SystemWordList)
      @word_list = dict.call.reject {_1.length < 5}
    end

    def get_word
      word_list.sample
    end

    private
    attr_reader :word_list
  end
end
