require 'spec_helper'

describe Yolk::Client do
  def get_test_course
    client.course TEST_COURSE
  end
  describe "course" do
    use_vcr_cassette
    it "should be found by its ID" do
      id = (test_course = get_test_course).id
      course = client.course(id)
      course.should be_a Hashie::Mash
      course.id.should == id
      course.should == test_course
    end
  end
  describe "course_sections" do
    use_vcr_cassette
    it "should return the sections for the course" do
      sections = [Yolk::Model.new(:content_source=>"512e3c677070d821d7000002", :course_id=>"#{TEST_COURSE}", :embedded_course_id=>"512e3c3c7070d821d7000001", :end_at=>"2013-09-22T22:59:00-06:00", :id=>"514c918c7070d83882000009", :last_lms_sync=>"2013-03-22T11:19:01-06:00", :name=>"section 13 copy 23", :organization_id=>"#{TEST_ORGANIZATION}", :registration_end_at=>nil, :registration_start_at=>nil, :rid=>nil, :start_at=>"2013-03-21T23:00:00-06:00", :term_id=>nil),
                  Yolk::Model.new(:content_source=>nil, :course_id=>"#{TEST_COURSE}", :embedded_course_id=>"512e3c3c7070d821d7000001", :end_at=>"2013-02-19T23:59:00-06:00", :id=>"512e3c677070d821d7000002", :last_lms_sync=>"2013-03-22T11:16:10-06:00", :name=>"section 13 edited", :organization_id=>"#{TEST_ORGANIZATION}", :registration_end_at=>nil, :registration_start_at=>nil, :rid=>nil, :start_at=>"2013-02-06T00:00:00-06:00", :term_id=>nil)]
      client.course_sections(TEST_ORGANIZATION, TEST_COURSE).should =~ sections
    end
  end
end
