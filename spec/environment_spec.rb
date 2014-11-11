require "spec_helper"

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
        mediawiki_password: mediawiki_password,
      }
    end

    let(:browser) { "firefox" }
    let(:mediawiki_api_url) { "http://an.example/wiki/api.php" }
    let(:mediawiki_url) { "http://an.example/wiki/" }
    let(:mediawiki_user) { "mw user" }
    let(:mediawiki_password) { "mw password" }

    describe "#==" do
      subject { env == other }

      context "given an environment with the same configuration" do
        let(:other) { Environment.new(config) }

        it "considers them equal" do
          expect(subject).to be(true)
        end
      end

      context "given an environment with different configuration" do
        let(:other) { Environment.new(config.merge(some: "extra")) }

        it "considers them not equal" do
          expect(subject).to be(false)
        end
      end
    end

    describe "#as_user" do
      subject { env.as_user(:b) {} }

      let(:config) do
        {
          mediawiki_user: "user",
          mediawiki_password: "pass",
          mediawiki_user_b: "user b",
          mediawiki_password_b: "pass b",
        }
      end

      let(:new_env) { double(Environment) }
      let(:new_config) { double(Hash) }

      before do
        expect(env).to receive(:clone).and_return(new_env)
        expect(new_env).to receive(:config).and_return(new_config)
      end

      it "executes in the new environment for the alternative user and its password" do
        expect(new_config).to receive(:merge!).with(
          mediawiki_user: "user b",
          mediawiki_password: "pass b",
        )
        expect(new_env).to receive(:instance_exec).with("user b", "pass b")
        subject
      end
    end

    describe "#browser_factory" do
      subject { env.browser_factory }

      it "is a factory for the configured browser" do
        expect(subject).to be_a(BrowserFactory::Firefox)
      end

      context "given an explicit type of browser" do
        subject { env.browser_factory(:chrome) }

        it "is a factory for that type" do
          expect(subject).to be_a(BrowserFactory::Chrome)
        end
      end

      context "caching in a cloned environment" do
        let(:env1) { env }
        let(:env2) { env1.clone }

        let(:factory1) { env.browser_factory(browser1) }
        let(:factory2) { env2.browser_factory(browser2) }

        context "with the same local/remote behavior as before" do
          before do
            expect(env1).to receive(:remote?).at_least(:once).and_return(false)
            expect(env2).to receive(:remote?).at_least(:once).and_return(false)
          end

          context "and the same type of browser as before" do
            let(:browser1) { :firefox }
            let(:browser2) { :firefox }

            it "returns a cached factory" do
              expect(factory1).to be(factory2)
            end
          end

          context "and a different type of browser than before" do
            let(:browser1) { :firefox }
            let(:browser2) { :chrome }

            it "returns a new factory" do
              expect(factory1).not_to be(factory2)
            end
          end
        end

        context "with different local/remote behavior as before" do
          before do
            expect(env1).to receive(:remote?).at_least(:once).and_return(false)
            expect(env2).to receive(:remote?).at_least(:once).and_return(true)
          end

          context "but the same type of browser as before" do
            let(:browser1) { :firefox }
            let(:browser2) { :firefox }

            it "returns a cached factory" do
              expect(factory1).not_to be(factory2)
            end
          end

          context "and a different type of browser than before" do
            let(:browser1) { :firefox }
            let(:browser2) { :chrome }

            it "returns a new factory" do
              expect(factory1).not_to be(factory2)
            end
          end
        end
      end
    end

    describe "#browser_name" do
      subject { env.browser_name }

      let(:browser) { "Firefox" }

      it "is always a lowercase symbol" do
        expect(subject).to be(:firefox)
      end

      context "missing browser configuration" do
        let(:browser) { nil }

        it "raises a ConfigurationError" do
          expect { subject }.to raise_error(ConfigurationError)
        end
      end
    end

    describe "#env" do
      subject { env.env }

      it { is_expected.to be(env) }
    end

    describe "#in_browser" do
      subject { env.in_browser(id, overrides) {} }

      let(:id) { :a }
      let(:overrides) { {} }

      let(:new_env) { double(Environment) }
      let(:new_config) { double(Hash) }

      before do
        expect(env).to receive(:clone).and_return(new_env)
        expect(new_env).to receive(:config).and_return(new_config)
      end

      it "executes in the new environment with a new browser session" do
        expect(new_config).to receive(:merge!).with(_browser_session: id)
        expect(new_env).to receive(:instance_exec).with(id)
        subject
      end

      context "given browser configuration overrides" do
        let(:overrides) { { language: "eo" } }

        it "executes in the new environment with the prefixed overrides" do
          expect(new_config).to receive(:merge!).with(_browser_session: id, browser_language: "eo")
          expect(new_env).to receive(:instance_exec).with("eo", id)
          subject
        end
      end
    end

    describe "#lookup" do
      subject { env.lookup(key, options) }

      let(:config) { { foo: "foo_value", foo_b: "foo_b_value", bar: "bar_value" } }

      context "for a key that exists" do
        let(:key) { :foo }
        let(:options) { {} }

        it "returns the configuration" do
          expect(subject).to eq("foo_value")
        end
      end

      context "for a key that doesn't exist" do
        let(:key) { :baz }

        context "given no default value" do
          let(:options) { {} }

          it "raises a ConfigurationError" do
            expect { subject }.to raise_error(ConfigurationError)
          end
        end

        context "given a default value" do
          let(:options) { { default: default } }
          let(:default) { double(Object) }

          it { is_expected.to be(default) }
        end
      end

      context "for an alternative that exists" do
        let(:key) { :foo }
        let(:options) { { id: :b } }

        it "returns the configured alternative" do
          expect(subject).to eq("foo_b_value")
        end
      end

      context "for an alternative that doesn't exist" do
        let(:key) { :foo }

        context "given no default value" do
          let(:options) { { id: :c } }

          it "raises a ConfigurationError" do
            expect { subject }.to raise_error(ConfigurationError)
          end
        end

        context "given a default value" do
          let(:options) { { id: :c, default: default } }
          let(:default) { double(Object) }

          it { is_expected.to be(default) }
        end
      end
    end

    describe "#on_wiki" do
      subject { env.on_wiki(:b) {} }

      let(:config) do
        {
          mediawiki_url: "http://an.example/wiki",
          mediawiki_url_b: "http://alt.example/wiki",
          mediawiki_api_url: "http://an.example/api",
          mediawiki_api_url_b: "http://alt.example/api",
        }
      end

      let(:new_env) { double(Environment) }
      let(:new_config) { double(Hash) }

      before do
        expect(env).to receive(:clone).and_return(new_env)
        expect(new_env).to receive(:config).and_return(new_config)
      end

      it "executes in the new environment using the alternative wiki and API urls" do
        expect(new_config).to receive(:merge!).with(
          mediawiki_url: "http://alt.example/wiki",
          mediawiki_api_url: "http://alt.example/api"
        )
        expect(new_env).to receive(:instance_exec).with(
          "http://alt.example/wiki",
          "http://alt.example/api"
        )
        subject
      end
    end

    describe "#user" do
      subject { env.user(id) }

      let(:config) { { mediawiki_user: "mw_user", mediawiki_user_b: "mw_user_b" } }

      context "given no alternative ID" do
        let(:id) { nil }

        it "returns the configured :mediawiki_user" do
          expect(subject).to eq("mw_user")
        end
      end

      context "given an alternative ID" do
        let(:id) { :b }

        it "returns the configured alternative :mediawiki_user" do
          expect(subject).to eq("mw_user_b")
        end
      end
    end

    describe "#user_label" do
      subject { env.user_label(id) }

      let(:config) { { mediawiki_user: "mw_user", mediawiki_user_b: "mw_user_b" } }

      context "given no alternative ID" do
        let(:id) { nil }

        it "returns the configured :mediawiki_user with underscores replaced" do
          expect(subject).to eq("mw user")
        end
      end

      context "given an alternative ID" do
        let(:id) { :b }

        it "returns the configured alternative :mediawiki_user with underscores replaced" do
          expect(subject).to eq("mw user b")
        end
      end
    end

    describe "#wiki_url" do
      subject { env.wiki_url(url) }

      let(:env) { Environment.new(mediawiki_url: "http://an.example/wiki/") }

      context "with no given url" do
        let(:url) { nil }

        it "is the configured :mediawiki_url" do
          expect(subject).to eq("http://an.example/wiki/")
        end
      end

      context "when the given URL is a relative path" do
        let(:url) { "some/path" }

        it "is the configured :mediawiki_url with the path appended" do
          expect(subject).to eq("http://an.example/wiki/some/path")
        end
      end

      context "when the given URL is an absolute path" do
        let(:url) { "/some/path" }

        it "is the configured :mediawiki_url with the path replaced" do
          expect(subject).to eq("http://an.example/some/path")
        end
      end

      context "when the given URL is an absolute URL" do
        let(:url) { "http://another.example" }

        it "is given absolute URL" do
          expect(subject).to eq("http://another.example")
        end
      end

      context "when the given URL is a relative path with a namespace" do
        let(:url) { "some:path" }

        it "is the configured :mediawiki_url with the path replaced" do
          expect(subject).to eq("http://an.example/wiki/some:path")
        end
      end

    end

    describe "#with_alternative" do
      subject { env.with_alternative(names, id) {} }

      let(:config) do
        {
          mediawiki_url: "http://an.example/wiki",
          mediawiki_url_b: "http://alt.example/wiki",
          mediawiki_api_url: "http://an.example/api",
          mediawiki_api_url_b: "http://alt.example/api",
        }
      end

      let(:new_env) { double(Environment) }
      let(:new_config) { double(Hash) }

      before do
        expect(env).to receive(:clone).and_return(new_env)
        expect(new_env).to receive(:config).and_return(new_config)
      end

      context "given one option name and an ID" do
        let(:names) { :mediawiki_url }
        let(:id) { :b }

        it "executes in the new environment that substitutes it using the alternative" do
          expect(new_config).to receive(:merge!).with(mediawiki_url: "http://alt.example/wiki")
          expect(new_env).to receive(:instance_exec).with("http://alt.example/wiki")
          subject
        end
      end

      context "given multiple option names and an ID" do
        let(:names) { [:mediawiki_url, :mediawiki_api_url] }
        let(:id) { :b }

        it "executes in the new environment that substitutes both using the alternatives" do
          expect(new_config).to receive(:merge!).with(
            mediawiki_url: "http://alt.example/wiki",
            mediawiki_api_url: "http://alt.example/api"
          )
          expect(new_env).to receive(:instance_exec).with(
            "http://alt.example/wiki",
            "http://alt.example/api"
          )
          subject
        end
      end
    end
  end
end
