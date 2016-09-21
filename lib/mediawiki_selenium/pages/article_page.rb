require 'page-object'

class ArticlePage
  include PageObject
  # Wait until a Resource Loader module has loaded.
  #
  # @example
  #   on(WikiPage).wait_until_module_ready("mobile.talk")
  #
  # @param name [String] The name of the Resource Loader module
  def wait_until_rl_module_ready(name)
    wait_until do
      browser.execute_script("return mw.loader.getState('#{name}') === 'ready'")
    end
  end
end
