module Yolk
  class Client
    module Utils
      private
      def format_search_options options
        search = options.delete :search
        search.each_pair{|k,v| options["search[#{k}]"] = v} if search
      end
    end
  end
end