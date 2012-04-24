require 'spec_helper'

=begin
  Author : Gareth Aye (gareth@streamable.tv)
  Date : 04/21/12
=end
describe UsersController do
  fixtures :users
  
  context 'show is called' do
    before :each do
      @user = users(:gareth)
    end
    
    it 'should set @user for the view' do
      get :show, :id => @user.id
      assigns(:user).should == @user
    end
  end
  
  context 'user visits new' do
    it 'should redirect the user to facebook' do
      get :new
      response.should redirect_to('/auth/facebook')
    end
  end
  
  context 'receive callback from facebook login' do
    BOBBY_ZEE_UID = 1234
    
    it 'should save the user to the database if they don\'t already exist' do
      @user = User.new(
        :facebook_uid => BOBBY_ZEE_UID,
        :first_name => 'Bobby',
        :last_name => 'Zee',
        :image_url => 'http://www.lolcats.com/images/u/07/31/lolcatsdotcomq3e0e53n7y6ofmvy.jpg',
        :token => 'abcitseasyas123',
        :token_expiration => Time.now)
      request.env['omniauth.auth'] = mock_omniauth(@user)
      
      get :facebook_callback
      
      saved = User.find_by_facebook_uid(BOBBY_ZEE_UID)
      saved.should_not be_nil
      @user.first_name.should == saved.first_name
      @user.last_name.should == saved.last_name
      @user.image_url.should == saved.image_url
      @user.token.should == saved.token
      @user.token_expiration.should == saved.token_expiration
    end
    
    it 'should update user attributes with the ones from facebook if user already exists' do
      @user = users(:gareth)
      @user.first_name = 'Reggaeton Gareth'   # A mysterious alterego
      request.env['omniauth.auth'] = mock_omniauth(@user)
      
      get :facebook_callback
      User.find_by_facebook_uid(@user.facebook_uid).should == @user
    end
  end
  
  private
  
  def mock_omniauth(user)
    { 
      'provider' => 'facebook', 
      'uid' => user.facebook_uid, 
      'info' => {
        'first_name' => user.first_name,
        'last_name' => user.last_name,
        'image' => user.image_url
      },
      'credentials' => {
        'token' => user.token,
        'expires_at' => user.token_expiration
      }
    }
  end
end
