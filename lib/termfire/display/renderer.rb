require "ncurses"
require "termfire/display/chat_renderer"
require "termfire/display/input_renderer"
require "termfire/event_dispatcher"

module Termfire::Display
  class Renderer

    def initialize
      @room_name = ""
      do_setup

      @chat = ChatRenderer.new
      @input = InputRenderer.new
    end
      
    def update(args)
      @chat.update
      @input.update
      draw_line
      draw_header
    end

    def resize(args)
      @chat.resize
      @input.resize
      draw_line
      draw_header
    end

    def close
      @chat.close
      @input.close
      destroy_events
      Ncurses.endwin
    end

    private

    def draw_header
      Ncurses.attron(Ncurses::A_BOLD)
      Ncurses.stdscr.mvhline(0, 0, "-".ord, Ncurses::COLS())
      Ncurses.stdscr.mvprintw(0, 3, "[%s]", @room_name)
      Ncurses.attroff(Ncurses::A_BOLD)
      Ncurses.stdscr.refresh
    end

    def draw_line
      Ncurses.attron(Ncurses::A_BOLD)
      Ncurses.stdscr.mvhline(Ncurses::LINES() - 2, 0, "_".ord, Ncurses::COLS())
      Ncurses.attroff(Ncurses::A_BOLD)
      Ncurses.stdscr.refresh
    end

    def changed_room(args)
      room = args.first
      @room_name = room.name
      Termfire::EventDispatcher.dispatch(:update_ui)
    end

    def do_setup
      setup_events
      Ncurses.initscr
      Ncurses.cbreak
      Ncurses.keypad(Ncurses.stdscr, true)
      Ncurses.noecho
      Ncurses.start_color
      Ncurses.nodelay(Ncurses.stdscr, true)
      Ncurses.init_color(Ncurses::COLOR_BLACK, 0, 0, 0)
      Ncurses.use_default_colors
      Ncurses.curs_set(0)
      draw_line
      draw_header
    end

    def setup_events
      Termfire::EventDispatcher.register(self, :update_ui, :update)
      Termfire::EventDispatcher.register(self, :resize, :resize)
      Termfire::EventDispatcher.register(self, :changed_room, :changed_room)
    end

    def destroy_events
      Termfire::EventDispatcher.unregister(self, :update_ui)
      Termfire::EventDispatcher.unregister(self, :resize)
      Termfire::EventDispatcher.unregister(self, :changed_room)
    end

  end
end
