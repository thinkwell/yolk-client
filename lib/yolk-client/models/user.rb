module Yolk
  class Models
    class User < OpenStruct
      def username
        super || id || email
      end

      def as_json(options = nil)
        to_h.as_json
      end
    end
  end
end
