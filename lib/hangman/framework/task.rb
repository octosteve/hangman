module Framework
  class Task
    def self.async(obj, message, args)
      Ractor.new(obj, message, args, Ractor.current) do |object, message, args, owner|
        result = object.send(message, *args)
        owner.send(result)
      end
    end

    def self.await
      Ractor.receive
    end
  end
end


