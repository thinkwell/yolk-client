require 'spec_helper'

describe Yolk::Client do
  def get_test_enrollment
    client.enrollments(:search => {:limit_results => 1}).first
  end
  describe "errors" do
    use_vcr_cassette
    it "should a unauthorized error when credentials are incorrect" do
      client = Yolk::Client.new(:consumer_key => 'invalid', :consumer_secret => 'invalid', :endpoint => 'http://localhost:3000')
      lambda{client.enrollments(:search => {:limit_results => 20})}.should raise_error Yolk::Unauthorized
    end
    it "should throw not found error for nonexistant uuid" do
      lambda{client.enrollment('nonexistant')}.should raise_error Yolk::NotFound
      lambda{client.enrollment_destroy('nonexistant')}.should raise_error Yolk::NotFound
    end
    it "should throw unprocessable entity when there are validation errors" do
      lambda{client.enrollment_create({:owner => "blah@test.com"})}.should raise_error(Yolk::UnprocessableEntity){|error|
        error.body['section'].should == ["can't be blank"]
        error.body.should have(1).keys
      }
    end
  end
  describe "enrollments" do
    use_vcr_cassette
    context "with only limit of 20" do
      before do
        @organizations = client.enrollments :search => {:limit_results => 20}
      end
      it "should only return up to the limit" do
        @organizations.count.should == 20
      end
      it "should return Yolk::Model objects" do
        @organizations.all?{|e| e.should be_instance_of Yolk::Model}
        @organizations.all?{|e| e.should be_a Hashie::Rash}
      end
      it "should return actual Time objects instead of strings" do
        @organizations.reject{|e| e.start_date.nil? || e.end_date.nil?}.
            all?{|e| e.start_date.should be_a Time; e.end_date.should be_a Time}
      end
    end
    context "with relevant_to_user passed" do
      it "should return only enrollments for that user" do
        enrollments = client.enrollments :search => {:relevant_to_user => "admin@thinkwell.com"}
        enrollments.should_not be_empty
        enrollments.all?{|e| [e.owner, e.assigned_to].should include "admin@thinkwell.com"}
        same = client.enrollments_by_user "admin@thinkwell.com"
        same.should == enrollments
      end
    end
    context "with owner passed" do
      it "should return only enrollments for that owner" do
        enrollments = client.enrollments :search => {:owner => "admin@thinkwell.com"}
        enrollments.should_not be_empty
        enrollments.all?{|e| e.owner.should == "admin@thinkwell.com"}
      end
    end
    context "with state" do
      it "should return active enrollments" do
        enrollments = client.enrollments :search => {:state => :active, :limit_results => 20}
        enrollments.all?{|e| !e.assigned_to.nil? && e.end_date > Time.now}
      end
      it "should return expired enrollments" do
        enrollments = client.enrollments :search => {:state => :expired, :limit_results => 20}
        enrollments.all?{|e| e.end_date < Time.now}
      end
    end
  end
  describe "enrollment" do
    use_vcr_cassette
    it "should be found by its UUID" do
      uuid = (test_enrollment = get_test_enrollment).uuid
      enrollment = client.enrollment(uuid)
      enrollment.should be_a Hashie::Mash
      enrollment.uuid.should == uuid
      enrollment.should == test_enrollment
    end
    specify "uuid can be accessed through _id or id accessors" do
      enrollment = get_test_enrollment
      enrollment._id.should == enrollment.uuid
      enrollment.id.should == enrollment.uuid
    end
  end
  describe "enrollment_create" do
    use_vcr_cassette
    it "should return the enrollment created" do
      product_id = "f479d240bf7b012da3914040185a8c5f"
      enrollment = client.enrollment_create({:owner => "blah@test.com", :rid => product_id})
      enrollment.product.rid.should == product_id
      enrollment._id.should == enrollment.uuid
      enrollment.product.title.should == "Calculus"
      enrollment.section_id.should_not be nil
    end
  end
  describe "enrollment_update" do
    use_vcr_cassette
    it "should update enrollment" do
      uuid = (test_enrollment = get_test_enrollment).uuid
      length = (test_enrollment.access_length || rand(6)) + 1
      response = client.enrollment_update uuid, {:access_unit => "month", :access_length => length}
      response.should == {}

      updated_enrollment = client.enrollment uuid
      updated_enrollment.owner.should == test_enrollment.owner
      updated_enrollment.product.rid.should == test_enrollment.product.rid
      updated_enrollment.access_length.should == length
    end
    it "should throw validation errors on invalid update" do
      uuid = get_test_enrollment.uuid
      # Use a fixed to date (2010-10-10) to avoid VCR recording multiple fixtures
      now = Time.at(1286686800)
      now = (now + now.gmtoff).gmtime
      # Format date by hand to avoid 1.8 vs 1.9 formatting issues
      start_date = now.strftime '%Y-%m-%d %H:%M:%S %Z'
      end_date = (now - (60*60*24)).strftime '%Y-%m-%d %H:%M:%S %Z'
      start_date.gsub!(/GMT/, 'UTC')
      end_date.gsub!(/GMT/, 'UTC')
      lambda{
        client.enrollment_update uuid, {:start_date => start_date, :end_date => end_date}
      }.should raise_error(Yolk::UnprocessableEntity){|e|
        Time.parse(e.body['end_date'].first.match(/^must be after (.*)$/)[1]).should == now
      }
    end
  end
  describe "enrollment_destroy" do
    use_vcr_cassette
    it "should destroy enrollment" do
      uuid = get_test_enrollment.uuid

      client.enrollment_destroy(uuid)
      lambda{client.enrollment(uuid)}.should raise_error(Yolk::NotFound)
    end
  end
end