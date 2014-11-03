require "spec_helper"

module MediawikiSelenium::BrowserFactory
  describe Chrome do
    let(:factory_class) { Chrome }
    let(:factory) { factory_class.new(:chrome) }

    describe ".default_bindings" do
      subject { factory_class.default_bindings }

      it { is_expected.to include(:browser_language) }
      it { is_expected.not_to include(:browser_timeout) }
      it { is_expected.to include(:browser_user_agent) }
    end

    describe "#browser_options" do
      subject { factory.browser_options(config) }

      context "given a custom browser_language" do
        let(:config) { { browser_language: "eo" } }

        it "sets the intl.accept_languages preference to the given language" do
          expect(subject[:prefs]).to include("intl.accept_languages" => "eo")
        end
      end

      context "given a custom browser_user_agent" do
        let(:config) { { browser_user_agent: "FooBot" } }

        it "includes it as --user-agent in the chrome arguments" do
          expect(subject[:args]).to include("--user-agent=FooBot")
        end
      end
    end
  end
end
