# frozen_string_literal: true

RSpec.describe Core::WordList do
  it "filters out short words" do
    word_list = %w[no everything]
    word_list = Core::WordList.new(word_list)
    expect(word_list.get_word).to eq("everything")
  end
end
