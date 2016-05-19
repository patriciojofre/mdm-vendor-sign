# MdmCSR

Generate apple MDM vendor CSR signing file to upload to https://identity.apple.com/pushcert/


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mdmCSR'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mdmCSR

## Usage

```ruby
    params = {
                country: 'CL',
                state: 'RM',
                city: 'Santiago',
                department: 'Web',
                organization: 'Example Inc.',
                common_name: 'example.com',
                email: 'example@email.com'
              }

      @certificate = MdmCSR::Certificate.new(params)
```

this will create the certificate_signing_request.plist that you need upload to https://identity.apple.com/pushcert/

