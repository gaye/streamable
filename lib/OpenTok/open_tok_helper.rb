=begin
  Author : Gareth Aye (gareth@streamable.tv)
  Date : 04/21/12
=end

require 'open_tok'

module OpenTokHelper
  OPENTOK_API_KEY = '14128932'
  OPENTOK_API_SECRET = 'eeaa4556a2e1c8a245477a449312fc6127c2246b'
  
  def self.create_session_and_generate_publisher_token(user, remote_addr)
    opentok = OpenTok::OpenTokSDK.new(OPENTOK_API_KEY, OPENTOK_API_SECRET)
    session = opentok.create_session(remote_addr)
    token = opentok.generate_token(
        :session_id => session,
        :role => OpenTok::RoleConstants::MODERATOR,
        :connection_data => "facebook_uid=#{user.facebook_uid}")
    [session, token]
  end
  
  def self.generate_subscriber_token(user, session_id)
    opentok = OpenTok::OpenTokSDK.new(OPENTOK_API_KEY, OPENTOK_API_SECRET)
    token = opentok.generate_token(
        :session_id => session_id, 
        :role => OpenTok::RoleConstants::PUBLISHER,
        :connection_data => "facebook_uid=#{user.facebook_uid}")
    token
  end
end
