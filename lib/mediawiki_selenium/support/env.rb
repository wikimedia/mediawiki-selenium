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

# before all
require "bundler/setup"
require "page-object/page_factory"
require "watir-webdriver"

require "mediawiki_selenium/support/modules/api_helper"
require "mediawiki_selenium/support/modules/strict_pending"

World { MediawikiSelenium::Environment.load_default }

World(MediawikiSelenium::ApiHelper)
World(MediawikiSelenium::PageFactory)
World(MediawikiSelenium::StrictPending)
