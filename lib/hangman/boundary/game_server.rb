module Boundary
  class GameServer
    attr_reader :name
    def initialize(name:)
      @name = name
      @ractor = create_ractor
    end

    def make_guess(guess)
      ractor.send([:make_guess, guess])
    end

    def won?
      ractor.send([:won?, Ractor.current])
      Ractor.receive
    end

    def lost?
      ractor.send([:lost?, Ractor.current])
      Ractor.receive
    end

    def get_word
      ractor.send([:get_word, Ractor.current])
      Ractor.receive
    end

    def create_ractor
      words_path = "#{File.expand_path(__dir__)}/../../../assets/words.txt"
      word_list = File.readlines(words_path).map(&:strip)
      Ractor.new(word_list, name: name) do |word_list| 
        game = Core::Game.start_game(name, word_list)
        loop do
          case Ractor.receive
          in [:make_guess, guess]
            game.make_guess(guess)
          in [:won?, from]
            from.send game.won?
          in [:lost?, from]
            from.send game.lost?
          in [:get_word, from]
            from.send game.selected_word
          in [:get_masked_word, from]
            from.send game.masked_word
          end
        end
      end
    end

    private
    attr_reader :ractor
  end
end