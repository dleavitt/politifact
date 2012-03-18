require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Politifact::Collection do
  it "should quack like an array"
  it "should descend from an array"
  it "should have metadata with paging info in it"
  it "should set the raw_response to the original response"
  
  describe "pagination" do
    it "should return the correct URI for the next page, if there is one"
    it "should retrieve the next page successfully"
    it "should return nil if there's no next page"
    it "should return the correct URI for the previous page, if there is one"
    it "should retrieve the previous page successfully"
    it "should return nil if there's no previous page"
    it "should preserve extra parameters when getting the next page"
  end
  
  describe "evaluate"
end
