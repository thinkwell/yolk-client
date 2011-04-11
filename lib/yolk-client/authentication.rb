module Yolk
  module Authentication
    private
    def authentication
      {
        :consumer_key => consumer_key,
        :consumer_secret => consumer_secret
      }
    end

    def authenticated?
      authentication.values.all?
    end
  end
end