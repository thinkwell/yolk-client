module Yolk
  # Defines HTTP request methods
  module Request
    # Perform an HTTP GET request
    def get(path, options={}, raw=false, format_in_path=true)
      request(:get, path, options, raw, format_in_path)
    end

    # Perform an HTTP POST request
    def post(path, options={}, raw=false, format_in_path=true)
      request(:post, path, options, raw, format_in_path)
    end

    # Perform an HTTP PUT request
    def put(path, options={}, raw=false, format_in_path=true)
      request(:put, path, options, raw, format_in_path)
    end

    # Perform an HTTP DELETE request
    def delete(path, options={}, raw=false, format_in_path=true)
      request(:delete, path, options, raw, format_in_path)
    end

    private

    # Perform an HTTP request
    def request(method, path, options, raw=false, format_in_path=true)
      path_formatted = format_in_path ? formatted_path(path) : path
      response = connection(raw).send(method) do |request|
        case method
        when :get, :delete
          request.url(path_formatted, options)
        when :post, :put
          request.path = path_formatted
          request.body = options unless options.empty?
        end
      end
      raw ? response : response.body
    end

    def formatted_path(path)
      [path, format].compact.join('.')
    end
  end
end
