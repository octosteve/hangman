module Core
  class Game
    require 'set'
    MAX_GUESSES = 10
    attr_reader :name, :selected_word, :word_list, :turns, :guesses_left
    def self.default_word_list
      words_path = "#{File.expand_path(__dir__)}/../../../assets/words.txt"
      word_list = File.readlines(words_path)
    end

    def self.start_game(name, word_list = default_word_list)
      game = new(name, word_list)
      game.start
      game
    end

    def initialize(name, word_list)
      @name = name
      @word_list = word_list
      @turns = []
    end

    def start = @selected_word ||= WordList.get_word(word_list)

    def make_guess(guess) = @turns << Turn.take(self, guess)

    def guesses = turns.uniq(&:guess).map(&:guess)

    def guesses_left = report.guesses_left

    def masked_word = MaskedWord.generate(self)

    def lost? = report.lost?
    def won? = report.won?

    # ONLY FOR TESTS
    def _set_selected_word(selected_word) = @selected_word = selected_word

    private
    def report = Report.generate(self)

    def default_word_list
      words_path = "#{File.expand_path(__dir__)}/../../../assets/words.txt"
      word_list = File.readlines(words_path)
    end
  end
end
