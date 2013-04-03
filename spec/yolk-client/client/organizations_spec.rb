require 'spec_helper'

describe Yolk::Client do
  def get_test_organization
    client.organization TEST_ORGANIZATION
  end
  def get_test_courses
    client.organization_courses TEST_ORGANIZATION
  end
  describe "organizations" do
    use_vcr_cassette
    context "with no limit set" do
      before do
        @organizations = client.organizations
      end
      #it "should only return 50" do
      #  @organizations.count.should == 50
      #end
      it "should return Yolk::Model objects" do
        @organizations.all?{|o| o.should be_instance_of Yolk::Model}
        @organizations.all?{|o| o.should be_a Hashie::Rash}
      end
      it "should return actual organizations" do
        @organizations.all?{|o| [:name, :state, :city].each{|k| o.should respond_to(k) }}
      end
    end
  end
  describe "organization" do
    use_vcr_cassette
    it "should be found by its ID" do
      id = (test_organization = get_test_organization).id
      organization = client.organization(id)
      organization.should be_a Hashie::Rash
      organization.id.should == id
      organization.should == test_organization
    end
    specify "id can be accessed through id accessor" do
      organization = get_test_organization
      organization.id.should == organization.id
    end
  end
  describe "organizations_sections" do
    use_vcr_cassette "Yolk_Client/organizations"
    it "should return the sections for the organizations" do
      sections = [Yolk::Model.new(:active=>true,:end_at=>"2038-01-19T03:14:07-06:00",:id=>"4fa0237625f8c653f0000005", :instructor=>"Professor Test", :name=>"Test Section", :registration_end_at=>"2038-01-19T03:14:07-06:00", :registration_start_at=>"2012-05-01T12:55:02-05:00", :rid=>"calctest", :start_at=>"2012-05-01T12:55:02-05:00")]
      client.organizations_sections.should =~ sections
    end
  end
  describe "course_update" do
    use_vcr_cassette
    it "should update a course" do
      test_org = get_test_organization
      test_courses = get_test_courses
      test_course = test_courses.first
      test_course.name.should_not be_empty
      new_name = "Course UPDATED"
      response = client.course_update test_org.id, {:id => test_course.id, :name => new_name}
      response.should == Yolk::Model.new(:hippo_course_id=>"4f72461c8ed7df1d79000347", :id=>"512e3c3c7070d821d7000001", :name=>"Course UPDATED", :organization_id=>"#{TEST_ORGANIZATION}", :product_id=>"4fc68f048ed7df4484000007", :rid=>"")
    end
  end
end
