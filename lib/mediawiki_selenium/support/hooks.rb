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

AfterConfiguration do |config|
  # Install a formatter that can be used to show feature-related warnings
  pretty_format, io = config.formats.find { |(format, _io)| format == "pretty" }
  config.formats << ["MediawikiSelenium::WarningsFormatter", io] if pretty_format

  # Initiate headless mode
  if ENV["HEADLESS"] == "true"
    require "headless"

    headless_options = {}.tap do |options|
      options[:display] = ENV["HEADLESS_DISPLAY"] if ENV.include?("HEADLESS_DISPLAY")
      options[:reuse] = false if ENV["HEADLESS_REUSE"] == "false"
      options[:destroy_at_exit] = false if ENV["HEADLESS_DESTROY_AT_EXIT"] == "false"
    end

    headless = Headless.new(headless_options)
    headless.start
  end
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
  # Create a unique random string for this scenario
  @random_string = Random.new.rand.to_s

  # Annotate sessions with the scenario name and Jenkins build info
  browser_factory.bind do |options|
    options[:desired_capabilities][:name] = test_name(scenario)
  end

  browser_factory.bind(:job_name) do |job, options|
    options[:desired_capabilities][:name] += " #{job}"
  end

  browser_factory.bind(:build_number) do |build, options|
    options[:desired_capabilities][:name] += "##{build}"
  end
end

After do |scenario|
  if scenario.respond_to?(:status)
    require "fileutils"

    teardown(scenario.status) do |browser|
      if scenario.failed? && lookup(:screenshot_failures, default: false) == "true"
        screen_dir = lookup(:screenshot_failures_path, default: "screenshots")
        FileUtils.mkdir_p screen_dir
        name = test_name(scenario).gsub(/ /, '_')
        path = "#{screen_dir}/#{name}.png"
        browser.screenshot.save path
        embed path, "image/png"
      end

    end
  else
    teardown
  end
end
