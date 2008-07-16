require File.dirname(__FILE__) + '/../spec_helper.rb'

describe "A subclass of ActiveCouch::Base with a belongs_to association" do
  before(:each) do
    class Article < ActiveCouch::Base; end
    class Author < ActiveCouch::Base; end

    class Article < ActiveCouch::Base
      has :title
      has :body
      belongs_to :author
    end
    
    class Author < ActiveCouch::Base
      has :name, :which_is => :text
      has_many :articles
    end

    @author = Author.new
    @a1 = Article.new
    @a2 = Article.new
  end
  
  after(:each) do
    Object.send(:remove_const, :Author)
    Object.send(:remove_const, :Article)
  end
  
  it "should have an instance variable called associations which is a Hash with the key being :people" do
    Article.associations.class.should == Hash
    Article.associations.keys.should == [:author]
  end
  
  it "should have getters and setters for association" do
    pending
    @a1.should respond_to(:author)
    @a1.should respond_to(:author=)
  end
  
end
