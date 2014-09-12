module MediawikiSelenium
  # Implements a stricter version of `pending` that fails when a given block
  # of expectations passes, alerting the user that the step definition should
  # no longer be pending.
  #
  module StrictPending
    class Pending < StandardError
    end

    # Delegates to Cucumber's pending but re-raises any `Cucumber::Pending`
    # exception as a strict failure.
    #
    def pending(*args)
      super
    rescue Cucumber::Pending => e
      if block_given?
        raise Pending, e.message
      else
        raise e
      end
    end
  end
end
