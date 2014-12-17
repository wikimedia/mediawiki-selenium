require "spec_helper"

module MediawikiSelenium
  describe ApiHelper do
    let(:env) { Environment.new(config).extend(ApiHelper) }

    let(:config) do
      {
        mediawiki_url: wiki_url,
        mediawiki_url_b: alternative_wiki_url,
        mediawiki_api_url: api_url,
        mediawiki_api_url_b: alternative_api_url,
        mediawiki_user: "mw user",
        mediawiki_password: "mw password"
      }
    end

    describe "#api" do
      subject { env.api }

      let(:wiki_url) { "http://an.example/wiki/" }
      let(:api_url) { "http://an.example/api" }
      let(:alternative_wiki_url) { "http://another.example/wiki/" }
      let(:alternative_api_url) { "" }

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
      end
    end

    describe "#on_wiki" do
      let(:wiki_url) { "http://an.example/wiki/" }
      let(:api_url) { "http://an.example/api" }
      let(:alternative_wiki_url) { "http://another.example/wiki/" }

      context "and the given alternative API URL is configured" do
        let(:alternative_api_url) { "http://another.example/api" }

        it "executes in the new environment using the alternative wiki and API URL" do
          expect { |block| env.on_wiki(:b, &block) }.
            to yield_with_args(alternative_wiki_url, alternative_api_url)

          env.on_wiki(:b) do
            expect(env[:mediawiki_url]).to eq(alternative_wiki_url)
            expect(env[:mediawiki_api_url]).to eq(alternative_api_url)
          end
        end
      end

      context "and no explicit API URL is configured for the wiki" do
        let(:alternative_api_url) { "" }

        it "constructs one at /w/api.php relative to the wiki URL" do
          expect { |block| env.on_wiki(:b, &block) }.
            to yield_with_args(alternative_wiki_url, "http://another.example/w/api.php")

          env.on_wiki(:b) do
            expect(env[:mediawiki_url]).to eq(alternative_wiki_url)
            expect(env[:mediawiki_api_url]).to eq("http://another.example/w/api.php")
          end
        end
      end
    end
  end
end
