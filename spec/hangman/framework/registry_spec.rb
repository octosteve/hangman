RSpec.describe Framework::Registry do
  it "registers a ractor" do
    registry = Framework::Registry.start
    ractor = Ractor.new do
      loop do
        nil
      end
    end
    Framework::Registry.add(registry, "me", ractor)
    expect(Framework::Registry.get(registry, "me")).to eq(ractor)
  end

  it "removes a ractor if it dies" do
    registry = Framework::Registry.start
    ractor = Ractor.new {"dead fast"}
    Framework::Registry.add(registry, "me", ractor)
    sleep 0.1 # let it clean up
    expect(Framework::Registry.get(registry, "me")).to be_nil
  end
end
