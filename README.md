__Caution : Still under developpement and subject to changes__ 
# LemonWay

Ruby API client to query LemonWay

## Installation

Add this line to your application's Gemfile:

    gem 'lemon_way'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install lemon_way

## Usage

1. Initialize a client instance (URI is mandatory, all the params passed are later overridable in method calls)
2. Query the API : the params as the query name may be underscored, they will be handled appropriately
3. API response will always be a HashWithIndifferentAccess with underscored keys. Retrieve it as a result or pass a block to the API point method

```ruby
client = LemonWay::Client.new wl_login: "test",
                              wl_pass: "test",
                              wl_PDV: "test",
                              language: "fr",
                              version: "1.1",
                              uri:  "https://ws.lemonway.fr/mb/your_merchant_name/dev/directkit/service.asmx"

response = client.register_wallet my_hash

client.register_wallet my_hash do |response|
  response.class
end
=> HashWithIndifferentAccess

```



## Todo

1. Complete the doc
2. Test with VCR
3. Build WebMerchant client


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
