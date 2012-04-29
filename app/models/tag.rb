=begin
  Author : Armaan Sarkar (armaan@streamable.tv)
  Date : 04/29/12
=end
class Tag < ActiveRecord::Base
  attr_accessible :name
  
  has_and_belongs_to_many :streams
end
