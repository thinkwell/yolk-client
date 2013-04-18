module Yolk
  class Client
    # Defines all api calls related to sections
    module Sections
      def section id
        response = get("sections/#{id}")
        response
      end

      private
    end
  end
end
