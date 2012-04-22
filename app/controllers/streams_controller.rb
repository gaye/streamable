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
    if params[:tags]
      params[:tags].each do |tag|
        streams_with_tag = Tag.find_by_name(tag).streams
        @streams ||= streams_with_tag
        @streams = @streams & streams_with_tag
        break if @streams.empty?
      end
    else
      @streams = Stream.all
    end
    
    respond_to do |format|
      format.html
      format.json { render :json => @streams }
    end
  end
  
  # GET /streams/1
  # GET /streams/1.json
  def show
    @stream = Stream.find(params[:id])
    # TODO(gaye): Lookup whether current user is publisher/subscriber
    
    respond_to do |format|
      format.html
      format.json { render :json => @stream }
    end
  end
  
  # GET /streams/new
  # GET /streams/new.json
  def new
    # TODO(gaye): Enforce permissions
    @stream = Stream.new

    respond_to do |format|
      format.html
      format.json { render :json => @stream }
    end
  end
  
  # GET /streams/1/edit
  def edit
    # TODO(gaye): Enforce permissions
    @stream = Stream.find(params[:id])
  end
  
  # POST /streams
  # POST /streams.json
  def create
    # TODO(gaye): Enforce permissions
    session, token = 
        OpenTokHelper::create_session_and_generate_publisher_token(current_user, request)
    params[:stream][:publisher_id] = current_user.id
    params[:stream][:opentok_session_id] = session.session_id
    params[:stream][:publisher_token] = token
    
    @stream = Stream.new(params[:stream])
    
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
    # TODO(gaye): Enforce permissions
    @stream = Stream.find(params[:id])

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
    # TODO(gaye): Enforce permissions
    @stream = Stream.find(params[:id])
    @stream.destroy

    respond_to do |format|
      format.html { redirect_to streams_url }
      format.json { head :no_content }
    end
  end
end
