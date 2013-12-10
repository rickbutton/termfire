require "termfire/event_dispatcher"

module Termfire
  class Room
    def initialize(room)
      @room = room
      @run = true
      setup_events
    end

    def listen
      Thread.new do
        while @run do
          @room.listen do |message|
            EventDispatcher.dispatch(:message, message)
          end
        end
      end
    end

    def stop_listen
      @run = false
      destroy_events
    end

    def recent(options = {})
      @room.recent(options)
    end

    def name
      @room.name
    end

    def send_message(args)
      #text = args.first
      #@room.speak text
    end

    private

    def setup_events
      EventDispatcher.register(self, :send_message, :send_message)
    end
    
    def destroy_events
      EventDispatcher.unregister(self, :send_message)
    end
  end
end
