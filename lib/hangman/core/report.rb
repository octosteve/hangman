module Core
  class Rules
    MAX_GUESSES = 10
  end

  class Report
    def self.generate(game)
      new(game)
    end

    def initialize(game)
      @game = game
    end

    def lost? = game.guesses_left.zero? && !won?

    def won? = !game.masked_word.include?("*")

    def guesses_left = Rules::MAX_GUESSES - game.guesses.count

    private

    attr_reader :game
  end
end
