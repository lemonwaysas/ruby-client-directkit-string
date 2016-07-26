[![Build Status](https://travis-ci.org/itkin/lemonway.svg?branch=master)](https://travis-ci.org/itkin/lemonway)

# LemonWay

Ruby API client to query LemonWay API

## Installation

Add this line to your application's Gemfile:

    gem 'lemonway'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install lemonway

## Usage

1. Initialization : `LemonWay::Client.new(api_params, client_config_options, &client_config_block)`
  - `api_options` (Hash) : mandatory hash where are passed the api param you want to reapeat every client query + the `:wsdl` uri
  - `client_config_options` (Hash) : optional hash passed to savon to build its [global options](https://github.com/savonrb/savon/blob/master/lib/savon/options.rb) used by the client on every query
  - `client_config_block` (Block) : optional block to customize the savon client, takes a [savon global options](https://github.com/savonrb/savon/blob/master/lib/savon/options.rb) instance as param
  ```ruby
client = LemonWay::Client.new({wsdl:  "https://ws.lemonway.fr/[...]/service.asmx?wsdl"}, {ssl_verify_mode: :none})
#is the same as
client = LemonWay::Client.new wsdl:  "https://ws.lemonway.fr/[...]/service.asmx?wsdl" do |opts|
  opts.ssl_verify_mode(:none)
end
  ```

2. Query the API directly calling the method on the client instance : `client.api_method_name(params, client_config_override, &client_block_config_override)`
  - `api_method_name` : Lemonway underscorized mehtod name (refer to the Lemonway doc or to `client.operations` to list them
  - `params` (Hash) : params sent to the api, keys will be camelcased to comply with the SOAP convention used by Lemonway
  - `client_config_override` (Hash) : A hash of config transmitted to the savon client, which overrides the [savon global config](https://github.com/savonrb/savon/blob/master/lib/savon/options.rb) for the current api call only
  - `client_block_config_override` (Block) : A Block taking a [savon global options](https://github.com/savonrb/savon/blob/master/lib/savon/options.rb) instance as param, to override the client call configuration options


3. API response will always be a HashWithIndifferentAccess with underscored keys. Retrieve it as a result or pass a block to the API point method


```ruby
# initialize the client
  # at the end of url the `?wsdl` is realy important
# config/initializers/lemonway.rb
CLIENT_LEMON = Lemonway::Client.new wsdl:  "https://ws.lemonway.fr/mb/ioio/dev/directkit/service.asmx?wsdl",
                              wl_login: "test",
                              wl_pass: "test",
                              language: "fr",
                              version: "1.1"

# list the available operations as follow :
  CLIENT_LEMON.operations
  => [:register_wallet,
   :update_wallet_details,
   :update_wallet_status,
   :register_iban,
   :register_sdd_mandate,
   :register_card,
   ...
   ]



# requests takes underscored names, and undescored (or camelcased) options, some hash with indifferent access are returned

# You need to send the IP of your client, to have it available everywhere do :
  # application_controller

  before_filter :get_request

    def get_request
      $request = request
    end


# models/user
  after_create :create_lw_account

  private
  def create_lw_account
    resp = CLIENT_LEMON = client.register_wallet(wallet: "123",
                                clientMail:        "nico@las.com",
                                clientFirstName:  "nicolas",
                                clientLastName:   "nicolas",
                                payerOrBeneficiary: 1,
                                wallet_ip: $request.remote_ip,
                                )
    => {id: '123', lwid: "98098"}

    # Save the lwid in database
      resp[:id] == resp['id'] == '123'
      user = self.update(lwid: resp[:id])
      ########################
     # Save the :id and not the :lwid, because it's this one that you need for the call after #
      ##########################
  end


```

```
# Wallet option :
  # Get wallet details
  CLIENT_LEMON.get_wallet_details(wallet: 'id(string)', email:"email(string)")


```

```
  # For crowdfunding
    # Create like classic user, but add need option, exemple :  Debtor, (value = 1 if debtor) (example for project)

    # First credit the user wallet.



```




Please refer to the Lemonway documentation for the complete list of methods and their parameters, or query https://ws.lemonway.fr/mb/[YOUR_LEMONWAY_NAME]/dev/directkitxml/service.asmx if Lemonway has provided you a development account


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
