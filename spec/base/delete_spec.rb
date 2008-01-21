require File.dirname(__FILE__) + '/../spec_helper.rb'

describe "ActiveCouch::Base #create method" do
  before(:each) do
    class Person < ActiveCouch::Base
      site 'http://localhost:5984/'
      has :name
    end
    ActiveCouch::Migrator.create_database('http://localhost:5984/', 'people')
    @person = Person.create(:name => 'McLovin')
  end
  
  after(:each) do
    ActiveCouch::Migrator.delete_database('http://localhost:5984/', 'people')
  end
  
  it "should have a class method called delete" do
    @person.methods.include?('delete').should == true
  end
  
  it "should be able to delete itself from the CouchDB database" do
    @person.delete
    # Check whether document has actually been deleted
    response = Net::HTTP.get_response URI.parse("http://localhost:5984/people/_all_docs/")
    response.body.index('"total_rows":0').should_not == nil
  end
end