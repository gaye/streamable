require 'spec_helper'

describe HomeController do
  context 'a logged out user visits home index' do
    it 'should be success' do
      get :index
      response.should be_success
    end
  end
end
