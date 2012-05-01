require 'spec_helper'

=begin
  Author : Gareth Aye (gareth@streamable.tv)
  Date : 04/29/12
=end
describe 'landing page' do
  GREETING = 'Education\'s Live Video Marketplace'
  
  before :each do
    visit '/users/logout'
  end
  
  it 'should have big greeting text' do
    visit '/'
    page.should have_content(GREETING)
  end
  
  it 'should have header with logo' do
    visit '/'
    page.has_selector?(:header).should be_true
    page.has_selector?(:logo).should be_true
  end
  
  it 'should have a sign up button' do
    visit '/'
    page.has_link?(:signup).should be_true
  end
  
  it 'should have a check it out link' do
    visit '/'
    page.has_link?(:checkit).should be_true
  end
end
