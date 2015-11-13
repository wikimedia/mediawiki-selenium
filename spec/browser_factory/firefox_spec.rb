require 'spec_helper'

module MediawikiSelenium::BrowserFactory
  describe Firefox do
    let(:factory_class) { Firefox }
    let(:factory) { factory_class.new(:firefox) }

    describe '.default_bindings' do
      subject { factory_class.default_bindings }

      it { is_expected.to include(:browser_language) }
      it { is_expected.to include(:browser_timeout) }
      it { is_expected.to include(:browser_user_agent) }
    end

    describe '#browser_options' do
      subject { factory.browser_options(config) }

      let(:config) { {} }
      let(:profile) { double(Selenium::WebDriver::Firefox::Profile) }

      before do
        allow(Selenium::WebDriver::Firefox::Profile).to receive(:new).and_return(profile)
        allow(profile).to receive(:[]=)
      end

      it 'attempts to disable any firtrun page' do
        expect(profile).to receive(:[]=).with('browser.startup.homepage_override.mstone', 'ignore')

        subject
      end

      context 'given a browser proxy' do
        let(:config) { { browser_http_proxy: 'proxy.example:8080' } }

        it 'sets up the profile to use a proxy for both http and https' do
          selenium_proxy = double('Selenium::WebDriver::Proxy')

          expect(Selenium::WebDriver::Proxy).to receive(:new).
            with(http: 'proxy.example:8080', ssl: 'proxy.example:8080').
            and_return(selenium_proxy)
          expect(profile).to receive(:proxy=).with(selenium_proxy)

          subject
        end
      end

      context 'given a custom browser_timeout' do
        let(:config) { { browser_timeout: '30' } }

        it 'sets dom.max_script_run_time to the given number' do
          expect(profile).to receive(:[]=).with('dom.max_script_run_time', 30)
          subject
        end

        it 'sets dom.max_chrome_script_run_time to the given number' do
          expect(profile).to receive(:[]=).with('dom.max_chrome_script_run_time', 30)
          subject
        end
      end

      context 'given a custom browser_language' do
        let(:config) { { browser_language: 'eo' } }

        it 'sets intl.accept_languages to the given language' do
          expect(profile).to receive(:[]=).with('intl.accept_languages', 'eo')
          subject
        end
      end

      context 'given a custom browser_user_agent' do
        let(:config) { { browser_user_agent: 'FooBot' } }

        it 'sets general.useragent.override to the given string' do
          expect(profile).to receive(:[]=).with('general.useragent.override', 'FooBot')
          subject
        end
      end
    end
  end
end
