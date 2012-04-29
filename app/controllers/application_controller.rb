=begin
  Author : Gareth Aye (gareth@streamable.tv)
  Date : 04/21/12
=end
class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper_method :logout, :current_user, :user_logged_in?
  
  def login(user)
    session[:user_id] = user.id
  end
  
  # GET users/logout
  def logout
    session.delete :user_id
    redirect_to root_path, :notice => 'Logged out successfully.'
  end

  def current_user
    session[:user_id] ? User.find(session[:user_id]) : nil
  end
  
  def user_logged_in?
    !current_user.nil?
  end
end
