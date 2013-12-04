# Template

## Setup

- Jenkins > Templates > New Template > (name) > Job Template > OK > Save
- Display Name: (name)
- Description: (description)
- Instantiable?: check
- Attribute

## Name

- ID: name
- Display Name: Name
- Type: Text-field

## Browser Label

- ID: BROWSER_LABEL
- Display Name: Browser Label
- Type: Select a string among many
- UI Mode: Dropdown list (no inline help, but more compact UI)
- Options
  - Display Name: (name)
  - Value: (name)
    - chrome
    - firefox
    - internet_explorer_6
    - internet_explorer_7
    - internet_explorer_8
    - internet_explorer_9
    - internet_explorer_10

## bundle exec

- ID: BUNDLE_EXEC
- Display Name: bundle exec
- Type: Text-field

## Recipients

- ID: RECIPIENTS
- Display Name: Recipients
- Type: Text-field

## Repository URL

- ID: REPOSITORY_URL
- Display Name: Repository URL
- Type: Select a string among many
- UI Mode: Dropdown list (no inline help, but more compact UI)
- Options

  - Display Name: browsertests
  - Value: https://gerrit.wikimedia.org/r/qa/browsertests

  - Display Name: CirrusSearch
  - Value: https://gerrit.wikimedia.org/r/mediawiki/extensions/CirrusSearch

  - Display Name: Flow
  - Value: https://gerrit.wikimedia.org/r/mediawiki/extensions/Flow

  - Display Name: MobileFrontend
  - Value: https://gerrit.wikimedia.org/r/mediawiki/extensions/MobileFrontend

  - Display Name: Translate
  - Value: https://gerrit.wikimedia.org/r/mediawiki/extensions/Translate

  - Display Name: TwnMainPage
  - Value: https://gerrit.wikimedia.org/r/mediawiki/extensions/TwnMainPage

  - Display Name: UniversalLanguageSelector
  - Value: https://gerrit.wikimedia.org/r/mediawiki/extensions/UniversalLanguageSelector

  - Display Name: VisualEditor
  - Value: https://gerrit.wikimedia.org/r/mediawiki/extensions/VisualEditor

## Branch

- ID: BRANCH
- Display Name: Branch
- Type: Select a string among many
- UI Mode: Dropdown list (no inline help, but more compact UI)
- Options
  - Display Name: (name)
  - Value: (name)

  - name:
    - debug
    - master

## MediaWiki URL

- ID: MEDIAWIKI_URL
- Display Name: MediaWiki URL
- Type: Select a string among many
- UI Mode: Dropdown list (no inline help, but more compact UI)
- Options
  - Display Name: (name)
  - Value: (name)

  - name:
    - commons.wikimedia.beta.wmflabs.org
    - dev.translatewiki.net
    - en.m.wikipedia.beta.wmflabs.org
    - en.m.wikipedia.org
    - en.wikipedia.beta.wmflabs.org
    - en.wikipedia.org
    - meta.wikimedia.org
    - sandbox.translatewiki.net
    - test2.m.wikipedia.org
    - test2.wikipedia.org

## Folder

- ID: FOLDER
- Display Name: Folder
- Type: Select a string among many
- UI Mode: Dropdown list (no inline help, but more compact UI)
- Options
  - Display Name: (name)
  - Value: (name)

  - name:
    - (empty)
    - modules/ve-mw/test/browser/
    - tests/browser/

## MediaWiki user

- ID: MEDIAWIKI_USER
- Display Name: MediaWiki user
- Type: Text-field

## MediaWiki password variable

- ID: MEDIAWIKI_PASSWORD_VARIABLE
- Display Name: MediaWiki password variable
- Type: Text-field

## Jelly-based transformation

- Property
  - Transformer: Jelly-based transformation
  - Script, from (site)/job/(job)/config.xml

--

    <?xml version='1.0' encoding='UTF-8'?>
    <project>
      <actions/>
      <description></description>
      <logRotator>
        <daysToKeep>60</daysToKeep>
        <numToKeep>-1</numToKeep>
        <artifactDaysToKeep>-1</artifactDaysToKeep>
        <artifactNumToKeep>20</artifactNumToKeep>
      </logRotator>
      <keepDependencies>false</keepDependencies>
      <properties>
        <nectar.plugins.rbac.groups.JobProxyGroupContainer>
          <groups/>
        </nectar.plugins.rbac.groups.JobProxyGroupContainer>
        <com.cloudbees.jenkins.plugins.PublicKey/>
        <com.cloudbees.plugins.deployer.DeployNowJobProperty>
          <oneClickDeploy>false</oneClickDeploy>
          <configuration>
            <user>(jenkins)</user>
            <account>wmf</account>
            <deployables/>
          </configuration>
        </com.cloudbees.plugins.deployer.DeployNowJobProperty>
      </properties>
      <scm class="hudson.plugins.git.GitSCM">
        <configVersion>2</configVersion>
        <userRemoteConfigs>
          <hudson.plugins.git.UserRemoteConfig>
            <name></name>
            <refspec></refspec>
            <url>${REPOSITORY_URL}</url>
          </hudson.plugins.git.UserRemoteConfig>
        </userRemoteConfigs>
        <branches>
          <hudson.plugins.git.BranchSpec>
            <name>${BRANCH}</name>
          </hudson.plugins.git.BranchSpec>
        </branches>
        <disableSubmodules>false</disableSubmodules>
        <recursiveSubmodules>false</recursiveSubmodules>
        <doGenerateSubmoduleConfigurations>false</doGenerateSubmoduleConfigurations>
        <authorOrCommitter>false</authorOrCommitter>
        <clean>false</clean>
        <wipeOutWorkspace>false</wipeOutWorkspace>
        <pruneBranches>false</pruneBranches>
        <remotePoll>false</remotePoll>
        <ignoreNotifyCommit>false</ignoreNotifyCommit>
        <useShallowClone>false</useShallowClone>
        <buildChooser class="hudson.plugins.git.util.DefaultBuildChooser"/>
        <gitTool>Default</gitTool>
        <submoduleCfg class="list"/>
        <relativeTargetDir></relativeTargetDir>
        <reference></reference>
        <excludedRegions></excludedRegions>
        <excludedUsers></excludedUsers>
        <gitConfigName></gitConfigName>
        <gitConfigEmail></gitConfigEmail>
        <skipTag>false</skipTag>
        <includedRegions></includedRegions>
        <scmName></scmName>
      </scm>
      <canRoam>true</canRoam>
      <disabled>false</disabled>
      <blockBuildWhenDownstreamBuilding>false</blockBuildWhenDownstreamBuilding>
      <blockBuildWhenUpstreamBuilding>false</blockBuildWhenUpstreamBuilding>
      <triggers class="vector">
        <hudson.triggers.TimerTrigger>
          <spec>0 3,18 * * *</spec>
        </hudson.triggers.TimerTrigger>
      </triggers>
      <concurrentBuild>false</concurrentBuild>
      <builders>
        <hudson.tasks.Shell>
          <command>
            export MEDIAWIKI_USER=${MEDIAWIKI_USER}
            export MEDIAWIKI_PASSWORD_VARIABLE=${MEDIAWIKI_PASSWORD_VARIABLE}

            export BROWSER_LABEL=${BROWSER_LABEL}
            export MEDIAWIKI_URL=http://${MEDIAWIKI_URL}/wiki/

            curl -s -o use-ruby https://repository-cloudbees.forge.cloudbees.com/distributions/ci-addons/ruby/use-ruby
            RUBY_VERSION=2.0.0-p247 \
              source ./use-ruby

            gem install bundler --no-ri --no-rdoc
            if [ -d "${FOLDER}" ]; then cd ${FOLDER}; fi
            bundle install
            bundle exec ${BUNDLE_EXEC}
          </command>
        </hudson.tasks.Shell>
      </builders>
      <publishers>
        <hudson.tasks.junit.JUnitResultArchiver>
          <testResults>${FOLDER}reports/junit/*.xml</testResults>
          <keepLongStdio>false</keepLongStdio>
          <testDataPublishers/>
        </hudson.tasks.junit.JUnitResultArchiver>
        <hudson.tasks.Mailer>
          <recipients>${RECIPIENTS}</recipients>
          <dontNotifyEveryUnstableBuild>false</dontNotifyEveryUnstableBuild>
          <sendToIndividuals>false</sendToIndividuals>
        </hudson.tasks.Mailer>
        <hudson.plugins.ircbot.IrcPublisher plugin="ircbot@2.21">
          <targets class="java.util.Collections$EmptyList"/>
          <strategy>STATECHANGE_ONLY</strategy>
          <notifyOnBuildStart>false</notifyOnBuildStart>
          <notifySuspects>false</notifySuspects>
          <notifyCulprits>false</notifyCulprits>
          <notifyFixers>false</notifyFixers>
          <notifyUpstreamCommitters>false</notifyUpstreamCommitters>
          <buildToChatNotifier class="hudson.plugins.im.build_notify.SummaryOnlyBuildToChatNotifier" plugin="instant-messaging@1.25"/>
          <matrixMultiplier>ONLY_CONFIGURATIONS</matrixMultiplier>
          <channels/>
        </hudson.plugins.ircbot.IrcPublisher>
      </publishers>
      <buildWrappers/>
      <executionStrategy class="hudson.matrix.DefaultMatrixExecutionStrategyImpl">
        <runSequentially>false</runSequentially>
      </executionStrategy>
    </project>

--

## Save

- Save
