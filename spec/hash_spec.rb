require "spec_helper"

describe Hash do
  context "camelize_keys" do
    subject{ {:first_name => "nicolas"} }
    it "should camelize keys" do
      expect(subject.camelize_keys).to eq :firstName => "nicolas"
    end
    it "should not destruct original hash" do
      subject.camelize_keys
      expect(subject).to eq :first_name => "nicolas"
    end
  end
  context "camelize_keys!" do
    subject{ {:first_name => "nicolas"} }
    it "should camelize keys" do
      expect(subject.camelize_keys!).to eq :firstName => "nicolas"
    end
    it "should destruct original hash" do
      subject.camelize_keys!
      expect(subject).to eq :firstName => "nicolas"
    end
  end
  context "underscore_keys"  do
    subject { {:firstName => "nicolas"} }
    it "should underscore keys" do
      expect(subject.underscore_keys).to eq :first_name => "nicolas"
    end
    it "should not destruct original hash" do
      subject.underscore_keys
      expect(subject).to eq :firstName => "nicolas"
    end
  end
  context "underscore_keys!" do
    subject { {:firstName => "nicolas"} }
    it "should underscore keys" do
      expect(subject.underscore_keys!).to eq :first_name => "nicolas"
    end
    it "should destruct original hash" do
      subject.underscore_keys!
      expect(subject).to eq :first_name => "nicolas"
    end
  end
end