=begin
  Provides a RESTful collection of actions on subscriptions
  Author : Gareth Aye (gareth@streamable.tv)
  Date : 04/21/12
=end
class SubscriptionsController < ApplicationController  
  def create
    @user = User.find(current_user.id)
    @stream = Stream.find(params[:stream_id])
    @token = OpenTokHelper::generate_subscriber_token(@user, @stream.opentok_session_id)
    @subscription = Subscription.new(
        :stream_id => @stream.id, 
        :subscriber_id => @user.id,
        :subscriber_token => @token)
        
    respond_to do |format|
      if @subscription.save
        # TODO(gaye): Where should they go?
        format.html { redirect_to @stream, :notice => "You're subscribed! See you at #{@stream.when}!" }
        format.json { render :json => @subscription, :status => :created }
      else
        format.html { redirect_to @stream, :notice => 'Something went wrong. Please try subscribing again.' }
        format.json { render :json => @subscription.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @subscription.find(:stream_id => params[:stream_id], :subscriber_id => current_user.id)
    @subscription.destroy
    
    redirect_to @user, :notice => "No problem. You're unsubscribed."
  end
end
