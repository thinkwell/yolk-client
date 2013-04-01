module Yolk
  class Client
    # Defines all api calls related to terms
    module Terms
      def term id
        response = get("terms/#{id}")
        prepare_term response
      end

      private
      def prepare_term term
        # Do nothing for now
        term
      end

    end
  end
end
