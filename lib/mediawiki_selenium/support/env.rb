# before all
require 'bundler/setup'
require 'page-object/page_factory'
require 'watir-webdriver'

require 'mediawiki_selenium/support/modules/api_helper'
require 'mediawiki_selenium/support/modules/strict_pending'

World { MediawikiSelenium::Environment.load_default }

World(MediawikiSelenium::ApiHelper)
World(MediawikiSelenium::PageFactory)
World(MediawikiSelenium::StrictPending)
