=begin
  Provides a RESTful collection of actions on streams
  OpenTok is used to manage live video sessions
  Author : Gareth Aye (gareth@streamable.tv)
  Date : 04/21/12
=end
class StreamsController < ApplicationController
  # GET /streams
  # GET /streams.json
  def index
    # TODO(gaye): We don't want an all query here 
    # we'd rather send some and then continue to load them in via ajax
    # This is a prohibitively expensive request otherwise
    @streams = 
        params[:tags] ? Stream.find_by_tags(params[:tags]) : Stream.all(:include => :publisher)   
    @tags = Tag.all
    
    respond_to do |format|
      format.html
      format.json { render :json => @streams }
    end
  end
  
  # GET /streams/1
  # GET /streams/1.json
  def show
    @stream = Stream.find(params[:id], :include => :publisher)
    @subscription = Subscription.new
    # TODO(gaye): Lookup whether current user is publisher/subscriber
    
    respond_to do |format|
      format.html
      format.json { render :json => @stream }
    end
  end
  
  # GET /streams/1/broadcast
  def broadcast
    @stream = Stream.find(params[:id], :include => :publisher)
    if @stream.publisher == current_user
      @publisher = true
      @token = @stream.publisher_token
    elsif @subscription = Subscription.find_by_stream_id_and_subscriber_id(@stream.id, current_user.id)
      @publisher = false
      @token = @subscription.subscriber_token
    else
      redirect_to @stream, :notice => 'No silly! You have to sign up first!'
    end
  end
  
  # GET /streams/new
  # GET /streams/new.json
  def new
    # TODO(gaye): Enforce permissions
    @stream = Stream.new
    @tags = Tag.all
    
    respond_to do |format|
      format.html
      format.json { render :json => @stream }
    end
  end
  
  # GET /streams/1/edit
  def edit
    @stream = Stream.find(params[:id], :include => :publisher)
    return unauthorized if @stream.publisher != current_user
  end
  
  # POST /streams
  # POST /streams.json
  def create
    # TODO(gaye): Enforce permissions
    session, token = 
        OpenTokHelper::create_session_and_generate_publisher_token(current_user, request.remote_addr)
    params[:stream][:publisher_id] = current_user.id
    params[:stream][:opentok_session_id] = session.session_id
    params[:stream][:publisher_token] = token
    
    @stream = Stream.new(params[:stream])
    @stream.tags = params[:tags].split(',').map {|t| Tag.find_or_create_by_name(t)}
    
    respond_to do |format|
      if @stream.save
        format.html { redirect_to @stream, :notice => "Great! We'll see you at #{@stream.when}!" }
        format.json { render :json => @stream, :status => :created, :location => @stream }
      else
        format.html { render :action => 'new' }
        format.json { render :json => @stream.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # PUT /streams/1
  # PUT /streams/1.json
  def update
    @stream = Stream.find(params[:id], :include => :publisher)
    return unauthorized if @stream.publisher != current_user

    respond_to do |format|
      if @stream.update_attributes(params[:stream])
        format.html { redirect_to @stream, :notice => "Okay got it! We'll see you at #{@stream.when}!" }
        format.json { head :no_content }
      else
        format.html { render :action => 'edit' }
        format.json { render :json => @stream.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # DELETE /streams/1
  # DELETE /streams/1.json
  def destroy
    @stream = Stream.find(params[:id], :include => :publisher)
    return unauthorized if @stream.publisher != current_user
    
    @stream.destroy

    respond_to do |format|
      format.html { redirect_to streams_url }
      format.json { head :no_content }
    end
  end
  
  # capture notifications from the Zencoder service about video encoding
  def encode_notify
  end
end
