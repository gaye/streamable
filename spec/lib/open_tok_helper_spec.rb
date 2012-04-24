require 'spec_helper'

=begin
  Author : Gareth Aye (gareth@streamable.tv)
  Date : 04/21/12
=end
describe OpenTokHelper do
  fixtures :users
  
  context 'create_session_and_generate_publisher_token is called' do
    it 'should return a session and publisher token' do
      session, token = 
          OpenTokHelper::create_session_and_generate_publisher_token(users(:gareth), '127.0.0.1')
      
      session.should_not be_nil
      token.should_not be_nil
    end
  end
  
  context 'generate_subscriber_token is called' do
    it 'should return a subscriber token different from the publisher token' do
      session, publisher_token = 
          OpenTokHelper::create_session_and_generate_publisher_token(users(:gareth), '127.0.0.1')
      
      subscriber_token = OpenTokHelper::generate_subscriber_token(users(:gareth), session)
      subscriber_token.should_not be_nil
      subscriber_token.should_not == publisher_token
    end
  end
end
