module Core
  class Game
    require 'set'
    MAX_GUESSES = 10
    attr_reader :name, :selected_word, :guesses, :turns
    def self.start_game(name)
      game = new(name)
      game.start
      game
    end
    def initialize(name)
      @name = name
      @turns = []
      @guesses = Set.new
    end

    def start
      @selected_word ||= Core::WordList.get_word
    end

    def make_guess(guess)
      @turns << Turn.take(self, guess)
      @guesses = guesses.to_set.add(guess).to_a
    end

    def masked_word
      transform_to_masked_value(
        mark_found_letters(selected_word, turns)
      )
    end

    def _set_selected_word(selected_word)
      @selected_word = selected_word
    end

    def lost?
      guesses.count >= MAX_GUESSES && !won?
    end

    def won?
      !masked_word.include?("*")
    end

    private

    def upcase_found_letter(word, guess)
      word.gsub(guess) { _1.upcase }
    end

    def transform_to_masked_value(word)
      word.chars.map do
        case _1
        when /[a-z]/ then "*"
        when /[A-Z]/ then _1.downcase
        end
      end.join("")
    end

    def mark_found_letters(word, turns)
      turns.filter(&:hit).reduce(word.downcase) do |word, turn|
        upcase_found_letter(word, turn.guess)
      end
    end
  end
end
