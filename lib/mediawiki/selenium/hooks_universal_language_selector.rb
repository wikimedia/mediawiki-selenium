=begin
This file is subject to the license terms in the LICENSE file found in the
mediawiki-selenium top-level directory of and at
https://github.com/zeljkofilipin/mediawiki-selenium/blob/master/LICENSE. No part of
mediawiki-selenium, including this file, may be copied, modified, propagated, or
distributed except according to the terms contained in the LICENSE file.
Copyright 2013 by the Mediawiki developers. See the CREDITS file in the
mediawiki-selenium top-level directory and at
https://github.com/zeljkofilipin/mediawiki-selenium/blob/master//CREDITS.
=end

Before('@language') do |scenario|
  p '@language'
  @language = true
  @scenario = scenario
end

Before('@uls-in-personal-only') do |scenario|
  if uls_position() != 'personal'
    scenario.skip_invoke!
  end
end

Before('@uls-in-sidebar-only') do |scenario|
  if uls_position() != 'interlanguage'
    scenario.skip_invoke!
  end
end

After('@reset-preferences-after') do |scenario|
  visit(ResetPreferencesPage)
  on(ResetPreferencesPage).submit_element.click
end
