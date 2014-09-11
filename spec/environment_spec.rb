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
        let(:other) { Environment.new(env.config) }

        it "considers them equal" do
          expect(subject).to be(true)
        end
      end

      context "given an environment with different configuration" do
        let(:other) { Environment.new(env.config.merge(some: "extra")) }

        it "considers them not equal" do
          expect(subject).to be(false)
        end
      end
    end

    describe "#as_user" do
      let(:config) do
        {
          mediawiki_user: "user",
          mediawiki_password: "pass",
          mediawiki_user_b: "user b",
          mediawiki_password_b: "pass b",
        }
      end

      it "yields a new environment for the alternative user and its password" do
        expected_env = Environment.new(config.merge(
          mediawiki_user: "user b",
          mediawiki_password: "pass b",
        ))
        expect { |block| env.as_user(:b, &block) }.to yield_with_args(expected_env)
      end
    end

    describe "#browser_factory" do
      subject { env.browser_factory }

      it "is a factory for the configured browser" do
        expect(subject).to be_a(BrowserFactory::Firefox)
      end

      it "binds the core browser options" do
        expect(subject.bindings).to include(*Environment::CORE_BROWSER_OPTIONS)
      end

      context "given a type" do
        subject { env.browser_factory(:chrome) }

        it "is a factory for that type" do
          expect(subject).to be_a(BrowserFactory::Chrome)
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
          expect { subject }.to raise_error(Environment::ConfigurationError)
        end
      end
    end

    describe "#on_wiki" do
      let(:config) do
        {
          mediawiki_url: "http://an.example/wiki",
          mediawiki_url_b: "http://alt.example/wiki",
          mediawiki_api_url: "http://an.example/api",
          mediawiki_api_url_b: "http://alt.example/api",
        }
      end

      it "yields a new environment for the alternative wiki and API urls" do
        expected_env = Environment.new(config.merge(
          mediawiki_url: "http://alt.example/wiki",
          mediawiki_api_url: "http://alt.example/api",
        ))
        expect { |block| env.on_wiki(:b, &block) }.to yield_with_args(expected_env)
      end
    end

    describe "#with_alternative" do
      let(:config) do
        {
          mediawiki_url: "http://an.example/wiki",
          mediawiki_url_b: "http://alt.example/wiki",
          mediawiki_api_url: "http://an.example/api",
          mediawiki_api_url_b: "http://alt.example/api",
        }
      end

      context "given one option name and an ID" do
        let(:names) { :mediawiki_url }

        it "yields an environment that substitutes it using the alternative" do
          expected_env = Environment.new(config.merge(
            mediawiki_url: "http://alt.example/wiki",
          ))
          expect { |block| env.with_alternative(names, :b, &block) }.to yield_with_args(expected_env)
        end
      end

      context "given multiple option names and an ID" do
        let(:names) { [:mediawiki_url, :mediawiki_api_url] }

        it "yields an environment that substitutes both using the alternatives" do
          expected_env = Environment.new(config.merge(
            mediawiki_url: "http://alt.example/wiki",
            mediawiki_api_url: "http://alt.example/api",
          ))
          expect { |block| env.with_alternative(names, :b, &block) }.to yield_with_args(expected_env)
        end
      end
    end
  end
end
