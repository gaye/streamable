require 'spec_helper'

=begin
  Author : Gareth Aye (gareth@streamable.tv)
  Date : 04/23/12
=end
describe ApplicationController do
  context 'user logs out' do
    SESSION_ID = 1
    before :each do
      session[:user_id] = SESSION_ID
    end
    
    it 'should delete the user session' do
      session[:user_id].should == SESSION_ID
      get :logout
      session[:user_id].should be_nil
    end
    
    it 'should redirect the user to the root page' do
      get :logout
      response.should redirect_to root_path
    end
  end
end
