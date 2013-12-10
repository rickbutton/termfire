require "termfire/display/renderer"

module Termfire::Display
  class Terminal
    def initialize
      @renderer = Renderer.new
    end

    def close
      @renderer.close
    end
  end
end
