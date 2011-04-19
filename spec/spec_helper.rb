# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'

require 'rubygems'
require 'vcr'
require 'forgery'

require 'yolk-client'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.join(__FILE__, 'support', '**', '*.rb')].each {|f| require f}

VCR.config do |c|
  c.cassette_library_dir     = 'spec/cassettes'
  c.stub_with                :webmock
  c.default_cassette_options = {:record => :new_episodes, :match_requests_on => [:method, :uri, :headers, :body]}

  c.before_record do |i|
    i.request.headers['x-api-timestamp'] = /^[0-9]{10}$/
    i.request.headers['x-api-signature'] = /^[0-9a-f]{32}$/
  end
end

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  config.mock_with :rr
  #config.mock_with :rspec

  config.extend VCR::RSpec::Macros
end