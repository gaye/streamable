=begin
  Author : Gareth Aye (gareth@streamable.tv)
  Date : 04/21/12
=end
class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper_method :current_user, :logout!
  
  private
  
  def current_user
    session[:user_id] ? User.find(session[:user_id]) : nil
  end
  
  def logout
    session.delete :user_id
    redirect_to root_path, :notice => 'Logged out successfully.'
  end
end
