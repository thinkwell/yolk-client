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