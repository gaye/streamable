require 'spec_helper'

=begin
  Author : Gareth Aye (gareth@streamable.tv)
  Date : 04/21/12
=end
describe Stream do
  fixtures :streams
  fixtures :tags
  
  before :each do
    @tags = [tags(:math).name, tags(:grade8).name]
    @streams = Stream.find_by_tags(@tags)
  end
  
  it 'should return the appropriate, filtered streams' do
    @streams.should == [streams(:inequalities)]
  end
end

