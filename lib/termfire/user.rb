module Termfire
  class User
    def initialize(user)
      @user = user
    end

    def name
      @user["name"]
    end
  end
end
