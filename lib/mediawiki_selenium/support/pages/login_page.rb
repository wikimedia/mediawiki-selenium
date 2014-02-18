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

class LoginPage
  include PageObject

  include URL
  page_url URL.url("Special:UserLogin")

  div(:feedback, class: "errorbox")
  button(:login, id: "wpLoginAttempt")
  a(:logout_link, text: "Log out")
  text_field(:password, id: "wpPassword1")
  a(:password_strength, text: "password strength")
  a(:phishing, text: "phishing")
  text_field(:username, id: "wpName1")
  a(:username_displayed, title: /Your user page/)

  def logged_in_as_element
    @browser.div(id: "mw-content-text").p.b
  end
  def login_with(username, password)
    self.username_element.when_present.send_keys(username)
    self.password_element.when_present.send_keys(password)
    login_element.fire_event("onfocus")
    login_element.when_present.click
    logout_link_element.when_present
  end
end
