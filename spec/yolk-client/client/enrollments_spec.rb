require 'spec_helper'

describe Yolk::Client do
  before do
    @client = Yolk::Client.new(:consumer_key => '4d9f75499a768f299e000002', :consumer_secret => 'test',
                               :endpoint => 'http://localhost:3000/')
  end
  describe "errors" do
    use_vcr_cassette
    it "should a unauthorized error when credentials are incorrect" do
      client = Yolk::Client.new(:consumer_key => 'invalid', :consumer_secret => 'invalid', :endpoint => 'http://localhost:3000')
      lambda{client.enrollments(:search => {:limit_results => 20})}.should raise_error Yolk::Unauthorized
    end
    it "should throw not found error for nonexistant uuid" do
      lambda{@client.enrollment('nonexistant')}.should raise_error Yolk::NotFound
    end
    it "should throw unprocessable entity when there are validation errors" do
      lambda{@client.enrollment_create({:owner => "blah@test.com"})}.should raise_error(Yolk::UnprocessableEntity){|error|
        error.body['product'].should == ["can't be blank"]
      }
    end
  end
  describe "enrollments" do
    use_vcr_cassette
    context "with only limit of 20" do
      before do
        @enrollments = @client.enrollments :search => {:limit_results => 20}
      end
      it "should only return up to the limit" do
        @enrollments.count.should == 20
      end
      it "should return rash objects" do
        @enrollments.all?{|e| e.should be_instance_of Hashie::Rash}
      end
      it "should return actual Time objects instead of strings" do
        @enrollments.all?{|e| e.start_date.should be_a Time; e.end_date.should be_a Time}
      end
    end
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
  describe "enrollment" do
    use_vcr_cassette
    it "should be found by its UUID" do
      uuid = (test_enrollment = @client.enrollments(:search => {:state => :active, :limit_results => 1}).first).uuid
      enrollment = @client.enrollment(uuid)
      enrollment.should be_a Hashie::Mash
      enrollment.uuid.should == uuid
      enrollment.should == test_enrollment
    end
  end
end