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

      let(:profile) { double(Selenium::WebDriver::Chrome::Profile) }
      let(:profile_hash) { double(Hash) }

      before do
        expect(Selenium::WebDriver::Chrome::Profile).to receive(:new).and_return(profile)
        expect(profile).to receive(:as_json).and_return(profile_hash)
        expect(profile_hash).to receive(:[]).with("zip")
      end

      context "given a custom browser_language" do
        let(:config) { { browser_language: "eo" } }

        it "sets intl.accept_languages to the given language" do
          expect(profile).to receive(:[]=).with("intl.accept_languages", "eo")
          subject
        end
      end

      context "given a custom browser_user_agent" do
        let(:config) { { browser_user_agent: "FooBot" } }

        it "includes it as --user-agent in the chrome arguments" do
          arguments = subject[:desired_capabilities]["chromeOptions"]["args"]
          expect(arguments).to include("--user-agent=FooBot")
        end
      end
    end
  end
end
