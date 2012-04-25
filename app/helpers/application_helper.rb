module ApplicationHelper
  def format_time(time)
    time.strftime("%I:%M %p on %-m/%d")
  end
end
