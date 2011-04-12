
module Yolk
  class Client
    # Defines all api calls related to enrollments
    module Enrollments

      def enrollments *args
        options = args.last.is_a?(Hash) ? args.pop : {}
        response = get('enrollments', options)
        response
      end

    end
  end
end