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

      def organization_courses organization_id
        response = get("organizations/#{organization_id}/courses")
        response
      end

      def organization_sections organization_id
        response = get("organizations/#{organization_id}/all_sections")
        response
      end

      def organization_terms organization_id
        response = get("organizations/#{organization_id}/terms")
        response
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

      def lms_synchronized org_id, course_id, section_id
        return unless org_id && course_id && section_id
        put("organizations/#{org_id}/courses/#{course_id}/sections/#{section_id}/lms_synchronized")
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
