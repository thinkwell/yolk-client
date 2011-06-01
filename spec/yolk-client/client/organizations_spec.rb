require 'spec_helper'

describe Yolk::Client do
  def get_test_organization
    client.organizations(:search => {:limit_results => 1}).first
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
end