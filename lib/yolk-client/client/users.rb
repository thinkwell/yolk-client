require 'yolk-client/models/user'

module Yolk
  class Client
    # Defines all api calls related to users
    module Users
      def authenticate_user username, password
        response = post("users/login", {:entity => {:username => username, :password => password}})
        Yolk::Client::User.new(response)
      end

      def get_user username
        response = get("users/#{username}")
        Yolk::Client::User.new(response)
      end

      def add_user user_data
        response = post("/users", {:user => user_data})
        Yolk::Client::User.new(response)
      end

      def get_user_token username
        response = get("/users/#{username}/token")
        response
      end

      def invalidate_user_token token
        response = delete("/users/tokens/#{token}")
        response
      end

      def get_user_by_token token
        response = get("/users/tokens/#{token}")
        Yolk::Client::User.new(response)
      end

      def update_user username, attributes
        response = put("/users/#{username}", {:user => attributes})
        Yolk::Client::User.new(response)
      end

      def update_user_password username, password
        response = put("/users/#{username}/password", {:password => password})
        Yolk::Client::User.new(response)
      end

      def delete_user username
        response = delete("/users/#{username}")
        Yolk::Client::User.new(response)
      end

      def is_group_member?(group, username)
        user = get_user(username)
        user && user.groups && user.groups.include?(group)
      end

      def is_valid_user_token? token
        user = get_user_by_token token
        !!user
      end

      private
    end
  end
end
