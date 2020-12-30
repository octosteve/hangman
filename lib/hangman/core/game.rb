module Core
  class Game
    require 'set'
    MAX_GUESSES = 10
    attr_reader :name, :selected_word, :turns, :guesses_left
    def self.start_game(name)
      game = new(name)
      game.start
      game
    end

    def initialize(name)
      @name = name
      @turns = []
    end

    def start = @selected_word ||= WordList.get_word

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
  end
end
