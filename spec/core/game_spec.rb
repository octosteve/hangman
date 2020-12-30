# frozen_string_literal: true

RSpec.describe Core::Game do
  it "captures a game's name on start" do
    game = Core::Game.new("Steven's game", [])
    expect(game.name).to eq("Steven's game")
  end

  it "selects a word from a word list on start" do
    game = Core::Game.start_game("Steven's game")
    expect(game.selected_word).to_not be_nil
  end

  it "surfaces masked word" do
    game = Core::Game.start_game("Steven's game")
    game._set_selected_word("branch")
    expect(game.masked_word).to eq("******")
  end

  it "captures guesses" do
    game = Core::Game.start_game("Steven's game")
    game.make_guess("b")
    expect(game.guesses).to eq(["b"])
  end

  it "reveals masked word if guess is correct" do
    game = Core::Game.start_game("Steven's game")
    game._set_selected_word("branch")
    game.make_guess("b")
    expect(game.masked_word).to eq("b*****")
    game.make_guess("r")
    expect(game.masked_word).to eq("br****")
  end

  it "knows if you've won the game" do
    game = Core::Game.start_game("Steven's game")
    game._set_selected_word("people")
    expect(game).to_not be_won
    game.make_guess("p")
    game.make_guess("e")
    game.make_guess("o")
    game.make_guess("l")
    expect(game).to be_won
  end

  it "limits you to 10 guesses" do
    game = Core::Game.start_game("Steven's game")
    game._set_selected_word("people")

    ("a".."z")
      .reject { "people".include?(_1) }
      .take(10)
      .each { game.make_guess(_1) }

    expect(game).to be_lost
    expect(game).to_not be_won
  end

  it "lets you win at the last minute" do
    game = Core::Game.start_game("Steven's game")
    game._set_selected_word("people")

    ("a".."z")
      .reject { "people".include?(_1) }
      .take(6)
      .each { game.make_guess(_1) }

    game.make_guess("p")
    game.make_guess("e")
    game.make_guess("o")
    game.make_guess("l")

    expect(game).to be_won
  end

  it "rejects duplicate guesses" do
    game = Core::Game.start_game("Steven's game")
    game._set_selected_word("people")
    game.make_guess("p")
    game.make_guess("p")
    expect(game.guesses).to eq(["p"])
  end

  it "knows how many guesses you have left" do
    game = Core::Game.start_game("Steven's game")
    game._set_selected_word("people")
    game.make_guess("p")
    # game.make_guess("p")
    expect(game.guesses_left).to eq(Core::Game::MAX_GUESSES - 1)
  end

  it "does not penalize you if you repeat a letter" do
    game = Core::Game.start_game("Steven's game")
    game._set_selected_word("people")
    game.make_guess("p")
    game.make_guess("p")
    expect(game.guesses_left).to eq(Core::Game::MAX_GUESSES - 1)
  end
end
