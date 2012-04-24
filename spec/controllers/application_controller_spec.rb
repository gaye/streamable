require 'spec_helper'

=begin
  Author : Gareth Aye (gareth@streamable.tv)
  Date : 04/23/12
=end
describe ApplicationController do
  fixtures :users
  
  context 'user logs in' do
    before :each do
      get :logout
      @user = users(:gareth)
    end
    
    it 'should have logged the user in' do
      controller.user_logged_in?.should be_false
      controller.login(@user)
      controller.user_logged_in?.should be_true
    end
    
    it 'should now be the case that current_user returns the logged in user' do
      controller.login(@user)
      controller.current_user.should == @user
    end
  end
  
  context 'user logs out' do
    before :each do
      @user = users(:gareth)
      controller.login(@user)
    end
    
    it 'should delete the user session' do
      controller.user_logged_in?.should be_true
      get :logout
      controller.user_logged_in?.should be_false
    end
    
    it 'should redirect the user to the root page' do
      get :logout
      response.should redirect_to root_path
    end
  end
end
