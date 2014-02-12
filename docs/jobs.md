# all jobs
- Browser Label:
- bundle exec cucumber:
- Recipients:
- MediaWiki URL:
- Folder: tests/browser/ (if not stated differently)
- Repository URL:
- MediaWiki user:
- MediaWiki password variable:
- Build schedule: 0 3,18 * * * (if not stated differently)



# browsertests
- Recipients: cmcmahon@wikimedia.org zfilipin@wikimedia.org
- Repository URL: browsertests
- MediaWiki user: Selenium_user


# browsertests-en.wikipedia.beta.wmflabs.org
- bundle exec cucumber: --tags @en.wikipedia.beta.wmflabs.org
- MediaWiki URL: en.wikipedia.beta.wmflabs.org
- MediaWiki password variable: MEDIAWIKI_PASSWORD_SELENIUM_USER_WMFLABS_ORG

## browsertests-en.wikipedia.beta.wmflabs.org-linux-chrome
- Browser Label: chrome

## browsertests-en.wikipedia.beta.wmflabs.org-linux-firefox
- Browser Label: firefox

## browsertests-en.wikipedia.beta.wmflabs.org-windows-internet_explorer_6
- Browser Label: internet_explorer_6
- bundle exec cucumber: --tags @en.wikipedia.beta.wmflabs.org --tags ~@ie6-bug

## browsertests-en.wikipedia.beta.wmflabs.org-windows-internet_explorer_7
- Browser Label: internet_explorer_7
- bundle exec cucumber: --tags @en.wikipedia.beta.wmflabs.org --tags ~@ie7-bug

## browsertests-en.wikipedia.beta.wmflabs.org-windows-internet_explorer_8
- Browser Label: internet_explorer_8
- bundle exec cucumber: --tags @en.wikipedia.beta.wmflabs.org --tags ~@ie8-bug

## browsertests-en.wikipedia.beta.wmflabs.org-windows-internet_explorer_9
- Browser Label: internet_explorer_9

## browsertests-en.wikipedia.beta.wmflabs.org-windows-internet_explorer_10
- Browser Label: internet_explorer_10


# browsertests-test2.wikipedia.org
- bundle exec cucumber: --tags @test2.wikipedia.org
- MediaWiki URL: test2.wikipedia.org
- MediaWiki password variable: MEDIAWIKI_PASSWORD_SELENIUM_USER_WIKIPEDIA_ORG

## browsertests-test2.wikipedia.org-linux-chrome
- Browser Label: chrome

## browsertests-test2.wikipedia.org-linux-firefox
- Browser Label: firefox

## browsertests-test2.wikipedia.org-windows-internet_explorer_6
- Browser Label: internet_explorer_6
- bundle exec cucumber: --tags @test2.wikipedia.org --tags ~@ie6-bug

## browsertests-test2.wikipedia.org-windows-internet_explorer_7
- Browser Label: internet_explorer_7
- bundle exec cucumber: --tags @test2.wikipedia.org --tags ~@ie7-bug

## browsertests-test2.wikipedia.org-windows-internet_explorer_8
- Browser Label: internet_explorer_8
- bundle exec cucumber: --tags @test2.wikipedia.org --tags ~@ie8-bug

## browsertests-test2.wikipedia.org-windows-internet_explorer_9
- Browser Label: internet_explorer_9

## browsertests-test2.wikipedia.org-windows-internet_explorer_10
- Browser Label: internet_explorer_10



# Flow
- bundle exec cucumber: --tags @en.wikipedia.beta.wmflabs.org
- Recipients: zfilipin@wikimedia.org cmcmahon@wikimedia.org
- MediaWiki URL: en.m.wikipedia.beta.wmflabs.org
- Repository URL: Flow
- MediaWiki user: Selenium_user
- MediaWiki password variable: MEDIAWIKI_PASSWORD_SELENIUM_USER_WMFLABS_ORG

## Flow-en.wikipedia.beta.wmflabs.org-linux-chrome
- Browser Label: chrome

## Flow-en.wikipedia.beta.wmflabs.org-linux-firefox
- Browser Label: firefox



# MobileFrontend
- Recipients: cmcmahon@wikimedia.org jhall@wikimedia.org mobile-l@lists.wikimedia.org mobile-tech@wikimedia.org zfilipin@wikimedia.org
- Repository URL: MobileFrontend
- MediaWiki user: Selenium_user

## MobileFrontend-en.m.wikipedia.beta.wmflabs.org-linux-chrome
- Browser Label: chrome
- bundle exec cucumber: --tags @en.m.wikipedia.beta.wmflabs.org
- MediaWiki URL: en.m.wikipedia.beta.wmflabs.org
- MediaWiki password variable: MEDIAWIKI_PASSWORD_SELENIUM_USER_WMFLABS_ORG

## MobileFrontend-en.m.wikipedia.beta.wmflabs.org-linux-firefox
- Browser Label: firefox
- bundle exec cucumber: --tags @en.m.wikipedia.beta.wmflabs.org
- MediaWiki URL: en.m.wikipedia.beta.wmflabs.org
- MediaWiki password variable: MEDIAWIKI_PASSWORD_SELENIUM_USER_WMFLABS_ORG

## MobileFrontend-en.m.wikipedia.org-linux-firefox
- Browser Label: firefox
- bundle exec cucumber: --tags @en.m.wikipedia.org
- MediaWiki URL: en.m.wikipedia.org
- MediaWiki password variable: MEDIAWIKI_PASSWORD_SELENIUM_USER_WIKIPEDIA_ORG

## MobileFrontend-test2.m.wikipedia.org-linux-firefox
- Browser Label: firefox
- bundle exec cucumber: --tags @test2.m.wikipedia.org
- MediaWiki URL: test2.m.wikipedia.org
- MediaWiki password variable: MEDIAWIKI_PASSWORD_SELENIUM_USER_WIKIPEDIA_ORG



# MultimediaViewer

## MultimediaViewer-en.wikipedia.beta.wmflabs.org-linux-firefox
- Browser Label: firefox
- bundle exec cucumber: --tags @en.wikipedia.beta.wmflabs.org
- Recipients: aarcos.wiki@gmail.com cmcmahon@wikimedia.org jhall@wikimedia.org zfilipin@wikimedia.org
- MediaWiki URL: en.wikipedia.beta.wmflabs.org
- Repository URL: MultimediaViewer
- MediaWiki user: Selenium_user
- MediaWiki password variable: MEDIAWIKI_PASSWORD_SELENIUM_USER_WMFLABS_ORG
- Build schedule: 0 3,18 * * *



# Translate
- Browser Label: firefox
- Recipients: aaharoni@wikimedia.org cmcmahon@wikimedia.org nlaxstrom@wikimedia.org zfilipin@wikimedia.org
- Repository URL: Translate

## Translate-sandbox.translatewiki.net-linux-firefox
- bundle exec cucumber: --tags @sandbox.translatewiki.net
- MediaWiki URL: sandbox.translatewiki.net
- MediaWiki user: Selenium-Translate
- MediaWiki password variable: MEDIAWIKI_PASSWORD_SELENIUM_SANDBOX_TRANSLATE_TRANSLATEWIKI_NET

## Translate-meta.wikimedia.org-linux-firefox
- bundle exec cucumber: --tags @meta.wikimedia.org
- MediaWiki URL: meta.wikimedia.org



# TwnMainPage

## TwnMainPage-sandbox.translatewiki.net-linux-firefox
- Browser Label: firefox
- bundle exec cucumber: --tags @sandbox.translatewiki.net
- Recipients: aaharoni@wikimedia.org cmcmahon@wikimedia.org nlaxstrom@wikimedia.org zfilipin@wikimedia.org
- MediaWiki URL: sandbox.translatewiki.net
- Repository URL: TwnMainPage
- MediaWiki user: Selenium
- MediaWiki password variable: MEDIAWIKI_PASSWORD_SELENIUM_SANDBOX_TRANSLATEWIKI_NET



# UniversalLanguageSelector
- Browser Label: firefox
- Recipients: aaharoni@wikimedia.org cmcmahon@wikimedia.org nlaxstrom@wikimedia.org sthottingal@wikimedia.org zfilipin@wikimedia.org
- Repository URL: UniversalLanguageSelector

## UniversalLanguageSelector-commons.wikimedia.beta.wmflabs.org-linux-firefox
- bundle exec cucumber: --tags @commons.wikimedia.beta.wmflabs.org
- MediaWiki URL: commons.wikimedia.beta.wmflabs.org
- MediaWiki user: Uls
- MediaWiki password variable: MEDIAWIKI_PASSWORD_ULS_WMFLABS_ORG

## UniversalLanguageSelector-en.wikipedia.beta.wmflabs.org-linux-firefox
- bundle exec cucumber: --tags @en.wikipedia.beta.wmflabs.org
- MediaWiki URL: en.wikipedia.beta.wmflabs.org
- MediaWiki user: Uls
- MediaWiki password variable: MEDIAWIKI_PASSWORD_ULS_WMFLABS_ORG

## UniversalLanguageSelector-sandbox.translatewiki.net-linux-firefox
- bundle exec cucumber: --tags @sandbox.translatewiki.net
- MediaWiki URL: sandbox.translatewiki.net
- MediaWiki user: Selenium
- MediaWiki password variable: MEDIAWIKI_PASSWORD_SELENIUM_SANDBOX_TRANSLATEWIKI_NET



# UploadWizard

# UploadWizard-commons.wikimedia.beta.wmflabs.org
- bundle exec cucumber: --tags @commons.wikimedia.beta.wmflabs.org
- Recipients: cmcmahon@wikimedia.org zfilipin@wikimedia.org
- MediaWiki URL: commons.wikimedia.beta.wmflabs.org
- Repository URL: UploadWizard
- MediaWiki user: Selenium_user
- MediaWiki password variable: MEDIAWIKI_PASSWORD_SELENIUM_USER_WMFLABS_ORG

## UploadWizard-commons.wikimedia.beta.wmflabs.org-linux-chrome
- Browser Label: chrome

## UploadWizard-commons.wikimedia.beta.wmflabs.org-linux-firefox
- Browser Label: firefox

## UploadWizard-commons.wikimedia.beta.wmflabs.org-windows-internet_explorer_9
- Browser Label: internet_explorer_9

## UploadWizard-commons.wikimedia.beta.wmflabs.org-windows-internet_explorer_10
- Browser Label: internet_explorer_10



# VisualEditor
- Folder: modules/ve-mw/test/browser/
- Repository URL: VisualEditor
- MediaWiki user: Selenium_user

## VisualEditor-en.wikipedia.beta.wmflabs.org-linux-chrome
- Browser Label: chrome
- bundle exec cucumber: --tags @en.wikipedia.beta.wmflabs.org
- Recipients: cmcmahon@wikimedia.org jhall@wikimedia.org zfilipin@wikimedia.org
- MediaWiki URL: en.wikipedia.beta.wmflabs.org
- MediaWiki password variable: MEDIAWIKI_PASSWORD_SELENIUM_USER_WMFLABS_ORG

## VisualEditor-en.wikipedia.beta.wmflabs.org-linux-firefox
- Browser Label: firefox
- bundle exec cucumber: --tags @en.wikipedia.beta.wmflabs.org
- Recipients: cmcmahon@wikimedia.org jforrester@wikimedia.org jhall@wikimedia.org zfilipin@wikimedia.org
- MediaWiki URL: en.wikipedia.beta.wmflabs.org
- MediaWiki password variable: MEDIAWIKI_PASSWORD_SELENIUM_USER_WMFLABS_ORG

## VisualEditor-test2.wikipedia.org-linux-chrome
- Browser Label: chrome
- bundle exec cucumber: --tags @test2.wikipedia.org
- Recipients: cmcmahon@wikimedia.org jhall@wikimedia.org zfilipin@wikimedia.org
- MediaWiki URL: test2.wikipedia.org
- MediaWiki password variable: MEDIAWIKI_PASSWORD_SELENIUM_USER_WIKIPEDIA_ORG

## VisualEditor-test2.wikipedia.org-linux-firefox
- Browser Label: firefox
- bundle exec cucumber: --tags @test2.wikipedia.org
- Recipients: cmcmahon@wikimedia.org jforrester@wikimedia.org jhall@wikimedia.org zfilipin@wikimedia.org
- MediaWiki URL: test2.wikipedia.org
- MediaWiki password variable: MEDIAWIKI_PASSWORD_SELENIUM_USER_WIKIPEDIA_ORG
