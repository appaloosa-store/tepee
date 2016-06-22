[![Build Status](https://travis-ci.org/appaloosa-store/tepee.svg)](https://travis-ci.org/appaloosa-store/tepee)
## Purpose
This gem aims to make your rails app (or lib, script, ...) by making your environment variables more maintainable by nesting them, allowing you to use your own naming conventions for them.
## Usage
### Setup
#### Gemfile
```
gemfile
```

Your conf class must inherit from Tepee.

```
class MyApp::Configuration < Tepee
  …
end
```
### Setting a value
```
add(:my_value, 42)
## Defines the configuration value 'my_value', with 42 as default value.
## If the MY_VALUE environment variable is set, it overrides 42.
```
```
add(:my_value, 13, env_var: 'FOOBAR')
## Defines the configuration value 'my_value', with 13 as default value.
## If the FOOBAR environment variable is set, it overrides 13.
## You can use this for mapping purposes!
```
### Fetching a value
`MyApp::Configuration.my_value`
### Using sub sections
#### Adding a section
```
section(:billing) do
  add :domain,        'my_domain'
  add :api_key,       'qwerty12345'
  add :public_key,    'my-public-key'
  add :webhook_token, '12345azerty'
end
```
Those values could be accessed through: `MyApp::Configuration.billing.domain`.
That value is either:
 The content of the environment variable `BILLING_DOMAIN` if it exists, or `'my_domain'` if it does not.
#### Nesting sections
```
section(:foo) do
  # Can be overrided by the FOO_VALUE environment variable.
  # Accessible via MyApp::Configuration.foo.value
  add :value, "I'm a foo value"
   section(:bar) do
    # Can be overrided by the FOO_BAR_VALUE environment variable.
    # Accessible via Appaloosa::Configuration.foo.bar.value
    add :value, "I'm a bar value"
  end
end
```
Now, you are able to retrieve the values of your configuration tokens like follow:
* `MyApp::Configuration.foo.value      # => "I'm a foo value"`
* `MyApp::Configuration.foo.bar.value  # => "I'm a bar value"`
* `MyApp::Configuration.bar.value      # => Undefined method bar for <Configuration #...`

### Overriding values with environment variables
Assuming that your configuration is:
```
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
```
# MyApp::Configuration.top_domain_name:
heroku config:set TOP_DOMAIN_NAME='www.alice.bob' -a my-app

# MyApp::Configuration.mobile.api_key:
heroku config:set MOBILE_API_KEY='bepo13579' -a my-app

# MyApp::Configuration.mobile.notification.user:
heroku config:set MOBILE_NOTIFICATION_USER='alice@bob.com' -a my-app
```
But do not use the `env_var` keyword which allows to override the used environment variable name.