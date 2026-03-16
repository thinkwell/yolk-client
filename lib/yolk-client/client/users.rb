module Yolk
  class Client
    # Defines all api calls related to users
    module Users
      # identifier can be email, username or id
      def find_user (identifier)
        response = get("users/#{identifier}")
        Yolk::User.new(response)
      end

      def authenticate_user (username, password)
        response = post("users/login", {:username => username, :password => password})
        response
      end

      def invalidate_user_token (token)
        response = delete("users/token/#{token}")
        response
      end

      def create_user_token (username)
        response = post("users/#{username}/token")
        response
      end

      def find_user_by_token (token)
        response = get("users/token/#{token}")
        Yolk::User.new(response)
      end

      def is_valid_user_token? (token)
        response = get("users/token/#{token}/is_valid")
        response
      end

      def add_user (user)
        response = post("users", {user: user})
        Yolk::User.new(response)
      end

      def update_user (user)
        response = put("users/#{user["id"] || user["username"] || user["email"]}", {user: user})
        Yolk::User.new(response)
      end

      def get_cookie_info
        {:domain=>".thinkwell.com", :secure=>false}
      end

      private
    end
  end
end
