require 'spec_helper'

describe Yolk::Client do
  before do
    @client = Yolk::Client.new(:consumer_key => '4d9f75499a768f299e000002', :consumer_secret => 'test',
                               :endpoint => 'http://localhost:3000/')
  end
  describe "enrollments" do
    use_vcr_cassette
    context "with relevant_to_user passed" do
      it "should return only enrollments for that user" do
        enrollments = @client.enrollments :search => {:relevant_to_user => "admin@thinkwell.com"}
        enrollments.should_not be_empty
        enrollments.all?{|e| [e.owner, e.assigned_to].should include "admin@thinkwell.com"}
      end
    end
    context "with owner_equals passed" do
      it "should return only enrollments for that owner" do
        enrollments = @client.enrollments :search => {:owner_equals => "admin@thinkwell.com"}
        enrollments.should_not be_empty
        enrollments.all?{|e| e.owner.should == "admin@thinkwell.com"}
      end
    end
    context "with limit" do
      it "should only return the limit of enrollments" do
        enrollments = @client.enrollments :search => {:limit_results => 20}
        enrollments.count.should == 20
      end
    end
    context "with state" do
      it "should return active enrollments" do
        enrollments = @client.enrollments :search => {:state => :active, :limit_results => 20}
        enrollments.all?{|e| !e.assigned_to.nil? && e.end_date > Time.now}
      end
      it "should return expired enrollments" do
        enrollments = @client.enrollments :search => {:state => :expired, :limit_results => 20}
        enrollments.all?{|e| e.end_date < Time.now}
      end
    end
  end
end