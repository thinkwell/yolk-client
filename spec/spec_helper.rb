# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'

require 'rubygems'
require 'vcr'
require 'forgery'

require 'yolk-client'

TEST_CONSUMER_KEY = '4fa023c325f8c653f0000007'
TEST_CONSUMER_SECRET = 'MySeCRET'
TEST_OWNER = 'test@thinkwell.com'
TEST_ASSIGNED_TO = 'test@thinkwell.com'
TEST_ENROLLMENT = '4fa0234c25f8c653f0000002'
TEST_ORGANIZATION = '4fa0235a25f8c653f0000003'
TEST_SECTION = '4fa0237625f8c653f0000005'
TEST_RID = 'calctest'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.join(File.dirname(__FILE__), 'support', '**', '*.rb')].each {|f| require f}

VCR.configure do |c|
  c.cassette_library_dir     = 'spec/cassettes'
  c.hook_into                :webmock
  c.register_request_matcher :john_hancock_headers do |r1, r2|
    jh_headers = lambda do |key, val|
      (key == 'X-Api-Timestamp' && val[0].to_s =~ /^[0-9]{10}$/) ||
        (key == 'X-Api-Signature' && val[0].to_s =~ /^[0-9a-f]{32}$/)
    end

    (r1.headers.reject &jh_headers) == (r2.headers.reject &jh_headers)
  end
  c.default_cassette_options = {
    #:record => :new_episodes,
    :record => :none,
    :match_requests_on => [:method, :uri, :john_hancock_headers, :body]
  }
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

  config.add_setting :last_kept_response
end
