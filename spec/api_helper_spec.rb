require "spec_helper"

module MediawikiSelenium
  describe ApiHelper do
    let(:env) { Environment.new(config).extend(ApiHelper) }

    let(:config) do
      {
        mediawiki_url: "http://an.example/wiki/",
        mediawiki_api_url: api_url,
        mediawiki_api_url_b: alternative_api_url,
        mediawiki_user: "mw user",
        mediawiki_password: "mw password"
      }
    end

    let(:api_url) { "http://an.example/api" }
    let(:alternative_api_url) { "" }

    describe "#api" do
      subject { env.api }

      let(:client) { double(MediawikiApi::Client) }

      before do
        expect(MediawikiApi::Client).to receive(:new).with(api_url).and_return(client)
        expect(client).to receive(:log_in).with("mw user", "mw password")
      end

      context "called for the first time" do
        it "returns a new client" do
          expect(subject).to be(client)
        end
      end

      context "called subsequently" do
        before do
          env.api
        end

        it "returns a cached client" do
          expect(subject).to be(client)
        end

        context "from an altered environment" do
          subject { env2.api }

          let(:env2) { env.with_alternative(:mediawiki_api_url, :b) }

          context "with the same API URL" do
            let(:alternative_api_url) { api_url }

            it "returns a cached client" do
              expect(subject).to be(client)
            end
          end

          context "with a different API URL" do
            let(:alternative_api_url) { "http://another.example/api" }

            let(:client2) { double(MediawikiApi::Client) }

            before do
              expect(MediawikiApi::Client).to receive(:new).with(alternative_api_url).and_return(client2)
              expect(client2).to receive(:log_in).with("mw user", "mw password")
            end

            it "returns a new client" do
              expect(subject).not_to be(client)
            end
          end
        end
      end
    end
  end
end
