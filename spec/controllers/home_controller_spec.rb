require 'spec_helper'

=begin
  Author : Gareth Aye (gareth@streamable.tv)
  Date : 04/21/12
=end
describe HomeController do
  context 'logged out user visits home index' do
    before :each do
      controller.stub(:user_logged_in?).and_return(false)
    end
    
    it 'should be success' do
      get :index
      response.should be_success
    end
  end
  
  context 'logged in user visits home index' do
    before :each do
      controller.stub(:user_logged_in?).and_return(true)
    end
    
    it "should redirect" do
      get :index
      response.should redirect_to(streams_path)
    end
  end
end
