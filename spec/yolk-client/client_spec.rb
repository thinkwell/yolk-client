require 'spec_helper'

describe Yolk::Client do
  before do
    @keys = Yolk::Configuration::VALID_OPTIONS_KEYS
  end
  after do
    Yolk.reset
  end
  describe "configuration" do
    it "copies default values to client" do
      key = Forgery::Basic.password
      secret = Forgery::Basic.password
      Yolk.configure do |c|
        c.consumer_key = key
        c.consumer_secret = secret
      end
      client = Yolk::Client.new
      client.consumer_key.should == key
      client.consumer_secret.should == secret
      client.endpoint.should == Yolk::Configuration::DEFAULT_ENDPOINT
    end
    it "should override default values with initialize options" do
      client = Yolk::Client.new({:endpoint => "myendpoint.com"})
      client.endpoint.should_not == Yolk::Configuration::DEFAULT_ENDPOINT
      client.endpoint.should == "myendpoint.com"
    end
  end

  it "should build a valid faraday connection" do
    connection = Yolk::Client.new.send(:connection)
    connection.should be_instance_of(Faraday::Connection)
  end

  it "should connect using the endpoint configuration" do
    client = Yolk::Client.new
    endpoint = URI.parse(client.endpoint)
    connection = client.send(:connection).build_url(nil).to_s
    connection.should == endpoint.to_s
  end
end