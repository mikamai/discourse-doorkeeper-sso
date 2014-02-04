# Discourse Doorkeeper Single Sign On Plugin

This plugin adds authentication strategy for a rails application that uses doorkeeper as oauth provider.

## Usage

### Prepare your discourse app

Clone the repo and drop it into your discourse plugins directory.

Rename ```settings.yml.example``` to ```settings.yml``` and edit the file with your config data.

If you're wondering where you get that data, then visit your doorkeeper endpoint app at
```/auths/applications```, then create a new authorized application, which must have a Redirect uri with
the format ```http://discourse.domain/auth/doorkeeper/callback```

At this point you can copy the secret and key values from the newly generate application
settings to your plugin settings file

### Prepare your oauth provider app

Add gems to gemfile (assuming you're using devise for authentication and Active Record):

```ruby
gem 'devise'
gem 'doorkeeper'
```

Generate devise boilerplate:

```bash
rails generate devise:install
```

Generate the authentication model:

```bash
rails generate devise MODEL # replace MODEL with your user class name, i.e. user
```

Add a root path ro your routes.rb file:

```ruby
root to: "home#index"
```

For more details, please visit the devise gem github page.

Generate doorkeeper boilerplate:

```bash
rails generate doorkeeper:install
```

Generate doorkeeper migration:

```bash
rails generate doorkeeper:migration
```

Migrate the db:

```bash
rake db:migrate
```

Edit `initializers/doorkeeper.rb`:

```ruby
Doorkeeper.configure do
  resource_owner_authenticator do
    current_user || warden.authenticate!(:scope => :user)
  end
end
```

Generate the Api endpoint for authentication. Add the following controller:

```ruby
module Api
  module V1
    class CredentialsController < ApplicationController
    doorkeeper_for :all
    respond_to     :json

    def me
      respond_with current_resource_owner
    end

    private

    def current_resource_owner
      User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
    end
  end
end
```

Add routes for the API:

```ruby
namespace :api do
  namespace :v1 do
    get '/me' => 'credentials#me'
  end
end
```

For more details, please visit the doorkeeper gem github page.