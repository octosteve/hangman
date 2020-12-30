module Framework
  class Registry
    def self.start
      registry = new
      Ractor.new(registry) do |registry|
        loop do
          case Ractor.receive
          in [:get, name, from]
            from.send registry.get(name)
          in [:remove, name]
            registry.remove(name)
          in [:add, name, Ractor => item]
            registry.add(name, item)
            Ractor.new(self, name, item) do |registry, name, ractor|
              Ractor.select(ractor)
              registry.send([:remove, name])
            end
          end
        end
      end
    end

    def self.add(registry, name, item)
      registry.send([:add, name, item])
    end

    def self.get(registry, name)
      registry.send([:get, name, Ractor.current])
      Ractor.receive
    end

    def initialize(state={})
      @state = state
    end

    def get(name)
      state[name]
    end

    def add(name, item)
      state[name] = item
    end

    def remove(name)
      state[name] = nil
    end

    private
    attr_reader :state
  end
end


