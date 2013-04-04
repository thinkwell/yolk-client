require 'time'
module Yolk
  class Client
    # Defines all api calls related to enrollments
    module Users

      def user uuid
        response = get("crowd/users/#{uuid}")
        response
      end
    end
  end
end
