module RpagesHelper
  def get_device_data
    {browser: browser.name, modern: browser.modern?, mobile: browser.device.mobile?, plattform: browser.platform.name }.to_json
  end

  def is_mobile?
    browser.device.mobile? || browser.device.ua.to_s.downcase.include?("mobile")
  rescue
    false
  end
end
