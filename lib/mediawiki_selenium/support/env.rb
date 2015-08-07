require 'bundler/setup'
require 'page-object/page_factory'
require 'watir-webdriver'

World { MediawikiSelenium::Environment.load_default }

World(MediawikiSelenium::ApiHelper)
World(MediawikiSelenium::PageFactory)
World(MediawikiSelenium::StrictPending)
World(MediawikiSelenium::UserFactoryHelper)
