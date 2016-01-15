module OpeningTimesHelper
  def multi_line(times)
    times.gsub(' ', '<br/>').html_safe
  end
end
