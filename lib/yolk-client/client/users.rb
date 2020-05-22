require 'yolk-client/models/user'

module Yolk
  class Client

    # Defines all api calls related to users
    module Users
      def authenticate_user username, password
        response = post("users/login", {:entity => {:username => username, :password => password}})
        Yolk::Models::User.new(response)
      end

      def get_user username
        response = get("users/#{username}", {}, false, false)
        Yolk::Models::User.new(response)
      end

      def add_user user_data
        response = post("/users", {:user => user_data})
        Yolk::Models::User.new(response)
      end

      def get_user_by_token token
        response = get("/users/tokens/#{token}", {}, false, false)
        Yolk::Models::User.new(response)
      end

      def update_user username, attributes
        response = put("/users/#{username}", {:user => attributes}, false, false)
        Yolk::Models::User.new(response)
      end

      def update_user_password username, password
        response = put("/users/#{username}/password", {:password => password})
        Yolk::Models::User.new(response)
      end

      def delete_user username
        response = delete("/users/#{username}", {}, false, false)
        Yolk::Models::User.new(response)
      end

      def get_user_token username
        response = get("/users/#{username}/token")
        response && response["token"]
      end

      def invalidate_user_token token
        response = delete("/users/tokens/#{token}", {}, false, false)
        response
      end

      def create_user_token username
        response = post("/users/#{username}/token")
        response && response["token"]
      end

      def is_group_member?(group, username)
        begin
          user = get_user(username)
          user.groups && user.groups.include?(group)
        rescue StandardError => error
          return false
        end
      end

      def is_valid_user_token? token
        begin
          user = get_user_by_token token
          !!user
        rescue StandardError => error
          return false
        end
      end

      private
    end
  end
end
