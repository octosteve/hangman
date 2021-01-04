# frozen_string_literal: true

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

    def word
      ractor.send([:get_word, Ractor.current])
      Ractor.receive
    end

    def masked_word
      ractor.send([:get_masked_word, Ractor.current])
      Ractor.receive
    end

    private

    attr_reader :ractor

    class GSRactor
      def self.call(word_list, name:)
        game = Core::Game.start_game(name, word_list)
        Ractor.new(game, name: name) do |game|
          loop do
            case receive
            in [:make_guess, "h"]
              raise "I HATE H"
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
    end
    def create_ractor
      words_path = "#{File.expand_path(__dir__)}/../../../assets/words.txt"
      word_list = File.readlines(words_path).map(&:strip)
      child_spec = Framework::Supervisor::ChildSpec.new(name, GSRactor, :call, [word_list])

      Framework::Supervisor.add_child(GOD, child_spec)
    end
  end
end
