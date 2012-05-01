def client
  @client = Yolk::Client.new(
    :consumer_key => TEST_CONSUMER_KEY,
    :consumer_secret => TEST_CONSUMER_SECRET,
    :endpoint => 'http://localhost:3000/'
  )
end
