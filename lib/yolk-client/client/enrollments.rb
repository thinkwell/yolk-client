
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

      private
      def prepare_enrollments enrollments
        enrollments.each do |e|
          e.start_date = Time.parse(e.start_date) if e.start_date
          e.end_date = Time.parse(e.end_date) if e.end_date
        end
        enrollments
      end

    end
  end
end