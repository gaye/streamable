=begin
  Handles the actions on the landing page
  Author : Gareth Aye (gareth@streamable.tv)
  Date : 04/21/12
=end
class HomeController < ApplicationController
  # GET /
  def index
    if current_user
      redirect_to streams_path
    else
      render :layout => 'home'
    end
  end
end
