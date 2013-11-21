# Jenkins

## Plugins

- Jenkins > Manage Jenkins > Manage Plugins > Available > ChuckNorris Plugin, Green Balls, Jenkins instant-messaging plugin, Jenkins IRC Plugin

## IRC Notification

- Jenkins > Manage Jenkins > Configure System
- Enable IRC Notification > check
- Hostname: irc.freenode.net
- Port: 6667
- Channels
  - Name: #wikimedia-qa
  - Notification only: check
- Advanced...
  - Nickname: wmf-selenium-bot
  - Login: wmf-selenium-bot
  - nickname and login have to be the same

## Environment variables

- Jenkins > Manage Jenkins > Configure System > Global properties > Environment variables > List of key-value pairs
  - name
    - SAUCE_ONDEMAND_ACCESS_KEY
    - SAUCE_ONDEMAND_USERNAME
    - MEDIAWIKI_PASSWORD_SELENIUM_SANDBOX_TRANSLATEWIKI_NET
    - MEDIAWIKI_PASSWORD_SELENIUM_USER_WIKIPEDIA_ORG
    - MEDIAWIKI_PASSWORD_SELENIUM_USER_WMFLABS_ORG
    - MEDIAWIKI_PASSWORD_ULS_WMFLABS_ORG
