require 'time'
module Yolk
  class Client
    # Defines all api calls related to enrollments
    module Enrollments

      def enrollments options = {}
        format_search_options options
        response = get('enrollments', options)
        prepare_enrollments response
      end

      def enrollments_by_user user, options = {}
        format_search_options options
        options.merge! "search[limit_results]" => 0 unless options["search[limit_results]"]
        response = get("users/#{user}/enrollments", options)
        prepare_enrollments response
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
        # Parse dates
        enrollment.select{|k, v| v && k =~ /_(date|at)$/}.
            each{|k, v| enrollment.send(:"#{k}=", Time.parse(v))}
        enrollment
      end
      def format_search_options options
        search = options.delete :search
        search.each_pair{|k,v| options["search[#{k}]"] = v} if search
      end
    end
  end
end