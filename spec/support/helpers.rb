def client
  @client = Yolk::Client.new(:consumer_key => '4d9f75499a768f299e000002', :consumer_secret => 'test',
                               :endpoint => 'http://localhost:3000/')
end
def last_response_time
  Time.parse(Rspec.configuration.last_kept_response.headers['date'].first)
end