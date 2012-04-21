=begin
  Provides a RESTful collection of actions on subscriptions
  Author : Gareth Aye (gareth@streamable.tv)
  Date : 04/21/12
=end
class SubscriptionsController < ApplicationController  
  def create
    @user = User.find(current_user.id)
    @stream = Stream.find(params[:stream_id])
    @subscription = Subscription.find_or_create_by_by_stream_id_and_subscriber_id(
        @stream.id,
        @user.id)
    
    redirect_to @user, :notice => "Great. You're signed up for #{@stream.title}!"
  end
  
  def destroy
    @subscription.find(:stream_id => params[:stream_id], :subscriber_id => current_user.id)
    @subscription.destroy
    
    redirect_to @user, :notice => "No problem. You're unsubscribed."
  end
end
