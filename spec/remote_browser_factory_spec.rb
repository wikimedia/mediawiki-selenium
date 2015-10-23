require 'rest_client'
require 'spec_helper'

require 'mediawiki_selenium/browser_factory/base'

module MediawikiSelenium
  describe RemoteBrowserFactory do
    subject { factory }

    let(:factory_class) { Class.new(BrowserFactory::Base) }
    let(:factory) { factory_class.new(:foo).extend(RemoteBrowserFactory) }

    it { is_expected.to be_a(RemoteBrowserFactory) }

    describe '#browser_options' do
      subject { factory.browser_options(config) }

      let(:config) { {} }
      let(:capabilities) { double(Selenium::WebDriver::Remote::Capabilities) }

      before do
        expect(Selenium::WebDriver::Remote::Capabilities).to receive(:foo).and_return(capabilities)
      end

      context 'given a sauce_ondemand_username and sauce_ondemand_access_key' do
        let(:config) { { sauce_ondemand_username: 'foo', sauce_ondemand_access_key: 'bar' } }

        it 'configures the remote webdriver url' do
          expect(subject[:url]).to eq(URI.parse('http://foo:bar@ondemand.saucelabs.com/wd/hub'))
        end
      end

      context 'given a browser platform' do
        let(:config) { { platform: 'foo' } }

        it 'configures the browser platform' do
          expect(capabilities).to receive(:platform=).with('foo')
          subject
        end
      end

      context 'given a browser version' do
        let(:config) { { version: '123' } }

        it 'configures the browser version' do
          expect(capabilities).to receive(:version=).with('123')
          subject
        end
      end
    end

    describe '#teardown' do
      subject { factory.teardown(env, status) }

      let(:config) do
        {
          sauce_ondemand_username: 'foo',
          sauce_ondemand_access_key: 'bar',
          build_number: 'b123'
        }
      end

      let(:env) { Environment.new(config) }
      let(:status) { :passed }

      before do
        browser = double('Watir::Browser')
        driver = double('Selenium::WebDriver::Driver')

        expect(factory).to receive(:each).and_yield(browser)
        expect(browser).to receive(:driver).and_return(driver)
        expect(driver).to receive(:session_id).and_return('123')
      end

      it 'updates the SauceLabs session for each browser and returns the URL as an artifact' do
        expect(RestClient::Request).to receive(:execute).with(
          method: :put,
          url: 'https://saucelabs.com/rest/v1/foo/jobs/123',
          user: 'foo',
          password: 'bar',
          headers: { content_type: 'application/json' },
          payload: '{"public":true,"passed":true,"build":"b123"}'
        )

        expect(subject).to include('http://saucelabs.com/jobs/123')
        expect(subject['http://saucelabs.com/jobs/123']).to eq('text/url')
      end
    end
  end
end
