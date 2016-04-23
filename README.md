# Faceless [![Gem Version](https://badge.fury.io/rb/faceless.svg)](https://badge.fury.io/rb/faceless)

A cool implementation of encryption/decryption in Ruby, borrowed from [UCenter Authcode(comsenz)](http://www.comsenz.com/downloads/install/ucenter).

For me, the coolest thing is, everytime it encodes a same string and generates different result, this makes it more secure.

## Installation

Just install the gem:

```
gem install faceless
```

Or add it to your Gemfile:

```
gem 'faceless'
```

## Configuration

```
Faceless.configure do |config|
  config.auth_token = 'whatever-token-you-want'
end
```

## Usage

#### To encrypt
```
encrypted = Faceless::Authcode.encode("encrypt-me")
```

#### To decrypt
```
Faceless::Authcode.decode encrypted
```

## Note
The original algorithm implementation was in PHP by comsenz.

Thanks to them. :beers:

The name of this project is from
[http://gameofthrones.wikia.com/wiki/Faceless_Men](http://gameofthrones.wikia.com/wiki/Faceless_Men)

## License

[MIT](http://opensource.org/licenses/MIT)

