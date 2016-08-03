# Tepee: A configuration helper for the braves

[![Build Status](https://travis-ci.org/appaloosa-store/tepee.svg)](https://travis-ci.org/appaloosa-store/tepee) [![Dependency Status](https://dependencyci.com/github/appaloosa-store/tepee/badge)](https://dependencyci.com/github/appaloosa-store/tepee)

<img align="right" height="400" src="https://s3.eu-central-1.amazonaws.com/appaloosa-design/github/Tepee-v0.2c.svg">

---

This gem aims to make your rails app (or lib, script, etc.) configuration easier to maintain by making your environment variables nestable and allowing you to use your own naming conventions.

## Install & usage

### Setup

#### Gemfile

```ruby
# ...
gem 'tepee'
# ...
```

#### Code

Your configuration class must inherit from Tepee.

```ruby
class MyApp::Configuration < Tepee
  # ...
end
```

### Setting a value

```ruby
class MyApp::Configuration < Tepee
  add(:my_value, 42)
  ## Defines the configuration value 'my_value', with 42 as default value.
  ## If the MY_VALUE environment variable is set, it overrides 42.

  add(:my_value, 13, env_var: 'FOOBAR')
  ## Defines the configuration value 'my_value', with 13 as default value.
  ## If the FOOBAR environment variable is set, it overrides 13.
  ## You can use this for mapping purposes!
end
```

### Fetching a value

`MyApp::Configuration.my_value`

### Using sub sections

#### Adding a section

```ruby
class MyApp::Configuration < Tepee
  section(:billing) do
    add :domain,        'my_domain'
    add :api_key,       'qwerty12345'
    add :public_key,    'my-public-key'
    add :webhook_token, '12345azerty'
  end
end
```

Those values could be accessed through: `MyApp::Configuration.billing.domain`.
That value is either:
 The content of the environment variable `BILLING_DOMAIN` if it exists, or `'my_domain'` if it does not.

#### Nesting sections

```ruby
class MyApp::Configuration < Tepee
  section(:foo) do
    # Can be overridden by the FOO_VALUE environment variable.
    # Accessible via MyApp::Configuration.foo.value
    add :value, "I'm a foo value"
     section(:bar) do
      # Can be overridden by the FOO_BAR_VALUE environment variable.
      # Accessible via MyApp::Configuration.foo.bar.value
      add :value, "I'm a bar value"
    end
  end
end
```

Now, you are able to retrieve the values of your configuration tokens like follow:
* `MyApp::Configuration.foo.value      # => "I'm a foo value"`
* `MyApp::Configuration.foo.bar.value  # => "I'm a bar value"`
* `MyApp::Configuration.bar.value      # => Undefined method bar for <Configuration #...`

### Overriding values with environment variables

Assuming that your configuration is:

```ruby
class MyApp::Configuration
  ...
  add :top_domain_name, (Rails.env.test? ? 'example.com' : 'lvh.me')
  section :mobile do
    add :api_key, 'dvorak98765', env_var: 'GC2M_API_KEY'
    section :notification do
      add :user, 'bob@alice.com'
    end
  end
end
```

If you want to configure (for the heroku application 'my-app') any of those configuration values, please proceed as following:

```ruby
# MyApp::Configuration.top_domain_name:
heroku config:set TOP_DOMAIN_NAME='www.alice.bob' -a my-app

# MyApp::Configuration.mobile.api_key:
heroku config:set MOBILE_API_KEY='bepo13579' -a my-app

# MyApp::Configuration.mobile.notification.user:
heroku config:set MOBILE_NOTIFICATION_USER='alice@bob.com' -a my-app
```

But do not use the `env_var` keyword which allows to override the used environment variable name.

## Contributing

1. Fork it ( https://github.com/appaloosa-store/tepee/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Licence

See the included LICENSE file for details.
