# Jenkins

## Plugins

- Jenkins > Manage Jenkins > Manage Plugins > Available > ChuckNorris Plugin, Green Balls, Jenkins instant-messaging plugin, Jenkins IRC Plugin

## IRC Notification

- Jenkins > Manage Jenkins > Configure System
- Enable IRC Notification > check
- Hostname: irc.freenode.net
- Port: 6667
- Channels
  - Name: #wikimedia-mobile
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

## Public Key

- Jenkins > Manage Jenkins > Configure System > CloudBees DEV@cloud Authorization > CloudBees Public Key > copy key
  - https://gerrit.wikimedia.org/r/#/settings/ssh-keys > Add Key ... > paste key > Add
