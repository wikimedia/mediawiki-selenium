
When(/^upload bogus file (.+)$/) do |file_name|
  require "tempfile"
  path = "#{Dir.tmpdir}/#{file_name}"

  system("touch #{path}")
  if browser.driver.browser == :chrome
    browser.execute_script "document.getElementsByName('file')[0].removeAttribute('class');"
    browser.execute_script "document.getElementsByName('file')[0].removeAttribute('style');"
  end

  on(UploadPage).select_file = path
end


When(/^upload file (.+)$/) do |file_name|
  require "tempfile"
  path = "#{Dir.tmpdir}/#{file_name}"

  require "chunky_png"
  ChunkyPNG::Image.new(Random.new.rand(255), Random.new.rand(255), Random.new.rand(255)).save path

  if browser.driver.browser == :chrome
    browser.execute_script "document.getElementsByName('file')[0].removeAttribute('class');"
    browser.execute_script "document.getElementsByName('file')[0].removeAttribute('style');"
  end

  on(UploadPage).select_file = path
end
