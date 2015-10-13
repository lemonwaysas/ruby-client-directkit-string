require 'spec_helper'

describe LemonWay::Client do
  subject do
    described_class.new({
      wsdl: "http://api.lemonway.com?wsdl",
      wlLogin: "test",
      wlPass: "test",
      wlPDV: "test",
      language: "fr",
      version: "1.0",
      channel: "W",
      walletIp: "91.222.286.32"
    })
  end

  describe :operations do
    it "delegates to" do

    end
  end

end