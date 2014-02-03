# Discourse Doorkeeper Single Sign On Plugin

This plugin adds authentication strategy for a rails application that uses doorkeeper as oauth provider.

### Usage

Clone the repo and drop it into your discourse plugins directory.

Rename ```settings.yml.example``` to ```settings.yml``` and edit the file with your config data.

If you're wondering where you get that data, then visit your doorkeeper endpoint app at
```/auths/applications```, then create a new authorized application, which must have a Redirect uri with
the format ```http://discourse.domain/auth/doorkeeper/callback```

At this point you can copy the secret and key values from the newly generate application
settings to your plugin settings file