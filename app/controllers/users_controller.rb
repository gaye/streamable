=begin
  Provides a RESTful collection of actions on users
  Facebook Connect is used to handle user authentication
  Author : Gareth Aye (gareth@streamable.tv)
  Date : 04/21/12
=end
class UsersController < ApplicationController 
  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    
    respond_to do |format|
      format.html
      format.json { render :json => @user }
    end
  end
  
  # GET /users/new
  # GET /users/new.json
  def new
    redirect_to '/auth/facebook'
  end
  
  # POST /auth/facebook/callback
  def facebook_callback
    omniauth = request.env['omniauth.auth']
    
    @user = User.find_or_create_by_facebook_uid(omniauth['uid'])
    @user.update_attributes(
      :first_name => omniauth['info']['first_name'],
      :last_name => omniauth['info']['last_name'],
      :image_url => omniauth['info']['image'],
      :raw => omniauth.to_json,
      :token => omniauth['credentials']['token'],
      :token_expiration => omniauth['credentials']['expires_at'])
    
    if @user.save
      session[:user_id] = @user.id
      redirect_to @user, :notice => "Hi #{@user}!"
    else
      redirect_to root_path, :notice => 'Failed to authenticate with Facebook. Please try again.'
    end
  end
end
