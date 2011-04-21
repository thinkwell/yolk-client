require 'time'
module Yolk
  class Client
    # Defines all api calls related to enrollments
    module Enrollments

      def enrollments options = {}
        search = options.delete :search
        search.each_pair{|k,v| options["search[#{k}]"] = v} if search
        response = get('enrollments', options)
        prepare_enrollments response
      end

      def enrollments_by_user user, options = {}
        enrollments(options.merge({"search[relevant_to_user]" => user}))
      end

      def enrollment uuid
        response = get("enrollments/#{uuid}")
        prepare_enrollment(response)
      end

      def enrollment_create enrollment
        response = post('enrollments', {:enrollment => enrollment})
        prepare_enrollment(response)
      end

      def enrollment_update uuid, enrollment
        put("enrollments/#{uuid}", {:enrollment => enrollment})
      end

      def enrollment_destroy uuid
        delete("enrollments/#{uuid}")
      end

      private
      def prepare_enrollments enrollments
        enrollments.each {|e| prepare_enrollment e }
        enrollments
      end
      def prepare_enrollment enrollment
        enrollment.start_date &&= Time.parse(enrollment.start_date)
        enrollment.end_date &&= Time.parse(enrollment.end_date)
        enrollment
      end

    end
  end
end