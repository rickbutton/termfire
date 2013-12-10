require "ncurses"

module Termfire::Display
  class InputRenderer
    def initialize
      @current_text = ""
      do_setup
      setup_events
    end

    def update
      @win.refresh
    end

    def close
      Ncurses.delwin(@win)      
      destroy_events
    end

    def resize
      #lines, cols = TermInfo.screen_size
      #@win.resize lines, cols
      draw_prompt
      redraw_input
      update
    end

    def redraw_input
      @win.mvaddstr(0, @current_text.length - 1 + 3, @current_text)
    end

    private

    def process_key(args)
      key = args.first

      case key
      when Ncurses::ERR
        Thread.pass
      when 10 # enter
        if @current_text.length != 0
          Termfire::EventDispatcher.dispatch(:send_message, @current_text)
          @current_text = ""
          @win.erase
          draw_prompt
        end
      when 127 # backspace
        if @current_text.length != 0
          length = @current_text.length
          @current_text = @current_text[0...-1]
          @win.mvaddch(0, length - 1 + 3, " ".ord)
          @win.move(0, length + 3 - 1)
        end
      else
        length = @current_text.length
        @current_text += key.chr
        @win.mvaddch(0, length + 3, key)
      end
    end

    def draw_prompt
      @win.mvaddstr(0, 0, ">>>")
    end

    def do_setup
      @win = Ncurses::WINDOW.new(
        1,
        0,
        Ncurses.LINES() - 1,
        0
      )
      draw_prompt
      @interrupt_key_listener = InterruptKeyListener.new(@win)
      Thread.new do
        @interrupt_key_listener.start
      end
    end

    def setup_events
      Termfire::EventDispatcher.register(self, :key, :process_key)
    end

    def destroy_events
      Termfire::EventDispatcher.unregister(self, :key)
    end
  end
end
