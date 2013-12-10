module Termfire
  class EventDispatcher

    Event = Struct.new(:name, :args)

    @@listeners = {}
    @@work = Queue.new

    def self.register(object, event_name, method = nil, &block)
      raise "Cannot pass method name and block" if method && block

      @@listeners[event_name] ||= []
      
      @@listeners[event_name] << {
        object: object,
        method: method,
        block: block
      }
    end

    def self.unregister(object, event_name)
      @@listeners[event_name].each do |listener|
        if listener[:object] == object 
          @@listeners[event_name].delete listener
        end
      end
    end

    def self.dispatch(event_name, *args)
      #@@work << Event.new(event_name, args)
      do_work Event.new(event_name, args)
    end

    def self.start
      #Thread.new do
      #  while true do
      #    get_work
      #  end
      #end
    end

    private

    def self.get_work
      Thread.pass if @@work.empty?
      event = @@work.pop
      do_work(event)
    end

    def self.do_work(event)
      listeners = @@listeners[event.name]
      if listeners
        listeners.each do |listener|
          if listener[:method]
            listener[:object].send(listener[:method], event.args)
          elsif listener[:block]
            listener[:block].call(*(event.args))
          end
        end
      end
    end

  end
end
