require 'watir-webdriver'

Before do
  @browser = Watir::Browser.new :firefox
  @browser.window.maximize
end

After do |scenario|
  if scenario.failed? then
    ext = Time.new.to_s.gsub(" ","").gsub(":","_")
    # Evidence file name is the feature file and line number suffixed with time stamp
    # replace the path separater, a . and : by an underscore character
    feature_line = scenario.location.to_s.gsub(/[\.\\\:]/,"_")
    @browser.screenshot.save "evidence/#{feature_line}-#{ext}.png"
  end
  @browser.close
end