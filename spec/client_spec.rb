require 'spec_helper'

describe Lemonway::Client do
  let(:opts){
    {
      :wlLogin  => "test",
      :wlPass   => "test",
      :language => "fr",
      :version  => "1.0",
      :channel  => "W",
      :walletIp => "91.222.286.32",
      :wsdl     => "https://ws.lemonway.fr/mb/ioio/dev/directkit/service.asmx?wsdl"
    }
    # YAML.load_file('config.yml')
  }
  subject { Lemonway::Client.new(opts) }

  describe :initialize do
    it "needs one hash with :wsdl key" do
      client = Lemonway::Client.new(opts)
      expect(client.instance.globals[:ssl_verify_mode]).to eq nil
    end
    it "accepts an optional second hash for savon options"  do
      client = Lemonway::Client.new(opts, ssl_verify_mode: :none)
      expect(client.instance.globals[:ssl_verify_mode]).to eq :none
    end
    it "accepts an optional block for savon options"  do
      client = Lemonway::Client.new(opts) do |savon_options|
        savon_options.ssl_verify_mode :none
      end
      expect(client.instance.globals[:ssl_verify_mode]).to eq :none
    end
  end

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

  describe :api_methods do
    let(:method_opts){
      {
        wallet: "1234567",
        client_mail:        "nico1234567@las.com",
        client_first_name:  "nicolas",
        client_last_name:   "nicolas"
      }
    }
    it "are delegated to the client instance" do
      expect(subject.instance).to receive(:operations).and_return([:register_wallet])
      expect(subject.instance).to receive(:call).with(:register_wallet, {:message => opts.update(method_opts).camelize_keys}).and_call_original
      VCR.use_cassette("create_wallet_success",:match_requests_on => [:method]) do
        resp = subject.register_wallet method_opts
        expect(resp[:id]).to eq "1234567"
        expect(resp[:lwid]).to eq "836"
      end
    end
  end

end