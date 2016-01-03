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

1. Initialize a client instance (URI is mandatory, all the params passed are later overridable in method calls)
2. Query the API : the params as the query name may be underscored, they will be handled appropriately
3. API response will always be a HashWithIndifferentAccess with underscored keys. Retrieve it as a result or pass a block to the API point method

```ruby
# initialize the client
client = LemonWay::Client.new wl_login: "test",
                              wl_pass: "test",
                              wl_PDV: "test",
                              language: "fr",
                              version: "1.1",
                              wsdl:  "https://ws.lemonway.fr/mb/ioio/dev/directkit/service.asmx?wsdl"

# list the available operations as follow : 
resp = client.operations
=> [:register_wallet,
 :update_wallet_details,
 :update_wallet_status,
 :register_iban,
 :register_sdd_mandate,
 :register_card,
 ...
 ]

# requests takes underscored names, and undescored (or camelcased) options, some hash with indifferent access are returned
resp = client.register_wallet,  wallet: "123",
                                client_mail:        "nico@las.com",
                                client_first_name:  "nicolas",
                                client_last_name:   "nicolas"
=> { wallet: {id: '123', lwid: "98098"}
resp[:wallet][:id] == resp['wallet']['id'] == '123'

```

Please refer to the Lemonway documentation for the complete list of methods and their parameters, or query https://ws.lemonway.fr/mb/[YOUR_DEV_NAME]/dev/directkitxml/service.asmx if Lemonway has provided you a development account 


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
