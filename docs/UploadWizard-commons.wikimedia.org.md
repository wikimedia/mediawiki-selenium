# UploadWizard-commons.wikimedia.org

- Jenkins > New Job
  - Job name: UploadWizard-commons.wikimedia.org
  - Build a free-style software project
  - OK
- Jenkins > Job > Configure
  - Source Code Management > Git > Repositories > Repository URL: https://gerrit.wikimedia.org/r/mediawiki/extensions/UploadWizard
  - Build Triggers > Build periodically > Schedule: H */6 * * * (every 6 hours)
  - Build > Add build step > Execute shell

--

    git fetch https://gerrit.wikimedia.org/r/mediawiki/extensions/UploadWizard refs/changes/61/109661/6 && git checkout FETCH_HEAD
    export MEDIAWIKI_PASSWORD_VARIABLE=MEDIAWIKI_PASSWORD_SELENIUM_USER_WIKIPEDIA_ORG
    virtualenv --distribute DEV
    DEV/bin/pip install -rtests/api/requirements.txt
    DEV/bin/python tests/api/upload-wizard_tests.py --username "Selenium_user" --api_url "https://commons.wikimedia.org/w/api.php"

--

  - Add post-build action
    - E-mail Notification > Recipients > aarcos.wiki@gmail.com cmcmahon@wikimedia.org gtisza@wikimedia.org zfilipin@wikimedia.org
    - IRC Notification (notifies #wikimedia-qa by default)



# UploadWizard-commons.wikimedia.beta.wmflabs.org

- Jenkins > New Job
  - Job name: UploadWizard-commons.wikimedia.beta.wmflabs.org
  - Build a free-style software project
  - OK
- Jenkins > Job > Configure
  - Source Code Management > Git > Repositories > Repository URL: https://gerrit.wikimedia.org/r/mediawiki/extensions/UploadWizard
  - Build Triggers > Poll SCM > Schedule > * * * * * (every minute)
  - Build > Add build step > Execute shell

--

    git fetch https://gerrit.wikimedia.org/r/mediawiki/extensions/UploadWizard refs/changes/61/109661/6 && git checkout FETCH_HEAD
    export MEDIAWIKI_PASSWORD_VARIABLE=MEDIAWIKI_PASSWORD_SELENIUM_USER_WMFLABS_ORG
    virtualenv --distribute DEV
    DEV/bin/pip install -rtests/api/requirements.txt
    DEV/bin/python tests/api/upload-wizard_tests.py --username "Selenium_user" --api_url "http://commons.wikimedia.beta.wmflabs.org/w/api.php"

--

  - Add post-build action
    - E-mail Notification > Recipients > aarcos.wiki@gmail.com cmcmahon@wikimedia.org gtisza@wikimedia.org zfilipin@wikimedia.org
    - IRC Notification (notifies #wikimedia-qa by default)