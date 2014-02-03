require 'omniauth-oauth2'

class OmniAuth::Strategies::Doorkeeper < OmniAuth::Strategies::OAuth2
  option :name, 'doorkeeper'

  uid { raw_info['email'] }

  info do
    {
      name:     raw_info['name'],
      email:    raw_info['email'],
      username: raw_info['username']
    }
  end

  extra do
    {
      raw_info: => raw_info
    }
  end

  def raw_info
    @raw_info ||= access_token.get(DoorkeeperSso.settings.me_path).parsed
  end

end