module Yolk
  class Client
    # Defines all api calls related to organizations
    module Organizations
      def organizations options = {}
        format_search_options options
        response = get('organizations', options)
        prepare_organizations response
      end

      def organizations_sections options = {}
        format_search_options options
        response = get('organizations/all_sections', options)
      end

      def organization id
        response = get("organizations/#{id}")
        prepare_organization response
      end

      def course_update org_id, course
        course_id = course && (course[:id])
        return unless org_id && course_id
        put("organizations/#{org_id}/courses/#{course_id}", {:course => course})
      end

      def section_update org_id, course_id, section
        section_id = section && (section[:id])
        return unless org_id && course_id && section_id
        put("organizations/#{org_id}/courses/#{course_id}/sections/#{section_id}", {:section => section})
      end

      private
      def prepare_organizations organizations
        organizations.each {|o| prepare_organization o }
        organizations
      end
      def prepare_organization organization
        # Do nothing for now
        organization
      end
    end
  end
end
