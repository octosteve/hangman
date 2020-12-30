class TestRactor
  def self.start(*args, name:)
    Ractor.new(*args, name: name) do |args|
      loop do
        case args
        when "die"
          raise 
        else
          nil
        end
      end
    end
  end
end
RSpec.describe Framework::Supervisor do
  xit "Starts Servers" do
    child_spec = Framework::Supervisor::ChildSpec.new("uniq_name", TestRactor, :start, [ "arg1"])
    supervisor = Framework::Supervisor.start([child_spec])
    sleep 1
    Framework::Supervisor.get_children(supervisor) => [child]
    expect(child).to be_a(Ractor)
  end

  xit "restarts a child if it dies" do
    child_spec = Framework::Supervisor::ChildSpec.new("id", TestRactor, :start, [ "die", name: "My Server"])
    supervisor = Framework::Supervisor.start([child_spec])
    sleep 1
    Framework::Supervisor.get_children(supervisor) => [child]
    expect(child).to be_a(Ractor)
  end
end
