RSpec.describe Core::MaskedWord do
  it "surfaces masked word" do
    game = Core::Game.start_game("Steven's game")
    game._set_selected_word("branch")
    masked_word = Core::MaskedWord.generate(game)
    expect(masked_word).to eq("******")
  end

  it "reveals masked word if guess is correct" do
    game = Core::Game.start_game("Steven's game")
    game._set_selected_word("branch")
    game.make_guess("b")
    masked_word = Core::MaskedWord.generate(game)
    expect(masked_word).to eq("b*****")
    game.make_guess("r")

    masked_word = Core::MaskedWord.generate(game)
    expect(masked_word).to eq("br****")
  end
end
