=begin
  Handles the actions on the landing page
  Author : Gareth Aye (gareth@streamable.tv)
  Date : 04/21/12
=end
class HomeController < ApplicationController
  def index
    render :layout => 'home'
  end
end
