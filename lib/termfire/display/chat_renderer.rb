require "termfire/event_dispatcher"
require "termfire/display/interrupt_key_listener"
require "termfire/display/message_formatter"
require "termfire/display/color_manager"
require "termfire/event_dispatcher"

module Termfire::Display
  class ChatRenderer
    def initialize
      @messages = []
      @current_line = 0
      do_setup
      update
    end

    def close
      Ncurses.delwin(@win)
      @interrupt_key_listener.stop
      destroy_events
    end

    def update
      @win.refresh
    end

    def resize
      #ines, cols = TermInfo.screen_size
      #@win.resize lines,cols
      redraw
      update
    end

    def redraw
      @current_line = 0
      @messages.each do |message|
        draw_message(message)
      end
    end

    def clear(args)
      @messages = []
      @win.erase
      @win.refresh
    end

    private

    def process_message(args)
      message = args.first
      @messages << message
      draw_message(message)
    end

    def draw_message(message)
      formatter = MessageFormatter.new(message)
      return unless formatter.should_draw?

      draw_data = formatter.draw_data
      @win.printw("\n")
      draw_data.each do |data|
        attr = Ncurses::A_BOLD | Ncurses.COLOR_PAIR(data[:color])
        @win.attrset(attr)
        @win.attron(attr)
        @win.printw("%s", data[:text])
        @win.attroff(attr)
      end

      @win.clrtoeol

      @current_line += 1
      Termfire::EventDispatcher.dispatch(:update_ui)
    end

    def do_setup
      setup_events
      @win = Ncurses::WINDOW.new(
        Ncurses.LINES() - 3,
        0,
        1,
        0
      )
      Ncurses.nodelay(@win, true)
      Ncurses.scrollok(@win, true)
      #@interrupt_key_listener = InterruptKeyListener.new(@win)
      #Thread.new do
      #  @interrupt_key_listener.start
      #end
    end

    def setup_events
      Termfire::EventDispatcher.register(self, :message, :process_message)
      Termfire::EventDispatcher.register(self, :chat_clear, :clear)
    end

    def destroy_events
      Termfire::EventDispatcher.unregister(self, :message)
      Termfire::EventDispatcher.unregister(self, :chat_clear)
    end
  end
end
