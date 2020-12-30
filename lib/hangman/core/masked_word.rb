# frozen_string_literal: true

module Core
  class MaskedWord
    attr_reader :word, :turns
    def self.generate(game)
      new(game).call
    end

    def initialize(game)
      @word = game.selected_word
      @turns = game.turns
    end

    def call
      (method(:mark_found_letters) >> \
       method(:transform_to_masked_value))
        .call(word, turns)
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
