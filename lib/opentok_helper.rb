module OpentokHelper
  OPENTOK_API_KEY = '14128932'
  OPENTOK_API_SECRET = 'eeaa4556a2e1c8a245477a449312fc6127c2246b'
  
  def self.create_session_and_generate_token(user, request)
    opentok = OpenTok::OpenTokSDK.new(OPENTOK_API_KEY, OPENTOK_API_SECRET)
    session = opentok.create_session(request.remote_addr)
    token = opentok.generate_token(
        :session_id => session,
        :role => OpenTok::RoleConstants::MODERATOR,
        :connection_data => "facebook_uid=#{user.facebook_uid}")
  end
end
