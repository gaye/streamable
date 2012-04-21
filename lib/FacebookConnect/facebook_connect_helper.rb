=begin
  Author : Gareth Aye (gareth@streamable.tv)
  Date : 04/21/12
=end
module FacebookConnectHelper
  def parse(omniauth)
    {
      :first_name => omniauth['info']['first_name'],
      :last_name => omniauth['info']['last_name'],
      :image_url => omniauth['info']['image'],
      :raw => omniauth.to_json,
      :token => omniauth['credentials']['token'],
      :token_expiration => omniauth['credentials']['expires_at']
    }
  end
end
