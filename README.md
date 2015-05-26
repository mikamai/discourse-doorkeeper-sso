# Discourse Doorkeeper Single Sign On Plugin

This plugin adds authentication strategy for a rails application that uses doorkeeper as oauth provider.

## Usage

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
(if you don't have a homepage, then it's the right time to create one).

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

Generate the Api endpoint for authentication. Add the following controller in
`app/controllers/api/v1/credentials_controller.rb:

```ruby
module Api
  module V1
    class CredentialsController < ApplicationController
      before_action :doorkeeper_authorize!
      respond_to    :json

      def me
        respond_with current_resource_owner
      end

      private

      def current_resource_owner
        User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
      end
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

### Prepare your discourse app

Clone the repo and drop it into your discourse plugins directory.

Rename ```settings.yml.example``` to ```settings.yml``` and edit the file with your doorkeeper app config data.

At a minimum, you have to update this section:

```yaml
# enviornment specific settings:
environments:
  development:
    endpoint: http://doorkeeper_app.dev
    key: 28e5d51993bcf072e0d6c6a33c65327fcc794bee70931af106ed8f82e1a61dde
    secret: b5ffd4b090faa6d47aed8f7371e9aa0521d24a277c77b1426eb8d33afc00c137
```

`endpoint` is your doorkeeper server application domain, I suggest you to use pow 
in order to test the sign in process in development, but you can use something like 
`localhost:3000` and `localhost:3001` for the applications as well.

In order to get the `key` and `secret` values you have to register a new client application on your doorkeeper app. 
First, create a user if none exists, and log in. Then visit `/oauth/applications` and create a new client 
application with a redirect uri with the format ```http://discourse.domain/auth/doorkeeper/callback```. 
At the end of the process you will get values for the key and secret settings.

