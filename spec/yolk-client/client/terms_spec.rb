require 'spec_helper'

describe Yolk::Client do
  def get_test_term
    client.term TEST_TERM
  end
  describe "term" do
    use_vcr_cassette
    it "should be found by its ID" do
      id = (test_term = get_test_term).id
      term = client.term(id)
      term.should be_a Hashie::Mash
      term.id.should == id
      term.should == test_term
    end
  end
end
