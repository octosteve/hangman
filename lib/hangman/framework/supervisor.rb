module Framework
  class Supervisor
    ChildSpec = Struct.new(:id, :object, :action, :args)
    def self.start(children)
      Ractor.new(new(children)) do |supervisor|
        supervisor.start_children
        loop do
          case Ractor.receive
          in [:get_children, from]
            from.send(supervisor.children)
          in [:crash, ractor_name]
            supervisor.restart_child(ractor_name)
          end
        end
      end
    end

    def self.get_children(supervisor)
      supervisor.send([:get_children, Ractor.current])
      Ractor.receive
    end

    def initialize(child_specs)
      @child_specs = child_specs
      @children_map = {}
    end

    def children
      children_map.values
    end

    def start_children
      child_specs.each do |child|
        start_child(child)
        @children_map[child.id] = start_child(child)
      end
    end

    def restart_child(child_name)
      start_child(child_specs.find {_1.id == child_name})
    end

    def start_child(child)
      object = child.object
      action = child.action
      args = child.args
      name = child.id
      server = object.public_send(action, *args, name: name)
      track(server)
    end

    private
    attr_reader :children_map, :child_specs

    def track(server)
      Ractor.new(server, Ractor.current) do |server, supervisor|
        Ractor.select(server)
      rescue Ractor:: RemoteError => e
        supervisor.send([:crash, e.ractor.name])
      end
    end
  end
end


