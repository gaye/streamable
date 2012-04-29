require 'spec_helper'

=begin
  Author : Gareth Aye (gareth@streamable.tv)
  Date : 04/21/12
=end
describe StreamsController do
  MISSING_STREAM_ID = 42
  
  fixtures :streams
  fixtures :users
  fixtures :tags
  fixtures :subscriptions
  
  context 'index is called with tags' do
    before :each do
      @tags = [tags(:math).name, tags(:grade8).name]
      @streams = Stream.find_by_tags(@tags)
    end

    it 'should set @streams to the appropriate, filtered streams' do
      get :index, :tags => @tags
      assigns(:streams).should == @streams
    end
  end
  
  context 'index is called without tags' do
    before :each do
      @streams = Stream.all
    end
    
    it 'should set @streams to the collection of all streams' do
      get :index
      assigns(:streams).should == @streams
    end
  end
  
  context 'show is called and stream is found' do
    before :each do
      @stream = streams(:inequalities)
    end
    
    it 'should set @stream appropriately' do
      get :show, :id => @stream.id
      assigns(:stream).should == @stream
    end
  end
  
  context 'show is called but stream is not found' do
    before :each do
      Stream.where(:id => MISSING_STREAM_ID).should be_empty
    end
    
    it 'should return 404 not found' do
      get :show, :id => MISSING_STREAM_ID
      response.code.should == '404'
    end
  end
  
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
  
  context 'edit is called, stream is found, and current user is publisher' do
    before :each do
      @stream = streams(:inequalities)
      @user = users(:gareth)
      @subscription = Subscription.find_by_stream_id_and_subscriber_id(@stream.id, @user.id)
      
      controller.login(@user)
      @subscription.destroy if @subscription
    end
    
    it 'should set @stream appropriately' do
      get :edit, :id => @stream.id
      assigns(:stream).should == @stream
    end
  end
  
  context 'edit is called, stream is found, but current user is not publisher' do
    before :each do
      @stream = streams(:inequalities)
      @user = users(:armaan)
      
      controller.login(@user)
    end
    
    it 'should return 401 unauthorized' do
      get :edit, :id => @stream.id
      response.code.should == '401'
    end
  end
  
  context 'edit is called but stream is not found' do
    before :each do
      Stream.where(:id => MISSING_STREAM_ID).should be_empty
    end
    
    it 'should return 404 not found' do
      get :edit, :id => MISSING_STREAM_ID
      response.code.should == '404'
    end
  end
  
  context 'create is called' do
    before :each do
      @user = users(:gareth)
      SESSION = stub(Object, :session_id => (SESSION_ID = 'abcitseasyas123'))
      TOKEN = 'token+8675309'
      
      controller.login(@user)
      OpenTokHelper.stub(:create_session_and_generate_publisher_token).and_return([SESSION, TOKEN])
    end
    
    it 'should save a stream to the database' do
      pending 'TODO(gaye): Figure out how to mock out video uploads'
    end
  end
  
  context 'update is called, stream is found, and current user is publisher' do
    NEW_TITLE = 'A New Title for an Old Stream'
    
    before :each do
      @stream = streams(:inequalities)
      @user = users(:gareth)
      
      @stream.title.should_not == NEW_TITLE
      controller.login(@user)
    end
    
    it 'should update appropriately' do
      put :update, :id => @stream.id, :stream => {:title => NEW_TITLE}
      Stream.find(@stream.id).title.should == NEW_TITLE
    end
  end
  
  context 'update is called, stream is found, but current user is not publisher' do
    before :each do
      @stream = streams(:inequalities)
      @user = users(:armaan)
      
      controller.login(@user)
    end
    
    it 'should return 401 unauthorized' do
      put :update, :id => @stream.id
      response.code.should == '401'
    end
  end
  
  context 'update is called but stream is not found' do
    before :each do
      Stream.where(:id => MISSING_STREAM_ID).should be_empty
    end
    
    it 'should return 404 not found' do
      put :update, :id => MISSING_STREAM_ID
      response.code.should == '404'
    end
  end
  
  context 'destroy is called, stream is found, and current user is publisher' do
    before :each do
      @stream = streams(:inequalities)
      @user = users(:gareth)
      
      Stream.where(:id => @stream.id).should_not be_empty
      controller.login(@user)
    end
    
    it 'should remove stream from database' do
      delete :destroy, :id => @stream.id
      Stream.where(:id => @stream.id).should be_empty
    end
  end
  
  context 'destroy is called, stream is found, but current user is not publisher' do
    before :each do
      @stream = streams(:inequalities)
      @user = users(:armaan)
      
      controller.login(@user)
    end
    
    it 'should return 401 unauthorized' do
      delete :destroy, :id => @stream.id
      response.code.should == '401'
    end
  end
  
  context 'destroy is called but stream is not found' do
    before :each do
      Stream.where(:id => MISSING_STREAM_ID).should be_empty
    end
    
    it 'should return 404 not found' do
      delete :destroy, :id => MISSING_STREAM_ID
      response.code.should == '404'
    end
  end
end
