require 'fileutils'

module MediawikiSelenium
  # Adds support to {Environment} for taking screenshots of the current
  # browser window. If `screenshot_failures` is set to `true` for the current
  # environment, one is automatically taken at the end of each failed
  # test case.
  #
  module ScreenshotHelper
    # Takes a screenshot of the given browser window and returns the path
    # to the saved image.
    #
    # @param browser [Watir::Browser] Browser to take a sceeenshot of.
    # @param name [String] Base name to use for the saved image file.
    #
    # @return [String] Path to the new screenshot.
    #
    def screenshot(browser, name)
      dir = screenshot_failures_path
      FileUtils.mkdir_p dir

      name = name.tr("#{File::SEPARATOR}\000", '-')

      path = File.join(dir, "#{name}.png")
      browser.screenshot.save(path)

      path
    end

    # Takes screenshots for failed tests.
    #
    # @param info [Hash] Test case information.
    #
    def teardown(info = {})
      screenshots = []

      artifacts = super(info) do |browser|
        if info[:status] == :failed && screenshot_failures?
          screenshots << screenshot(browser, info[:name] || 'scenario')
        end

        yield browser if block_given?
      end

      artifacts.merge(screenshots.each.with_object({}) { |img, arts| arts[img] = 'image/png' })
    end

    private

    def screenshot_failures?
      lookup(:screenshot_failures, default: false).to_s == 'true'
    end

    def screenshot_failures_path
      lookup(:screenshot_failures_path, default: 'screenshots')
    end
  end
end
