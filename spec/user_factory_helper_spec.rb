require 'spec_helper'

module MediawikiSelenium
  describe UserFactoryHelper do
    let(:env) { Environment.new(config).extend(ApiHelper, UserFactoryHelper) }

    let(:api_url) { 'http://an.example/api' }
    let(:api) { double('MediawikiApi::Client') }

    [:user, :password].each do |method|
      describe "##{method}" do
        subject { env.send(method, id) }

        context 'when the `user_factory` option is enabled' do
          let(:config) { { mediawiki_api_url: api_url, user_factory: true } }

          before do
            expect(MediawikiApi::Client).to receive(:new).with(api_url).and_return(api)
          end

          context 'given no alternative ID' do
            let(:id) { nil }

            it 'creates the primary account and returns the name' do
              expect(api).to receive(:create_account)

              expect(subject).to be_a(String)
            end
          end

          context 'given an existing alternative ID' do
            let(:id) { :b }

            it 'creates the alternative account and returns the name' do
              expect(api).to receive(:create_account)

              expect(subject).to be_a(String)
            end

            it 'should be different from the primary account' do
              expect(api).to receive(:create_account).twice

              expect(subject).not_to eq(env.user)
            end
          end
        end

        context 'when the `user_factory` option is not enabled' do
          let(:config) { { mediawiki_api_url: api_url, user_factory: false } }
          let(:id) { nil }

          it "delegates to `Environment##{method}`" do
            expect { subject }.to raise_error(ConfigurationError)
          end
        end
      end
    end
  end
end
