require 'fileutils'
require 'headless'

module MediawikiSelenium
  # Adds support to {Environment} for running sessions in a headless mode
  # using Xvfb. Video will be recorded for the display and saved for failed
  # scenarios if a `headless_capture_path` environment variable is configured.
  #
  module HeadlessHelper
    class << self
      # Creates a global headless display using the given environment's
      # configuration. If a display has already been created once before, it
      # is simply returned.
      #
      # @param env [Environment] Environment for which to start headless.
      #
      # @return [Headless]
      #
      def create_or_reuse_display(env)
        return @_display unless @_display.nil?

        options = { video: { provider: :libav, codec: 'libx264' } }

        display = env.lookup(:headless_display, default: nil)
        options[:display] = display unless display.nil?

        if env.lookup(:headless_reuse, default: true).to_s == 'false'
          options[:reuse] = false
        end

        if env.lookup(:headless_destroy_at_exit, default: true).to_s == 'false'
          options[:destroy_at_exit] = false
        end

        @_display = Headless.new(options)
        @_display.start

        @_display
      end

      # Destroys the global headless display created by {create_display}.
      #
      def destroy_display
        @_display.destroy if @_display
        @_display = nil
      end

      # Whether a global headless display has been created.
      #
      # @return [true, false]
      #
      def display_created?
        !@_display.nil?
      end
    end

    # Starts a headless display and starts recording before the {Environment}
    # opens a browser for the first time.
    #
    # @see Environment#browser
    #
    def browser
      @_headless_display = HeadlessHelper.create_or_reuse_display(self)

      if !@_headless_capture && headless_capture?
        @_headless_capture = true
        @_headless_display.video.start_capture
      end

      super
    end

    # Whether or not we should perform video capture of the headless display
    # for each new browser session.
    #
    # @return [true, false]
    #
    def headless_capture?
      !headless_capture_path.nil?
    end

    # Directory where screenshot/video files of headless sessions will be
    # saved. Defaults to writing them to a `log` directory under the workspace
    # directory.
    #
    # @return [String, nil]
    #
    def headless_capture_path
      lookup(:headless_capture_path, default: nil)
    end

    # Performs teardown tasks for headless operation, saving any video
    # captures to file.
    #
    # @see Environment#teardown
    #
    def teardown(info = {})
      super
    ensure
      if @_headless_capture
        if info[:status] == :failed
          dir = File.absolute_path(headless_capture_path)
          FileUtils.mkdir_p(dir)

          filename = "#{(info[:name] || 'scenario').tr("#{File::SEPARATOR}\000", '-')}.mp4"
          filename = File.join(dir, filename)

          @_headless_display.video.stop_and_save(filename)
        else
          @_headless_display.video.stop_and_discard
        end
      end
    end
  end
end
