=begin
This file is subject to the license terms in the LICENSE file found in the
mediawiki_selenium top-level directory and at
https://git.wikimedia.org/blob/mediawiki%2Fselenium/HEAD/LICENSE. No part of
mediawiki_selenium, including this file, may be copied, modified, propagated, or
distributed except according to the terms contained in the LICENSE file.
Copyright 2013 by the Mediawiki developers. See the CREDITS file in the
mediawiki_selenium top-level directory and at
https://git.wikimedia.org/blob/mediawiki%2Fselenium/HEAD/CREDITS.
=end

Before("@custom-browser") do |scenario|
  @scenario = scenario
end

Before("@login") do
  ENV["MEDIAWIKI_PASSWORD"] = ENV[ENV["MEDIAWIKI_PASSWORD_VARIABLE"]] if ENV["MEDIAWIKI_PASSWORD_VARIABLE"]
  puts "MEDIAWIKI_USER environment variable is not defined! Please export a value for that variable before proceeding." unless ENV["MEDIAWIKI_USER"]
  puts "MEDIAWIKI_PASSWORD environment variable is not defined! Please export a value for that variable before proceeding." unless ENV["MEDIAWIKI_PASSWORD"]
end

# Install a formatter that can be used to show feature-related warnings
AfterConfiguration do |config|
  pretty_format, io = config.formats.find { |(format, io)| format == "pretty" }
  config.formats << ["MediawikiSelenium::WarningsFormatter", io] if pretty_format
end

# Enforce a dependency check for all scenarios tagged with @extension- tags
Before do |scenario|
  # Backgrounds themselves don't have tags, so get them from the feature
  if scenario.is_a?(Cucumber::Ast::Background)
    tag_source = scenario.feature
  else
    tag_source = scenario
  end

  tags = tag_source.source_tag_names
  dependencies = tags.map { |tag| tag.match(/^@extension-(.+)$/) { |m| m[1].downcase } }.compact

  unless dependencies.empty?
    extensions = api.meta(:siteinfo, siprop: "extensions").data["extensions"]
    extensions = extensions.map { |ext| ext["name"] }.compact.map(&:downcase)
    missing = dependencies - extensions

    if missing.any?
      scenario.skip_invoke!

      if scenario.feature.respond_to?(:mw_warn)
        warning = "Skipped feature due to missing wiki extensions: #{missing.join(", ")}"
        scenario.feature.mw_warn(warning, "missing wiki extensions")
      end
    end
  end
end

Before do |scenario|
  @random_string = Random.new.rand.to_s

  # CirrusSearch and VisualEditor need this
  if ENV["REUSE_BROWSER"] == "true" && $browser
    @browser = $browser
  elsif scenario.source_tag_names.include? "@custom-browser"
    # browser will be started in Cucumber step
  else
    @browser = browser(test_name(scenario))
    $browser = @browser # CirrusSearch and VisualEditor need this
  end

  $session_id = sauce_session_id
end

After do |scenario|
  if @browser && scenario.failed? && (ENV["SCREENSHOT_FAILURES"] == "true")
    require "fileutils"
    screen_dir = ENV["SCREENSHOT_FAILURES_PATH"] || "screenshots"
    FileUtils.mkdir_p screen_dir
    name = test_name(scenario).gsub(/ /, '_')
    path = "#{screen_dir}/#{name}.png"
    @browser.screenshot.save path
    embed path, "image/png"
  end

  if environment == :saucelabs
    sid = $session_id || sauce_session_id
    sauce_api(%Q{{"passed": #{scenario.passed?}}}, sid)
    sauce_api(%Q{{"public": true}}, sid)
    sauce_api(%Q{{"build": #{ENV["BUILD_NUMBER"]}}}, sid) if ENV["BUILD_NUMBER"]
  end

  if @browser
    # CirrusSearch and VisualEditor need this
    @browser.close unless ENV["KEEP_BROWSER_OPEN"] == "true" || ENV["REUSE_BROWSER"] == "true"
  end
end
