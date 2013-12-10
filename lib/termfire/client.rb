require "tinder"

module Termfire
  class Client

    def initialize(subdomain, options = {})
      unless options[:token]
        raise "You must supply a token"
      end

      @campfire = Tinder::Campfire.new subdomain, token: options[:token]
    end

    def rooms
      @campfire.rooms
    end
  end
end
