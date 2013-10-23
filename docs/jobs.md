# all jobs
- Browser Label:
- bundle exec:
- Recipients:
- Branch: master
- MediaWiki URL:
- Folder:
- MediaWiki user:
- MediaWiki password:
- Repository URL:



# browsertests
- Recipients: cmcmahon@wikimedia.org zfilipin@wikimedia.org
- Folder: root of the repository
- MediaWiki user: Selenium_user
- Repository URL: browsertests



# browsertests-commons.wikimedia.beta.wmflabs.org
- MediaWiki URL: commons.wikimedia.beta.wmflabs.org
- bundle exec: cucumber --verbose --profile ci --tags @commons.wikimedia.beta.wmflabs.org


## browsertests-commons.wikimedia.beta.wmflabs.org-linux-chrome
- Browser Label: chrome

## browsertests-commons.wikimedia.beta.wmflabs.org-linux-firefox
- Browser Label: firefox

## browsertests-commons.wikimedia.beta.wmflabs.org-windows-internet_explorer_6
- Browser Label: internet_explorer_6
- bundle exec: cucumber --verbose --profile ci --tags @commons.wikimedia.beta.wmflabs.org --tags ~@ie6-bug

## browsertests-commons.wikimedia.beta.wmflabs.org-windows-internet_explorer_7
- Browser Label: internet_explorer_7
- bundle exec: cucumber --verbose --profile ci --tags @commons.wikimedia.beta.wmflabs.org --tags ~@ie7-bug

## browsertests-commons.wikimedia.beta.wmflabs.org-windows-internet_explorer_8
- Browser Label: internet_explorer_8
- bundle exec: cucumber --verbose --profile ci --tags @commons.wikimedia.beta.wmflabs.org --tags ~@ie8-bug

## browsertests-commons.wikimedia.beta.wmflabs.org-windows-internet_explorer_9
- Browser Label: internet_explorer_9

## browsertests-commons.wikimedia.beta.wmflabs.org-windows-internet_explorer_10
- Browser Label: internet_explorer_10



# browsertests-en.wikipedia.beta.wmflabs.org
- bundle exec: cucumber --verbose --profile ci --tags @en.wikipedia.beta.wmflabs.org
- MediaWiki URL: en.wikipedia.beta.wmflabs.org


## browsertests-en.wikipedia.beta.wmflabs.org-linux-chrome
- Browser Label: chrome

## browsertests-en.wikipedia.beta.wmflabs.org-linux-firefox
- Browser Label: firefox

## browsertests-en.wikipedia.beta.wmflabs.org-windows-internet_explorer_6
- Browser Label: internet_explorer_6
- bundle exec: cucumber --verbose --profile ci --tags @en.wikipedia.beta.wmflabs.org --tags ~@ie6-bug

## browsertests-en.wikipedia.beta.wmflabs.org-windows-internet_explorer_7
- Browser Label: internet_explorer_7
- bundle exec: cucumber --verbose --profile ci --tags @en.wikipedia.beta.wmflabs.org --tags ~@ie7-bug

## browsertests-en.wikipedia.beta.wmflabs.org-windows-internet_explorer_8
- Browser Label: internet_explorer_8
- bundle exec: cucumber --verbose --profile ci --tags @en.wikipedia.beta.wmflabs.org --tags ~@ie8-bug

## browsertests-en.wikipedia.beta.wmflabs.org-windows-internet_explorer_9
- Browser Label: internet_explorer_9

## browsertests-en.wikipedia.beta.wmflabs.org-windows-internet_explorer_10
- Browser Label: internet_explorer_10



# browsertests-test2.wikipedia.org
- bundle exec: cucumber --verbose --profile ci --tags @test2.wikipedia.org
- MediaWiki URL: test2.wikipedia.org


## browsertests-test2.wikipedia.org-linux-chrome
- Browser Label: chrome

## browsertests-test2.wikipedia.org-linux-firefox
- Browser Label: firefox

## browsertests-test2.wikipedia.org-windows-internet_explorer_6
- Browser Label: internet_explorer_6
- bundle exec: cucumber --verbose --profile ci --tags @test2.wikipedia.org --tags ~@ie6-bug

## browsertests-test2.wikipedia.org-windows-internet_explorer_7
- Browser Label: internet_explorer_7
- bundle exec: cucumber --verbose --profile ci --tags @test2.wikipedia.org --tags ~@ie7-bug

## browsertests-test2.wikipedia.org-windows-internet_explorer_8
- Browser Label: internet_explorer_8
- bundle exec: cucumber --verbose --profile ci --tags @test2.wikipedia.org --tags ~@ie8-bug

## browsertests-test2.wikipedia.org-windows-internet_explorer_9
- Browser Label: internet_explorer_9

## browsertests-test2.wikipedia.org-windows-internet_explorer_10
- Browser Label: internet_explorer_10



# CirrusSearch-en.wikipedia.beta.wmflabs.org


## CirrusSearch-en.wikipedia.beta.wmflabs.org-linux-chrome
- Browser Label: chrome
- bundle exec: cucumber --verbose --profile ci
- Recipients: cmcmahon@wikimedia.org neverett@wikimedia.org zfilipin@wikimedia.org
- MediaWiki URL: en.wikipedia.beta.wmflabs.org
- Folder: tests/browser/
- MediaWiki user: Selenium_user
- Repository URL: CirrusSearch



# Flow
- bundle exec: cucumber --verbose --profile ci --tags @en.wikipedia.beta.wmflabs.org
- Recipients: zfilipin@wikimedia.org cmcmahon@wikimedia.org
- MediaWiki URL: en.m.wikipedia.beta.wmflabs.org
- Folder: tests/browser/
- MediaWiki user: Selenium_user
- Repository URL: Flow


## Flow-en.wikipedia.beta.wmflabs.org-linux-chrome
- Browser Label: chrome

## Flow-en.wikipedia.beta.wmflabs.org-linux-firefox
- Browser Label: firefox

## Flow-en.wikipedia.beta.wmflabs.org-linux-internet_explorer_10
- Browser Label: internet_explorer_10



# MobileFrontend
- bundle exec: cucumber --verbose --profile ci
- Folder: tests/acceptance/
- MediaWiki user: Selenium_user
- Repository URL: MobileFrontend


## MobileFrontend-en.m.wikipedia.beta.wmflabs.org-linux-chrome
- Browser Label: chrome
- Recipients: mgrover@wikimedia.org
- MediaWiki URL: en.m.wikipedia.beta.wmflabs.org

## MobileFrontend-en.m.wikipedia.beta.wmflabs.org-linux-firefox
- Browser Label: firefox
- Recipients: cmcmahon@wikimedia.org mgrover@wikimedia.org  mobile-l@lists.wikimedia.org mobile-tech@wikimedia.org zfilipin@wikimedia.org
- MediaWiki URL: en.m.wikipedia.beta.wmflabs.org

## MobileFrontend-en.m.wikipedia.org-linux-firefox
- Browser Label: firefox
- Recipients: cmcmahon@wikimedia.org mgrover@wikimedia.org  mobile-l@lists.wikimedia.org mobile-tech@wikimedia.org zfilipin@wikimedia.org
- MediaWiki URL: en.m.wikipedia.org

## MobileFrontend-test2.m.wikipedia.org-linux-firefox
- Browser Label: firefox
- Recipients: cmcmahon@wikimedia.org mgrover@wikimedia.org mobile-tech@wikimedia.org zfilipin@wikimedia.org
- MediaWiki URL: test2.m.wikipedia.org



# Translate


## Translate-sandbox.translatewiki.net-linux-firefox
- Browser Label: firefox
- bundle exec: cucumber --verbose --profile ci --tags @sandbox.translatewiki.net
- Recipients: aaharoni@wikimedia.org cmcmahon@wikimedia.org nlaxstrom@wikimedia.org smazeland@wikimedia.org zfilipin@wikimedia.org
- MediaWiki URL: sandbox.translatewiki.net
- Folder: tests/browser/
- MediaWiki user: Selenium
- Repository URL: Translate



# TwnMainPage


## TwnMainPage-sandbox.translatewiki.net-linux-firefox
- Browser Label: firefox
- bundle exec: cucumber --verbose --profile ci --tags @sandbox.translatewiki.net
- Recipients: aaharoni@wikimedia.org cmcmahon@wikimedia.org nlaxstrom@wikimedia.org smazeland@wikimedia.org zfilipin@wikimedia.org
- MediaWiki URL: sandbox.translatewiki.net
- Folder: tests/browser/
- MediaWiki user: Selenium
- Repository URL: TwnMainPage



# UniversalLanguageSelector
- Browser Label: firefox
- Recipients: aaharoni@wikimedia.org cmcmahon@wikimedia.org nlaxstrom@wikimedia.org smazeland@wikimedia.org sthottingal@wikimedia.org zfilipin@wikimedia.org
- Folder: tests/browser/
- Repository URL: UniversalLanguageSelector


## UniversalLanguageSelector-commons.wikimedia.beta.wmflabs.org-linux-firefox
- bundle exec: cucumber --verbose --profile ci --tags @commons.wikimedia.beta.wmflabs.org
- MediaWiki URL: commons.wikimedia.beta.wmflabs.org
- MediaWiki user: Uls

## UniversalLanguageSelector-sandbox.translatewiki.net-linux-firefox
- bundle exec: cucumber --verbose --profile ci --tags @sandbox.translatewiki.net
- MediaWiki URL: sandbox.translatewiki.net
- MediaWiki user: Selenium



# VisualEditor
- Folder: modules/ve-mw/test/browser/
- MediaWiki user: Selenium_user
- Repository URL: VisualEditor


## VisualEditor-en.wikipedia.beta.wmflabs.org-linux-chrome
- Browser Label: chrome
- bundle exec: cucumber --verbose --profile ci --tags @en.wikipedia.beta.wmflabs.org
- Recipients: cmcmahon@wikimedia.org zfilipin@wikimedia.org
- MediaWiki URL: en.wikipedia.beta.wmflabs.org

## VisualEditor-en.wikipedia.beta.wmflabs.org-linux-firefox
- Browser Label: firefox
- bundle exec: cucumber --verbose --profile ci --tags @en.wikipedia.beta.wmflabs.org
- Recipients: cmcmahon@wikimedia.org jforrester@wikimedia.org zfilipin@wikimedia.org
- MediaWiki URL: en.wikipedia.beta.wmflabs.org

## VisualEditor-test2.wikipedia.org-linux-chrome
- Browser Label: chrome
- bundle exec: cucumber --verbose --profile ci --tags @test2.wikipedia.org
- Recipients: cmcmahon@wikimedia.org zfilipin@wikimedia.org
- MediaWiki URL: test2.wikipedia.org

## VisualEditor-test2.wikipedia.org-linux-firefox
- Browser Label: firefox
- bundle exec: cucumber --verbose --profile ci --tags @test2.wikipedia.org
- Recipients: cmcmahon@wikimedia.org jforrester@wikimedia.org zfilipin@wikimedia.org
- MediaWiki URL: test2.wikipedia.org
