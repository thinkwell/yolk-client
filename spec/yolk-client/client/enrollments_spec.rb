require 'spec_helper'

describe Yolk::Client do
  def get_test_enrollment
    client.enrollment TEST_ENROLLMENT
  end
  describe "errors" do
    use_vcr_cassette
    it "should throw an unauthorized error when credentials are incorrect" do
      client = Yolk::Client.new(:consumer_key => 'invalid', :consumer_secret => 'invalid', :endpoint => 'http://localhost:3000')
      lambda{client.enrollments(:search => {:limit_results => 20})}.should raise_error Yolk::Unauthorized
    end
    it "should throw not found error for nonexistant uuid" do
      lambda{client.enrollment('nonexistant')}.should raise_error Yolk::NotFound
      lambda{client.enrollment_destroy('nonexistant')}.should raise_error Yolk::NotFound
    end
    it "should throw unprocessable entity when there are validation errors" do
      lambda{client.enrollment_create({:owner => "blah@test.com"})}.should raise_error(Yolk::UnprocessableEntity){|error|
        error.body['errors']['section'].should == ["can't be blank"]
        error.body.should have(1).keys
      }
    end
  end
  describe "enrollments" do
    use_vcr_cassette
    context "with only limit of 2" do
      before do
        @enrollments = client.enrollments :search => {:limit_results => 2}
      end
      it "should only return up to the limit" do
        @enrollments.count.should == 2
      end
      it "should return Yolk::Model objects" do
        @enrollments.all?{|e| e.should be_instance_of Yolk::Model}
        @enrollments.all?{|e| e.should be_a Hashie::Rash}
      end
      it "should return actual Time objects instead of strings" do
        @enrollments.reject{|e| e.start_at.nil? || e.end_at.nil?}.
            all?{|e| e.start_at.should be_a Time; e.end_at.should be_a Time}
      end
    end
    context "with relevant_to_entity passed" do
      it "should return only enrollments for that entity" do
        enrollments = client.enrollments :search => {:relevant_to_entity => TEST_OWNER}
        enrollments.should_not be_empty
        enrollments.all?{|e| [e.owner, e.assigned_to].should include TEST_OWNER}
        same = client.enrollments_by_entity TEST_OWNER
        same.should == enrollments
      end
    end
    context "with owner passed" do
      it "should return only enrollments for that owner" do
        enrollments = client.enrollments :search => {:owner => TEST_OWNER}
        enrollments.should_not be_empty
        enrollments.all?{|e| e.owner.should == TEST_OWNER}
      end
      specify "enrollments_by_owner" do
        enrollments = client.enrollments_by_owner TEST_OWNER
        enrollments.should_not be_empty
        enrollments.all?{|e| e.owner.should == TEST_OWNER}
      end
    end
    context "with assigned_to passed" do
      it "should return only enrollments for that assignee" do
        enrollments = client.enrollments :search => {:assigned_to => TEST_ASSIGNED_TO}
        enrollments.should_not be_empty
        enrollments.all?{|e| e.assigned_to.should == TEST_ASSIGNED_TO}
      end
      specify "enrollments_by_assignee" do
        enrollments = client.enrollments_by_assignee TEST_ASSIGNED_TO
        enrollments.should_not be_empty
        enrollments.all?{|e| e.assigned_to.should == TEST_ASSIGNED_TO}
      end
    end
    context "with state" do
      it "should return active enrollments" do
        enrollments = client.enrollments :search => {:state => :active, :limit_results => 20}
        enrollments.all? do |e|
          e.assigned_to.should_not be_nil
          e.end_at.should > Time.now
        end
      end
      it "should return expired enrollments" do
        enrollments = client.enrollments :search => {:state => :expired, :limit_results => 20}
        enrollments.all?{|e| e.end_at.should < Time.now}
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
  end
  describe "enrollment_create" do
    use_vcr_cassette
    it "should return the enrollment created" do
      enrollment = client.enrollment_create({:owner => "blah@test.com", :rid => TEST_RID, :section_id => TEST_SECTION})
      # TODO: Fix tests
      #enrollment.product.rid.should == product_id
      #enrollment.product.title.should == "Calculus"
      enrollment.section_id.should_not be nil
    end
  end
  describe "enrollment_update" do
    use_vcr_cassette
    it "should update enrollment" do
      uuid = (test_enrollment = get_test_enrollment).uuid
      length = (test_enrollment.access_length || 5) + 1
      response = client.enrollment_update uuid, {:access_unit => "month", :access_length => length}
      response.should == nil

      updated_enrollment = client.enrollment uuid
      updated_enrollment.owner.should == test_enrollment.owner
      # TODO: Fix test:
      #updated_enrollment.product.rid.should == test_enrollment.product.rid
      updated_enrollment.access_length.should == length
    end
  end
  describe "enrollment_update_invalid" do
    use_vcr_cassette
    it "should throw validation errors on invalid update" do
      uuid = get_test_enrollment.uuid
      # Use a fixed to date (2010-10-10) to avoid VCR recording multiple fixtures
      now = Time.at(1286686800)
      now = (now + now.gmtoff).gmtime
      # Format date by hand to avoid 1.8 vs 1.9 formatting issues
      start_at = now.strftime '%Y-%m-%d %H:%M:%S %Z'
      end_at = (now - (60*60*24)).strftime '%Y-%m-%d %H:%M:%S %Z'
      start_at.gsub!(/GMT/, 'UTC')
      end_at.gsub!(/GMT/, 'UTC')
      lambda{
        client.enrollment_update uuid, {:start_at => start_at, :end_at => end_at}
      }.should raise_error(Yolk::UnprocessableEntity){|e|
        Time.parse(e.body['errors']['end_at'].first.match(/^must be after (.*)$/)[1]).utc.should == now
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
