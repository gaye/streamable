require 'spec_helper'

describe HomeController do
  context 'a logged out user visits home index' do
    before :each do
      # TODO(gaye): Logout
    end
    
    it 'should be success' do
      get :index
      response.should be_success
    end
  end
  
  context 'a logged in user visits home index' do
    before :each do
      # TODO(gaye): Login
    end
    
    it "should redirect" do
      response.should be_redirect
    end
  end
end
