require "termfire/version"
require "termfire/display/terminal"
require "termfire/event_dispatcher"
require "termfire/room"
require "termfire/client"

module Termfire
  class CLI

    def initialize(args)
      #debug
      Thread.abort_on_exception = true

      setup_events
      @client = Termfire::Client.new(
        args[0], 
        token: args[1]
      )
      @terminal = Termfire::Display::Terminal.new

      @room_index = 0
    end

    def start

      EventDispatcher.start 

      @room = Termfire::Room.new(@client.rooms[@room_index])
      @room.listen
      EventDispatcher.dispatch(:changed_room, @room)

      setup_initial_messages

      while true do; end
    end

    def close
      @terminal.close
      @room.stop_listen
      destroy_events
      exit
    end

    private

    def switch_room(args)
      @room_index += 1
      @room_index = 0 if @room_index >= @client.rooms.length

      @room.stop_listen

      @room = Termfire::Room.new(@client.rooms[@room_index])
      
      EventDispatcher.dispatch(:chat_clear)
      EventDispatcher.dispatch(:changed_room, @room)

      setup_initial_messages

      @room.listen
    end

    def handle_shutdown(args)
      close
    end

    def setup_initial_messages
      @room.recent(limit: 50).each do |m|
        EventDispatcher.dispatch(:message, m)
      end
    end
    
    def setup_events
      EventDispatcher.register(self, :shutdown, :handle_shutdown)
      EventDispatcher.register(self, :switch_room, :switch_room)
    end 

    def destroy_events
      EventDispatcher.unregister(self, :shutdown)
      EventDispatcher.unregister(self, :switch_room)
    end
  end
end
