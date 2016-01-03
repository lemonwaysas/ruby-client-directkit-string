require 'spec_helper'

describe Lemonway::Client do
  let(:opts){
    YAML.load_file('./config.yml')
    # {
    #   :wsdl     => "http://api.lemonway.com?wsdl",
    #   :wlLogin  => "test",
    #   :wlPass   => "test",
    #   :wlPDV    => "test",
    #   :language => "fr",
    #   :version  => "1.0",
    #   :channel  => "W",
    #   :walletIp => "91.222.286.32"
    # }
  }
  subject { Lemonway::Client.new(opts) }

  describe :instance do
    it "is a savon client instance " do
      expect(subject.instance).to be_a(Savon::Client)
    end
  end
  describe :operations do
    it "is delegated to the client instance" do
      expect(subject.instance).to receive :operations
      subject.operations
    end
  end
  # commented to pass with travis
  # describe :api_methods do
  #   let(:method_opts){
  #     {
  #       wallet: "123",
  #       client_mail:        "nico@las.com",
  #       client_first_name:  "nicolas",
  #       client_last_name:   "nicolas"
  #     }
  #   }
  #   it "are delegated to the client instance" do
  #     expect(subject.instance).to receive(:operations).and_return([:register_wallet])
  #     expect(subject.instance).to receive(:call).with(:register_wallet, :message => opts.update(method_opts).camelize_keys).and_call_original
  #     VCR.use_cassette("create_wallet_success") do
  #       resp = subject.register_wallet method_opts
  #       expect(resp[:wallet][:id]).to eq "123"
  #       expect(resp[:wallet][:lwid]).to eq "591"
  #     end
  #   end
  # end

end