module ApplicationHelper
  def format_time(time)
    time.strftime("%I:%M %p on %-m/%d")
  end
  
  def format_name(user)
    "#{user.first_name} #{user.last_name}"
  end
end
