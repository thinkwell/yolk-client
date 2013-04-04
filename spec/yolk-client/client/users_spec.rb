require 'spec_helper'

describe Yolk::Client do
  def get_test_user
    client.user TEST_USER
  end
  describe "user" do
    use_vcr_cassette
    it "should be found by its UUID" do
      id = (test_user = get_test_user).id
      user = client.user(id)
      user.should be_a Hashie::Rash
      user.id.should == id
      user.should == test_user
    end
  end
end
