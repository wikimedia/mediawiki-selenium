require 'page-object'

class ResetPreferencesPage
  include PageObject

  page_url 'Special:Preferences/reset'

  button(:submit, css: 'input.mw-htmlform-submit, .mw-htmlform-submit button')
end
