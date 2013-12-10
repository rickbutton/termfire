module Termfire::Display
  class ColorManager

    @@sem = Mutex.new
    @@next_pair = 1
    @@cache = {}

    def self.new_color_pair(fore_sym, back_sym)
      return @@cache["#{fore_sym}#{back_sym}"] if @@cache["#{fore_sym}#{back_sym}"]
      @@sem.lock
      pair = @@next_pair
      fore = symbol_to_color(fore_sym)
      back = symbol_to_color(back_sym)
      Ncurses.init_pair(pair, fore, back)
      @@next_pair += 1
      @@cache["#{fore_sym}#{back_sym}"] = pair
      @@sem.unlock
      pair
    end

    private

    def self.symbol_to_color(sym)
      case sym
      when :black
        Ncurses::COLOR_BLACK
      when :red
        Ncurses::COLOR_RED
      when :green
        Ncurses::COLOR_GREEN
      when :yellow
        Ncurses::COLOR_YELLOW
      when :blue
        Ncurses::COLOR_BLUE
      when :magenta
        Ncurses::COLOR_MAGENTA
      when :cyan
        Ncurses::COLOR_CYAN
      when :white
        Ncurses::COLOR_WHITE
      when :default
        -1
      else
        raise "invalid color #{sym}"
      end
    end
  end
end
