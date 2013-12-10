require "termfire/display/color_manager"
require "pp"

module Termfire::Display
  class MessageFormatter

    MAX_FIRST_SIZE = 10
    NAME_SIZE = MAX_FIRST_SIZE + 3

    def initialize(message)
      @message = message
      @name_color = ColorManager.new_color_pair(:green, :default)
      @text_color = ColorManager.new_color_pair(:default, :default)
      @time_color = ColorManager.new_color_pair(:blue, :default)
    end

    def draw_data
      type = @message["type"]
      case type
      when "KickMessage"
        kick_message(@message)
      when "EnterMessage"
        enter_message(@message)
      when "TextMessage"
        text_message(@message)
      when "TimestampMessage"
        timestamp_message(@message)
      end
    end

    def should_draw?
      true
    end

    private

    def kick_message(message)
      name = format_name(message["user"]["name"])
      [
        { text: name, color: @name_color },
        { text: "| has left the room", color: @text_color },
      ]
    end

    def enter_message(message)
      name = format_name(message["user"]["name"])
      [
        { text: name, color: @name_color },
        { text: "| has entered the room", color: @text_color },
      ]
    end

    def text_message(message)
      name = format_name(message["user"]["name"])
      body = message["body"]
      [
        { text: "#{name}", color: @name_color },
        { text: "| #{body}", color: @text_color },
      ]
    end

    def timestamp_message(message)
      time = "#{message["created_at"].strftime("%I:%M %p")}"
      [
        {text:"#{" " * NAME_SIZE}|\n     ", color: @text_color},
        {text: time, color: @time_color},
        {text:"|", color: @text_color},
      ]
    end

    def format_name(name)
      names = name.split
      first = names.first
      last  = names[1..-1].map { |n| n[0,1] }.join("")
      formatted_name = "#{first[0...MAX_FIRST_SIZE]} #{last}."
      missing_spaces = NAME_SIZE - formatted_name.length
      (" " * missing_spaces) + formatted_name
    end
  end
end
