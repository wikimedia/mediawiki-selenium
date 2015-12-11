require 'spec_helper'

module MediawikiSelenium
  describe BrowserFactory do
    describe '.new' do
      context 'given a browser that has a specific implementation' do
        subject { BrowserFactory.new(:firefox) }

        it 'instantiates the concrete factory class' do
          expect(subject).to be_a(BrowserFactory::Firefox)
        end
      end

      context 'given a browser that has no specific implementation' do
        subject { BrowserFactory.new(:lynx) }

        it { is_expected.to be_a(BrowserFactory::Base) }
      end
    end
  end
end
