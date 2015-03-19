require 'spec_helper'

module MediawikiSelenium
  describe Environment do
    subject { env }

    let(:env) { Environment.new(config) }
    let(:config) { minimum_config }

    let(:minimum_config) do
      {
        browser: browser,
        mediawiki_api_url: mediawiki_api_url,
        mediawiki_url: mediawiki_url,
        mediawiki_user: mediawiki_user,
        mediawiki_password: mediawiki_password
      }
    end

    let(:browser) { 'firefox' }
    let(:mediawiki_api_url) { 'http://an.example/wiki/api.php' }
    let(:mediawiki_url) { 'http://an.example/wiki/' }
    let(:mediawiki_user) { 'mw user' }
    let(:mediawiki_password) { 'mw password' }

    describe '.load' do
      subject { Environment.load(name, extra) }

      let(:name) { 'foo' }
      let(:extra) { {} }

      before do
        expect(YAML).to receive(:load_file).with('environments.yml').
          and_return('foo' => { 'x' => 'a', 'y' => 'b' })
      end

      it 'returns a new environment' do
        expect(subject).to be_a(Environment)
      end

      it 'uses the given configuration in `environments.yml`' do
        expect(subject[:x]).to eq('a')
        expect(subject[:y]).to eq('b')
      end

      context 'when the given environment does not exist in `environments.yml`' do
        let(:name) { 'bar' }

        it 'raises a ConfigurationError' do
          expect { subject }.to raise_error(ConfigurationError, 'unknown environment `bar`')
        end
      end

      context 'when extra configuration is given' do
        let(:extra) { { x: 'c' } }

        it 'overwrites the loaded configuration' do
          expect(subject[:x]).to eq('c')
          expect(subject[:y]).to eq('b')
        end
      end
    end

    describe '.load_default' do
      subject { Environment.load_default }

      it 'loads the environment configuration specified by MEDIAWIKI_ENVIRONMENT' do
        expect(ENV).to receive(:[]).with('MEDIAWIKI_ENVIRONMENT').and_return('foo')
        expect(Environment).to receive(:load).with('foo', ENV)
        subject
      end

      context 'where MEDIAWIKI_ENVIRONMENT is not defined' do
        it 'looks for a "default" environment' do
          expect(ENV).to receive(:[]).with('MEDIAWIKI_ENVIRONMENT').and_return(nil)
          expect(Environment).to receive(:load).with('default', ENV)
          subject
        end
      end
    end

    describe '#==' do
      subject { env == other }

      context 'given an environment with the same configuration' do
        let(:other) { Environment.new(config) }

        it 'considers them equal' do
          expect(subject).to be(true)
        end
      end

      context 'given an environment with different configuration' do
        let(:other) { Environment.new(config.merge(some: 'extra')) }

        it 'considers them not equal' do
          expect(subject).to be(false)
        end
      end
    end

    describe '#as_user' do
      context 'when both an alternative user and password are defined' do
        let(:config) do
          {
            mediawiki_user: 'user',
            mediawiki_password: 'pass',
            mediawiki_user_b: 'user b',
            mediawiki_password_b: 'pass b'
          }
        end

        it 'yields the alternative user and password in the new environment' do
          expect { |block| env.as_user(:b, &block) }.to yield_with_args('user b', 'pass b')

          env.as_user(:b) do
            expect(env[:mediawiki_user]).to eq('user b')
            expect(env[:mediawiki_password]).to eq('pass b')
          end
        end
      end

      context "when an alternative for the password isn't defined" do
        let(:config) do
          {
            mediawiki_user: 'user',
            mediawiki_password: 'pass',
            mediawiki_user_b: 'user b'
          }
        end

        it 'falls back to using the base defined password' do
          expect { |block| env.as_user(:b, &block) }.to yield_with_args('user b', 'pass')

          env.as_user(:b) do
            expect(env[:mediawiki_user]).to eq('user b')
            expect(env[:mediawiki_password]).to eq('pass')
          end
        end
      end
    end

    describe '#browser_factory' do
      subject { env.browser_factory }

      it 'is a factory for the configured browser' do
        expect(subject).to be_a(BrowserFactory::Firefox)
      end

      context 'given an explicit type of browser' do
        subject { env.browser_factory(:chrome) }

        it 'is a factory for that type' do
          expect(subject).to be_a(BrowserFactory::Chrome)
        end
      end

      context 'caching in a cloned environment' do
        let(:env1) { env }
        let(:env2) { env1.clone }

        let(:factory1) { env.browser_factory(browser1) }
        let(:factory2) { env2.browser_factory(browser2) }

        context 'with the same local/remote behavior as before' do
          before do
            expect(env1).to receive(:remote?).at_least(:once).and_return(false)
            expect(env2).to receive(:remote?).at_least(:once).and_return(false)
          end

          context 'and the same type of browser as before' do
            let(:browser1) { :firefox }
            let(:browser2) { :firefox }

            it 'returns a cached factory' do
              expect(factory1).to be(factory2)
            end
          end

          context 'and a different type of browser than before' do
            let(:browser1) { :firefox }
            let(:browser2) { :chrome }

            it 'returns a new factory' do
              expect(factory1).not_to be(factory2)
            end
          end
        end

        context 'with different local/remote behavior as before' do
          before do
            expect(env1).to receive(:remote?).at_least(:once).and_return(false)
            expect(env2).to receive(:remote?).at_least(:once).and_return(true)
          end

          context 'but the same type of browser as before' do
            let(:browser1) { :firefox }
            let(:browser2) { :firefox }

            it 'returns a cached factory' do
              expect(factory1).not_to be(factory2)
            end
          end

          context 'and a different type of browser than before' do
            let(:browser1) { :firefox }
            let(:browser2) { :chrome }

            it 'returns a new factory' do
              expect(factory1).not_to be(factory2)
            end
          end
        end
      end
    end

    describe '#browser_name' do
      subject { env.browser_name }

      let(:browser) { 'Chrome' }

      it 'is always a lowercase symbol' do
        expect(subject).to be(:chrome)
      end

      context 'missing browser configuration' do
        let(:browser) { nil }

        it 'defaults to :firefox' do
          expect(subject).to be(:firefox)
        end
      end
    end

    describe '#env' do
      subject { env.env }

      it { is_expected.to be(env) }
    end

    describe '#in_browser' do
      it 'executes in the new environment with a new browser session' do
        expect { |block| env.in_browser(:a, &block) }.to yield_with_args(:a)

        env.in_browser(:a) do
          expect(env[:_browser_session]).to eq(:a)
        end
      end

      context 'given browser configuration overrides' do
        it 'executes in the new environment with the prefixed overrides' do
          expect { |block| env.in_browser(:a, language: 'eo', &block) }.
            to yield_with_args('eo', :a)

          env.in_browser(:a, language: 'eo') do
            expect(env[:browser_language]).to eq('eo')
            expect(env[:_browser_session]).to eq(:a)
          end
        end
      end
    end

    describe '#lookup' do
      subject { env.lookup(key, options) }

      let(:config) { { foo: 'foo_value', foo_b: 'foo_b_value', bar: 'bar_value' } }

      context 'for a key that exists' do
        let(:key) { :foo }
        let(:options) { {} }

        it 'returns the configuration' do
          expect(subject).to eq('foo_value')
        end
      end

      context "for a key that doesn't exist" do
        let(:key) { :baz }

        context 'given no default value' do
          let(:options) { {} }

          it 'raises a ConfigurationError' do
            expect { subject }.to raise_error(ConfigurationError)
          end
        end

        context 'given a default value' do
          let(:options) { { default: default } }
          let(:default) { double(Object) }

          it { is_expected.to be(default) }
        end
      end

      context 'for an alternative that exists' do
        let(:key) { :foo }
        let(:options) { { id: :b } }

        it 'returns the configured alternative' do
          expect(subject).to eq('foo_b_value')
        end
      end

      context "for an alternative that doesn't exist" do
        let(:key) { :foo }

        context 'given no default value' do
          let(:options) { { id: :c } }

          it 'raises a ConfigurationError' do
            expect { subject }.to raise_error(ConfigurationError)
          end
        end

        context 'given a default value' do
          let(:options) { { id: :c, default: default } }
          let(:default) { double(Object) }

          it { is_expected.to be(default) }
        end
      end
    end

    describe '#on_wiki' do
      let(:config) do
        {
          mediawiki_url: 'http://an.example/wiki',
          mediawiki_url_b: 'http://altb.example/wiki',
          mediawiki_url_c: 'http://altc.example/wiki'
        }
      end

      it 'executes in the new environment using the alternative wiki URL' do
        expect { |block| env.on_wiki(:b, &block) }.to yield_with_args('http://altb.example/wiki')

        env.on_wiki(:b) do
          expect(env[:mediawiki_url]).to eq('http://altb.example/wiki')
        end
      end
    end

    describe '#teardown' do
      subject { env.teardown(status) }

      let(:status) { :passed }
      let(:browser_instance) { double(Watir::Browser) }

      before do
        expect(env.browser_factory).to receive(:each) { |&blk| [browser_instance].each(&blk) }
        expect(env.browser_factory).to receive(:teardown).with(env, status)
      end

      it 'yields the given block and closes the browser' do
        expect(browser_instance).to receive(:close)
        expect { |blk| env.teardown(status, &blk) }.to yield_with_args(browser_instance)
      end

      context 'when keep_browser_open is set to "true"' do
        let(:config) { { keep_browser_open: 'true' } }

        it 'does not close the browser' do
          expect(browser_instance).not_to receive(:close)
          subject
        end

        context 'but browser is "phantomjs"' do
          let(:config) { { browser: 'phantomjs', keep_browser_open: 'true' } }

          it 'closes the browser anyway' do
            expect(browser_instance).to receive(:close)
            subject
          end
        end
      end
    end

    describe '#user' do
      subject { env.user(id) }

      let(:config) { { mediawiki_user: 'mw_user', mediawiki_user_b: 'mw_user_b' } }

      context 'given no alternative ID' do
        let(:id) { nil }

        it 'returns the configured :mediawiki_user' do
          expect(subject).to eq('mw_user')
        end
      end

      context 'given an alternative ID' do
        let(:id) { :b }

        it 'returns the configured alternative :mediawiki_user' do
          expect(subject).to eq('mw_user_b')
        end
      end
    end

    describe '#user_label' do
      subject { env.user_label(id) }

      let(:config) { { mediawiki_user: 'mw_user', mediawiki_user_b: 'mw_user_b' } }

      context 'given no alternative ID' do
        let(:id) { nil }

        it 'returns the configured :mediawiki_user with underscores replaced' do
          expect(subject).to eq('mw user')
        end
      end

      context 'given an alternative ID' do
        let(:id) { :b }

        it 'returns the configured alternative :mediawiki_user with underscores replaced' do
          expect(subject).to eq('mw user b')
        end
      end
    end

    describe '#wiki_url' do
      subject { env.wiki_url(url) }

      let(:env) { Environment.new(mediawiki_url: 'http://an.example/wiki/') }

      context 'with no given url' do
        let(:url) { nil }

        it 'is the configured :mediawiki_url' do
          expect(subject).to eq('http://an.example/wiki/')
        end
      end

      context 'when the given URL is a relative path' do
        let(:url) { 'some/path' }

        it 'is the configured :mediawiki_url with the path appended' do
          expect(subject).to eq('http://an.example/wiki/some/path')
        end
      end

      context 'when the given URL is an absolute path' do
        let(:url) { '/some/path' }

        it 'is the configured :mediawiki_url with the path replaced' do
          expect(subject).to eq('http://an.example/some/path')
        end
      end

      context 'when the given URL is an absolute URL' do
        let(:url) { 'http://another.example' }

        it 'is given absolute URL' do
          expect(subject).to eq('http://another.example')
        end
      end

      context 'when the given URL is a relative path with a namespace' do
        let(:url) { 'some:path' }

        it 'is the configured :mediawiki_url with the path replaced' do
          expect(subject).to eq('http://an.example/wiki/some:path')
        end
      end

    end

    describe '#with_alternative' do
      let(:config) do
        {
          mediawiki_url: 'http://a.example/wiki',
          mediawiki_url_b: 'http://b.example/wiki',
          mediawiki_api_url: 'http://a.example/api',
          mediawiki_api_url_b: 'http://b.example/api'
        }
      end

      context 'given one option name and an ID' do
        it 'executes in the new environment that substitutes it using the alternative' do
          expect { |block| env.with_alternative(:mediawiki_url, :b, &block) }.
            to yield_with_args('http://b.example/wiki')

          env.with_alternative(:mediawiki_url, :b) do
            expect(env[:mediawiki_url]).to eq('http://b.example/wiki')
          end
        end
      end

      context 'given multiple option names and an ID' do
        it 'executes in the new environment that substitutes both using the alternatives' do
          expect { |block| env.with_alternative([:mediawiki_url, :mediawiki_api_url], :b, &block) }.
            to yield_with_args('http://b.example/wiki', 'http://b.example/api')

          env.with_alternative([:mediawiki_url, :mediawiki_api_url], :b) do
            expect(env[:mediawiki_url]).to eq('http://b.example/wiki')
            expect(env[:mediawiki_api_url]).to eq('http://b.example/api')
          end
        end
      end

      context 'following block evaluation' do
        it 'restores the original configuration' do
          env.with_alternative(:mediawiki_url, :b)
          expect(env[:mediawiki_url]).to eq('http://a.example/wiki')
        end

        context 'when an exception is raised within the block' do
          it 'restores the original configuration and lets the exception be raised' do
            expect { env.with_alternative(:mediawiki_url, :b) { raise 'error' } }.to raise_error
            expect(env[:mediawiki_url]).to eq('http://a.example/wiki')
          end
        end
      end
    end
  end
end
