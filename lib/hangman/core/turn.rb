module Core
  class Turn
    attr_reader :game, :guess, :hit
    def self.take(game, guess)
      new(game, guess)
    end

    def initialize(game, guess)
      @game = game
      @guess = guess
      @hit = calculate_hit()
    end

    private
    def calculate_hit
      game.selected_word.include?(guess)
    end
  end
end
