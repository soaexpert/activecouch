require File.dirname(__FILE__) + '/../spec_helper.rb'

describe "A subclass of ActiveCouch::Base with a has_many association" do
  before(:each) do
    class Person < ActiveCouch::Base
      has :name, :which_is => :text
    end

    class Contact < ActiveCouch::Base
      has_many :people
    end
    
    @c = Contact.new
    @p1 = Person.new
  end
  
  after(:each) do
    Object.send(:remove_const, :Person)
    Object.send(:remove_const, :Contact)
  end  
  
  it "should have an instance variable called associations which is a Hash with the key being :people" do
    Contact.associations.class.should == Hash
    Contact.associations.keys.should == [:people]
  end
  
  it "should have accessors to associated objects" do
    @c.should respond_to(:people)
    @p1.should respond_to(:contact)
    @p1.should respond_to(:contact=)
  end
  
  it "should have an accessor on the container side which returns an empty array" do
    @c.people.should == []
  end
  
  it "should have an accessor on the item side which returns the container" do
    pending
    Contact.should_receive(:find).with('id-of-contact').and_return(@c)
    @c.id = 'id-of-contact'
    @c.people << @p1
    @p1.contact.should == @c
  end
  
  it "should be able to add a Person object to the association" do
    @c.people << @p1
    @c.people.should == [@p1]
  end
  
end

describe "An object instantiated from class which is a subclass of ActiveCouch::Base" do
  before(:each) do 
    class Comment < ActiveCouch::Base
      has :body
    end

    class Blog < ActiveCouch::Base
      has :title
      has_many :comments
    end
    
    @comment1 = Comment.new(:body => "I can haz redbull?")
    @comment2 = Comment.new(:body => 'k thx bai')
    @blog = Blog.new(:title => 'Lolcats Primer', :comments => [@comment1, @comment2])
    @blog1 = Blog.new(:title => 'Lolcats Primer The Sequel', :comments => [{:body => 'can'}, {:body => 'haz'}])
  end
  
  after(:each) do
    Object.send(:remove_const, :Comment)
    Object.send(:remove_const, :Blog)
  end  
  
  it "should be able to initialize with a hash which contains descendents of ActiveCouch::Base" do
    @comment1.body.should == "I can haz redbull?"
    @comment2.body.should == "k thx bai"
    
    @blog.title.should == 'Lolcats Primer'
    @blog.comments.should == [@comment1, @comment2]
  end
  
  it "should be able to initialize from a hash which contains only Strings" do
    @blog1.title.should == 'Lolcats Primer The Sequel'
    
    comment_bodies = @blog1.comments.collect{|c| c.body }
    comment_bodies.sort!
    
    comment_bodies.first.should == 'can'
    comment_bodies.last.should == 'haz'
  end
end