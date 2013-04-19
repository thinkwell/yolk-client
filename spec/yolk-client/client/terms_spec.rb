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
  describe "term_accesses" do
    use_vcr_cassette
    it "should return the term accesses for the term" do
      term_accesses = [Yolk::Model.new(:end_date=>"2013-09-15T22:59:00-06:00", :id=>"5143488b7070d85c1b000007", :start_date=>"2013-03-14T23:00:00-06:00", :term_id=>"#{TEST_TERM}", :user_role=>"StudentEnrollment"),
                       Yolk::Model.new(:end_date=>"2013-10-16T22:59:00-06:00", :id=>"515ab7cd7070d8109a000001", :start_date=>"2013-04-01T23:00:00-06:00", :term_id=>"#{TEST_TERM}", :user_role=>"TeacherEnrollment")]
      client.term_accesses(TEST_TERM).should =~ term_accesses
    end
  end
end
