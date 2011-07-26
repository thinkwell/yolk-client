require 'spec_helper'

describe Yolk::Client do
  def get_test_organization
    client.organizations(:search => {:limit_results => 1}).first
  end
  def get_test_organization_with_course
    attempt = 0
    begin
      organization = client.organizations(:search => {:limit_results => 1}).detect{|o| !o.courses.blank?}
      attempt += 1
    end until organization || attempt == 3
    organization
  end
  describe "organizations" do
    use_vcr_cassette
    context "with no limit set" do
      before do
        @organizations = client.organizations
      end
      it "should only return 50" do
        @organizations.count.should == 50
      end
      it "should return Yolk::Model objects" do
        @organizations.all?{|o| o.should be_instance_of Yolk::Model}
        @organizations.all?{|o| o.should be_a Hashie::Rash}
      end
      it "should return actual organizations" do
        @organizations.all?{|o| [:name, :state, :city, :url].each{|k| o.should respond_to(k) }}
      end
    end
  end
  describe "organization" do
    use_vcr_cassette
    it "should be found by its ID" do
      id = (test_organization = get_test_organization)._id
      organization = client.organization(id)
      organization.should be_a Hashie::Rash
      organization._id.should == id
      organization.should == test_organization
    end
    specify "_id can be accessed through id accessor" do
      organization = get_test_organization
      organization.id.should == organization._id
    end
  end
  describe "organizations_sections" do
    use_vcr_cassette "Yolk_Client/organizations"
    it "should return the sections for the organizations" do
      organizations = client.organizations
      sections = client.organizations.map(&:courses).flatten.map(&:sections).flatten.compact
      client.organizations_sections.should =~ sections
    end
  end
  describe "course_update" do
    use_vcr_cassette
    it "should update a course" do
      test_org = get_test_organization_with_course
      test_course = test_org.courses.sample
      test_course.name.should_not be_blank
      new_name = "Course UPDATED"
      response = client.course_update test_org.id, {:_id => test_course.id, :name => new_name}
      response.should == {}
      org = client.organization test_org.id
      org.should_not be_nil
      updated_course = org.courses.detect{|c| c.id == test_course.id}
      updated_course.should_not be_nil
      updated_course.name.should == new_name
      updated_course.name.should_not == test_course.name
    end
  end
end