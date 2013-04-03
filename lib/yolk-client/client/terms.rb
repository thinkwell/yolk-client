module Yolk
  class Client
    # Defines all api calls related to terms
    module Terms
      def term id
        response = get("terms/#{id}")
        response
      end

      def term_accesses term_id
        response = get("terms/#{term_id}/term_accesses")
        response
      end

      private
    end
  end
end
