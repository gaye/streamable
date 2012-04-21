=begin
  Provides a RESTful collection of actions on users
  Facebook Connect is used to handle user authentication
  Author : Gareth Aye (gareth@streamable.tv)
  Date : 04/21/12
=end
class UsersController < ApplicationController
  # GET /users
  # GET /users.json
  def index
    @users = User.all
    
    respond_to do |format|
      format.html
      format.json { render :json => @users }
    end
  end
  
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
  
  # GET /users/1/edit
  def edit
    @stream = Stream.find(params[:id])
  end
  
  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])
    
    if @user.save
      format.html { redirect_to @user, :notice => 'Thanks for signing up!'}
      format.json { render :json => @user, :status => :created, :location => @user }
    else
      format.html { render :action => 'new' }
      format.json { render :json => @user.errors, :status => :unprocessable_entity }
    end
  end
  
  # PUT /streams/
  # PUT /streams/1.json
  def update
    @user = User.find(params[:id])
    
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, :notice => 'User profile successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => 'edit' }
        format.json { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # DELETE /streams/1
  # DELETE /streams/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    
    respond_to do |format|
      format.html { redirect_to streams_url }
      format.json { head :no_content }
    end
  end
  
  # POST /auth/facebook/callback
  def facebook_callback
    omniauth = request.env['omniauth.auth']
    user = FacebookConnectHelper::parse(omniauth)
    
    if @user = User.find_by_facebook_uid(omniauth['uid'])
      redirect_to :update, :id => @user.id, :user => user
    else
      redirect_to :create, :user => user
    end
  end
end
