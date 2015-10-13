require "spec_helper"

describe Hash do
  context "camelize_keys" do
    before do
      @hash = {:first_name => "nicolas"}
      @result_hash = @hash.camelize_keys
    end
    it "should camelize keys" do
      @result_hash.should == {:firstName => "nicolas"}
    end
    it "should not destruct original hash" do
      @hash.should == {:first_name => "nicolas"}
    end
  end
  context "camelize_keys!" do
    before do
      @hash = {:first_name => "nicolas"}
      @result_hash = @hash.camelize_keys!
    end
    it "should camelize keys" do
      @result_hash.should == {:firstName => "nicolas"}
    end
    it "should destruct original hash" do
      @hash.should == {:firstName => "nicolas"}
    end
  end
  context "underscore_keys"  do
    before do
      @hash = {:firstName => "nicolas"}
      @result_hash = @hash.underscore_keys
    end
    it "should underscore keys" do
      @result_hash.should == {:first_name => "nicolas"}
    end
    it "should not destruct original hash" do
      @hash.should == {:firstName => "nicolas"}
    end
  end
  context "underscore_keys!" do
    before do
      @hash = {:firstName => "nicolas"}
      @result_hash = @hash.underscore_keys!
    end
    it "should underscore keys" do
      @result_hash.should == {:first_name => "nicolas"}
    end
    it "should destruct original hash" do
      @hash.should == {:first_name => "nicolas"}
    end
  end
end