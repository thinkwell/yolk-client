module Yolk
  class Client
    # Defines all api calls related to courses
    module Courses
      def course id
        response = get("courses/#{id}")
        response
      end

      def course_sections organization_id, course_id
        response = get("organizations/#{organization_id}/courses/#{course_id}/sections")
        response
      end

      private
    end
  end
end
