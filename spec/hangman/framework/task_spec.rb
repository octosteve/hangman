module RunnableThing
  def self.do_it(arg) = arg.reverse
end

RSpec.describe Framework::Task do
  it "runs a task asynchronously" do
    Framework::Task.async(RunnableThing, :do_it, ["Done"])
    expect(Framework::Task.await).to eq("enoD")
  end
end
