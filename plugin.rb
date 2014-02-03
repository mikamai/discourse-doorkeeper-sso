# name: doorkeeper-sso
# about: doorkeeper login support for Discourse
# version: 0.1
# authors: Nicola Racco

require File.expand_path('../omni_auth/strategies/doorkeeper', __FILE__)
require File.expand_path('../auth/doorkeeper_authenticator', __FILE__)

module DoorkeeperSso
  def self.settings
    @settings ||= load_settings File.expand_path '../settings.yml', __FILE__
  end

  private

  def self.load_settings file
    data     = YAML::load_file file
    env_data = data.delete 'environments'
    OpenStruct.new data.merge env_data[Rails.env.to_s] || {}
  end
end

OmniAuth::Strategies::Doorkeeper.instance_eval do
  # This is where you pass the options you would pass when
  # initializing your consumer from the OAuth gem.
  option :client_options, site: DoorkeeperSso.settings.endpoint
end

settings = DoorkeeperSso.settings

auth_provider title:         settings.title,
              message:       settings.message,
              authenticator: Auth::DoorkeeperAuthenticator.new(settings.key, settings.secret),
              frame_width:   settings.frame_width,
              frame_height:  settings.frame_height

register_asset 'doorkeeper.js'
register_asset 'doorkeeper.css'