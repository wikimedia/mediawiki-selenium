require "spec_helper"

module MediawikiSelenium::BrowserFactory
  describe Phantomjs do
    let(:factory_class) { Phantomjs }
    let(:factory) { factory_class.new(:phantomjs) }

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

        it "sets phantomjs.page.customHeaders.Accept-Language to the given language" do
          capabilities = subject[:desired_capabilities]
          expect(capabilities["phantomjs.page.customHeaders.Accept-Language"]).to eq("eo")
        end
      end

      context "given a custom browser_user_agent" do
        let(:config) { { browser_user_agent: "FooBot" } }

        it "sets phantomjs.page.settings.userAgent to the given string" do
          capabilities = subject[:desired_capabilities]
          expect(capabilities["phantomjs.page.settings.userAgent"]).to eq("FooBot")
        end
      end
    end
  end
end
