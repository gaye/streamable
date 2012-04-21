=begin
  Provides a RESTful collection of actions on streams
  OpenTok is used to manage live video sessions
  Author : Gareth Aye (gareth@streamable.tv)
  Date : 04/21/12
=end
class StreamsController < ApplicationController
  def index
    # TODO(gaye)
  end
  
  def show
    # TODO(gaye)
  end
  
  def new
    # TODO(gaye)
  end
  
  def edit
    # TODO(gaye)
  end
  
  def create
    session, token = 
        OpenTok::Helper::create_session_and_generate_moderator_token(current_user, request)
    params[:stream][:publisher_id] = current_user.id
    params[:stream][:opentok_session_id] = session.session_id
    params[:stream][:publisher_token] = token
    
    @stream = Stream.new(params[:stream])
  end
  
  def update
    # TODO(gaye)
  end
  
  def destroy
    # TODO(gaye)
  end
end
