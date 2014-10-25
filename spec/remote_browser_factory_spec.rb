require "spec_helper"
require "mediawiki_selenium/browser_factory/base"

module MediawikiSelenium
  describe RemoteBrowserFactory do
    let(:factory_class) { Class.new(BrowserFactory::Base) }
    let(:factory) { factory_class.new(:foo).extend(RemoteBrowserFactory) }

    describe "#browser_options" do
      subject { factory.browser_options(config) }

      let(:config) { {} }
      let(:capabilities) { double(Selenium::WebDriver::Remote::Capabilities) }

      before do
        expect(Selenium::WebDriver::Remote::Capabilities).to receive(:foo).and_return(capabilities)
      end

      context "given a sauce_ondemand_username and sauce_ondemand_access_key" do
        let(:config) { { sauce_ondemand_username: "foo", sauce_ondemand_access_key: "bar" } }

        it "configures the remote webdriver url" do
          expect(subject[:url]).to eq(URI.parse("http://foo:bar@ondemand.saucelabs.com/wd/hub"))
        end
      end

      context "given a browser platform" do
        let(:config) { { platform: "foo" } }

        it "configures the browser platform" do
          expect(capabilities).to receive(:platform=).with("foo")
          subject
        end
      end

      context "given a browser version" do
        let(:config) { { version: "123" } }

        it "configures the browser version" do
          expect(capabilities).to receive(:version=).with("123")
          subject
        end
      end
    end
  end
end
