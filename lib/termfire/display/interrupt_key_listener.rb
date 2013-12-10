require "ncurses"
require "termfire/event_dispatcher"

module Termfire::Display
  class InterruptKeyListener
    def initialize(win = nil)
      @run = true
      @win = win
    end

    def start
      while @run do
        if @win
          c = @win.getch
        else
          c = Ncurses.getch
        end

        case c
        when 3 # Ctrl-C
          Termfire::EventDispatcher.dispatch(:shutdown)
        when Ncurses::KEY_RESIZE
          Termfire::EventDispatcher.dispatch(:resize)
        when 18 # Ctrl-R
          Termfire::EventDispatcher.dispatch(:switch_room, c)
        else
          Termfire::EventDispatcher.dispatch(:key, c)
        end
      end
    end

    def stop
      @run = false
    end
  end
end
