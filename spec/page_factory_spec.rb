require 'spec_helper'

module MediawikiSelenium
  describe PageFactory do
    let(:env) { Environment.new(config).extend(PageFactory) }
    let(:config) { {} }

    it "also includes page-object's factory" do
      expect(env).to be_a(::PageObject::PageFactory)
    end

    describe '#on_page' do
      subject { env.on_page(page_class, { using_params: {} }, visit) }

      let(:page_class) { Class.new { include ::PageObject } }
      let(:visit) { false }

      let(:browser) { double('Watir::Browser') }

      it 'returns a new page object' do
        page = double('PageObject')
        expect(page_class).to receive(:new).and_return(page)
        expect(subject).to be(page)
      end

      context 'when given a block' do
        it 'yields it only once with a new page object' do
          page = double('PageObject')
          allow(page_class).to receive(:new).and_return(page)

          expect { |block| env.on_page(page_class, &block) }.to yield_control.once
          expect { |block| env.on_page(page_class, &block) }.to yield_with_args(page)
        end
      end

      context 'when told to visit a page' do
        let(:visit) { true }
        let(:config) { { mediawiki_url: 'http://an.example/wiki/' } }

        let(:page_object_platform) { double('PageObject::WatirPageObject') }

        before do
          expect(env).to receive(:browser)
          allow_any_instance_of(page_class).to receive(:initialize_browser)
        end

        context 'where the page URL is defined' do
          let(:page_class) do
            Class.new do
              include ::PageObject
              page_url 'Special:RandomPage'
            end
          end

          it 'qualifies the path with the configured :mediawiki_url' do
            expect_any_instance_of(page_class).to receive(:platform).
              and_return(page_object_platform)

            expect(page_object_platform).to receive(:navigate_to).
              with('http://an.example/wiki/Special:RandomPage')

            subject
          end
        end

        context 'where the page URL is undefined' do
          let(:page_class) do
            Class.new do
              include ::PageObject
            end
          end

          it 'never attempts to qualify one but still works' do
            expect { subject }.not_to raise_error
          end
        end
      end
    end
  end
end
