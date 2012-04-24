require 'spec_helper'

=begin
  Author : Gareth Aye (gareth@streamable.tv)
  Date : 04/21/12
=end
describe StreamsController do
  fixtures :streams
  fixtures :users
  fixtures :subscriptions
  
  context 'broadcast is called and current user doesn\'t have a subscription' do
    before :each do
      @stream = streams(:inequalities)
      @user = users(:armaan)
      @subscription = Subscription.find_by_stream_id_and_subscriber_id(@user.id, @stream.id)
      
      controller.login(@user)
      @subscription.destroy if @subscription
    end
    
    it 'should redirect to streams show page and not have set @token' do
      get :broadcast, :id => @stream.id
      response.should redirect_to @stream
      assigns(:token).should be_nil
    end
  end
  
  context 'broadcast is called and current user is subscribed' do
    before :each do
      @stream = streams(:inequalities)
      @user = users(:armaan)
      @subscription = subscriptions(:armaan_subscribed_to_inequalities)
      
      controller.login(@user)
    end
    
    it 'should set @token to subscription\'s subscriber token' do
      get :broadcast, :id => @stream.id
      assigns(:token).should == @subscription.subscriber_token
    end
  end
  
  context 'broadcast is called and current user is publisher' do
    before :each do
      @stream = streams(:inequalities)
      @user = users(:gareth)
      @subscription = Subscription.find_by_stream_id_and_subscriber_id(@stream.id, @user.id)
      
      controller.login(@user)
      @subscription.destroy if @subscription
    end
    
    it 'should set @token to stream publisher token' do
      get :broadcast, :id => @stream.id
      assigns(:token).should == @stream.publisher_token
    end
  end
end
