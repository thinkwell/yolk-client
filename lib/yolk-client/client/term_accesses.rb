module Yolk
  class Client
    # Defines all api calls related to term_accesses
    module TermAccesses
      def term_access id
        response = get("term_accesses/#{id}")
        response
      end

      private
    end
  end
end
