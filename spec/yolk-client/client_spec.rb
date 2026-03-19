require 'spec_helper'

describe YolkClient::Client do
  before do
    @keys = YolkClient::Configuration::VALID_OPTIONS_KEYS
  end
  after do
    YolkClient.reset
  end
  describe "configuration" do
    it "copies default values to client" do
      key = Forgery::Basic.password
      secret = Forgery::Basic.password
      YolkClient.configure do |c|
        c.consumer_key = key
        c.consumer_secret = secret
      end
      client = YolkClient::Client.new
      client.consumer_key.should == key
      client.consumer_secret.should == secret
      client.endpoint.should == YolkClient::Configuration::DEFAULT_ENDPOINT
    end
    it "should override default values with initialize options" do
      client = YolkClient::Client.new({:endpoint => "myendpoint.com"})
      client.endpoint.should_not == YolkClient::Configuration::DEFAULT_ENDPOINT
      client.endpoint.should == "myendpoint.com"
    end
  end

  it "should build a valid faraday connection" do
    connection = YolkClient::Client.new.send(:connection)
    connection.should be_instance_of(Faraday::Connection)
  end

  it "should connect using the endpoint configuration" do
    client = YolkClient::Client.new
    endpoint = URI.parse(client.endpoint)
    connection = client.send(:connection).build_url(nil).to_s
    connection.should == endpoint.to_s
  end
end