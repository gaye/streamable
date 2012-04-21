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
    redirect_to url_for('/auth/facebook')
  end
  
  # POST /auth/facebook/callback
  def facebook_callback
    omniauth = request.env['omniauth.auth']
    
    @user = User.find_or_create_by_facebook_uid(omniauth['uid'])
    @user.first_name = omniauth['info']['first_name']
    @user.last_name = omniauth['info']['last_name']
    @user.image_url = omniauth['info']['image']
    @user.raw = omniauth.to_json
    @user.token = omniauth['credentials']['token']
    @user.token_expiration = omniauth['credentials']['expires_at']
    
    if @user.save
      redirect_to @user, :notice => "Hi #{@user}!"
    else
      # TODO(gaye): Is this right?
      render :action => 'new'
    end
  end
end
