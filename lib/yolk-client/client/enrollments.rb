
module Yolk
  class Client
    # Defines all api calls related to enrollments
    module Enrollments

      def enrollments *args
        options = args.last.is_a?(Hash) ? args.pop : {}
        search = options.delete :search
        search.each_pair{|k,v| options["search[#{k}]"] = v} if search
        response = get('enrollments', options)
        prepare_enrollments response
      end

      def enrollment_create enrollment
        response = post('enrollments', {:enrollment => enrollment})
        prepare_enrollment(response)
      end

      private
      def prepare_enrollments enrollments
        enrollments.each {|e| prepare_enrollment e }
        enrollments
      end
      def prepare_enrollment enrollment
        enrollment.start_date = Time.parse(enrollment.start_date) if enrollment.start_date
        enrollment.end_date = Time.parse(enrollment.end_date) if enrollment.end_date
        enrollment
      end

    end
  end
end