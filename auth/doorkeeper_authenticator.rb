require 'auth/oauth2_authenticator'

class Auth::DoorkeeperAuthenticator < Auth::OAuth2Authenticator
  attr_reader :key, :secret

  def initialize key, secret
    super 'doorkeeper', trusted: true
    @key, @secret = key, secret
  end

  def register_middleware(omniauth)
    omniauth.provider :doorkeeper, key, secret
  end

  def after_authenticate(auth_token)
    super(auth_token).tap do |result|
      data = auth_token[:info]
      result.username = data[:username]
    end
  end
end