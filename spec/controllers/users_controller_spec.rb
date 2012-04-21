require 'spec_helper'

=begin
  Author : Gareth Aye (gareth@streamable.tv)
  Date : 04/21/12
=end
describe UsersController do
  context 'show is called' do
    # TODO(gaye)
  end
  
  context 'user visits new' do
    it 'should redirect the user to facebook' do
      get :new
      response.should redirect_to('/auth/facebook')
    end
  end
  
  context 'receive callback from facebook login' do
    # TODO(gaye)
  end
end
