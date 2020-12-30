# frozen_string_literal: true

require_relative "hangman/version"
require_relative "hangman/framework"
require_relative "hangman/core"
require_relative "hangman/boundary"

module Hangman
  class Error < StandardError; end
  def self.new_game(name)
    Boundary::GameServer.new(name: name)
  end
end
